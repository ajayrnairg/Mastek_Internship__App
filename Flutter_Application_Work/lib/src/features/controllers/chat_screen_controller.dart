import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:rough_app/src/constants/image_strings.dart';
import 'package:rough_app/src/features/screens/chat_screen/chat_main_screen.dart';
import 'package:rough_app/src/utils/services/database.dart';

import '../../constants/text_strings.dart';
import '../../utils/apis/TextToSpeechAPI.dart';
import '../../utils/apis/speechToText.dart';
import '../../utils/apis/translation_api.dart';
import '../../utils/helperfunctions/languages.dart';
import '../../utils/helperfunctions/voiceAndLanguages.dart';
import '../../utils/services/notification_services.dart';

class ChatScreenController extends GetxController {
  static ChatScreenController get find => Get.find();

  String? selectedUserID,
      selectedUserName,
      selectedUserDisplayName,
      selectedUserProfilePicURL,
      selectedUserEmail,
      selectedUserToken;

  String chatRoomID = "";
  String messageID = "";

  bool isAnyMessageSelected = false;
  int? selectedMessageIndex;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  List<Map<String, String>> combinedMessages = [];

  TextEditingController messageTextEditingController = TextEditingController();

  NotificationServices notificationServices = NotificationServices();



  //helper methods
  void printData() {
    print("--------Combined Messages----------");
    print(combinedMessages);
  }

  void clearData() {
    combinedMessages = [];
  }

  void deselectMessage() {
    isAnyMessageSelected = false;
    selectedMessageIndex = null;
  }

  void addSelectedMessageToClipboard() async {
    String messageText =
        (combinedMessages[selectedMessageIndex!]["message_translation_text"])!;
    await Clipboard.setData(ClipboardData(text: messageText));
  }

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<String> translateText(String message, String language) async {
    return await TranslationApi.translate(
        message, Languages.getLanguageCode(language));
  }

  Future<String> getSpeechToTextResults(
      String audioPath, String language) async {
    return await STT()
        .transcribe(audioPath, Languages.getLanguageCode(language));
  }

  Future<String> textToSpeechPath(
      String text, String filename, String toLanguage) async {
    final nameLangCode =
        VoiceAndLanguages.getVoiceAndLanguageCode(toLanguage, "FEMALE");

    final String audioContent = await TextToSpeechAPI()
        .synthesizeText(text, nameLangCode[0], nameLangCode[1]);
    print("audiocontent is $audioContent");
    final bytes =
        const Base64Decoder().convert(audioContent, 0, audioContent.length);

    final file = File('$filename.wav');
    await file.writeAsBytes(bytes);
    print(file.path);

    return file.path;
  }

  //Methods involving local DSA
  Future<void> buildAndAddDataToLocalDSA(
    String selectedLanguage,
    String messageID,
    String messageText,
    String messageLanguage,
    String sendBy,
    String? senderProfilePic,
    String timeStamp,
  ) async {
    String translatedText = "";
    if (messageLanguage != selectedLanguage) {
      translatedText = await translateText(messageText, selectedLanguage);
    } else {
      translatedText = messageText;
    }

    Map<String, String> messageInfoMap = {
      "message_local_id": "${combinedMessages.length}",
      "message_id": messageID,
      "message_sent_by": sendBy,
      "message_sender_profilePic":
          (senderProfilePic != null) ? senderProfilePic : "",
      "message_original_language": messageLanguage,
      "message_original_text": messageText,
      "message_translation_language": selectedLanguage,
      "message_translation_text": translatedText,
      "message_translation_audio_content": "",
      "message_timestamp": timeStamp
    };

    if (selectedMessageIndex != null) //corner case
    {
      selectedMessageIndex = selectedMessageIndex! + 1;
    }
    combinedMessages.insert(0, messageInfoMap);
  }

  Future<String> getOrCreateTranslationAudioPath(
      String messageId, String toLanguage) async {
    String audioPath = "message_translation_audio_content";

    if (combinedMessages[int.parse(messageId)][audioPath] != "") {
      return combinedMessages[int.parse(messageId)][audioPath]!.trim();
    } else {
      final tempPath = await _localPath;
      String filepath = await textToSpeechPath(
          combinedMessages[int.parse(messageId)]["message_translation_text"]!,
          "$tempPath/$messageId-Translated",
          toLanguage);

      combinedMessages[int.parse(messageId)][audioPath] = filepath.trim();

      return filepath.trim();
    }
  }

  Future<void> playSelectedMessageAsAudio(String selectedLanguage) async {
    String filepath = await getOrCreateTranslationAudioPath(
        "$selectedMessageIndex", selectedLanguage);
    await audioPlayer.play(DeviceFileSource(filepath));
  }

  //Methods involving firebase
  String getChatRoomIdByUsernames(String userA, String userB) {
    if (userA.substring(0, 1).codeUnitAt(0) >
        userB.substring(0, 1).codeUnitAt(0)) {
      return "${userB}_$userA";
    } else {
      return "${userA}_$userB";
    }
  }

  inviteUserToChatRoom() async{
    chatRoomID = getChatRoomIdByUsernames(gAccountUserName, selectedUserName!);
    Map<String,dynamic> roomDetails = {
      "roomID": chatRoomID,
      "roomType": "chatRoom"
    };
    Map<String,dynamic> senderDetails = {
      "UserID": gAccountID,
      "UserEmail": gAccountEmail,
      "UserName": gAccountUserName,
      "UserDisplayName": gAccountName,
      "UserProfilePic": (gUser_icon_image != null)? gUser_icon_image : "",
    };
    notificationServices.sendPushNotificationToUser(selectedUserToken!, roomDetails, senderDetails);

  }



  generateChatRoom() async {
    chatRoomID = getChatRoomIdByUsernames(gAccountUserName, selectedUserName!);
    Map<String, dynamic> chatRoomInfoMap = {
      "roomID": chatRoomID,
      "createdBy": gAccountUserName,
      "members": [gAccountUserName, selectedUserName]
    };

    await DatabaseMethods().createChatRoom(chatRoomID, chatRoomInfoMap);
  }

  deleteChatRoom() async {
    await DatabaseMethods().deleteChatRoom(chatRoomID);
  }

  addMessage(String selectedLanguage, bool isAudioMessage) async {
    if (messageTextEditingController.text.trim() != "" || isAudioMessage) {
      final tempPath = await _localPath;
      String? filePath = '$tempPath/ChatScreen-Original.wav';
      String message = messageTextEditingController.text;
      var messageTimeStamp = DateTime.now();

      if (messageID == "") {
        messageID = randomAlphaNumeric(12);
      }

      if (isAudioMessage) {
        message = await getSpeechToTextResults(filePath, selectedLanguage);
      }
      if (message == "") {
        print("error getting speech from audio");
        return;
      }

      Map<String, dynamic> messageInfoMap = {
        "message_id": messageID,
        "message_text": message,
        "message_text_language": selectedLanguage,
        "sendBy": gAccountUserName,
        "senderImageURL": gUser_icon_image,
        "message_timestamp": messageTimeStamp,
      };

      DatabaseMethods()
          .addMessageToChatRoom(chatRoomID, messageID, messageInfoMap)
          .then((value) {
        messageTextEditingController.text = "";
        messageID = "";
      });
    }
  }

  //Navigation functions
  goToChatMainScreenFunc(selectedLanguage, controller) {
    Get.to(() => ChatMainScreen(
        selectedLanguage: selectedLanguage, chatScreenController: controller));
  }

  goBackOnePageFunc() {
    Get.back();
  }
}

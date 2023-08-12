import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/screens/group_chat_screen/group_chat_main_screen.dart';
import 'package:rough_app/src/features/screens/group_chat_screen/group_chat_screen.dart';
import 'package:rough_app/src/features/screens/group_chat_screen/manages_members_screen.dart';
import 'package:rough_app/src/utils/services/database.dart';

import '../../constants/image_strings.dart';
import '../../utils/apis/TextToSpeechAPI.dart';
import '../../utils/apis/speechToText.dart';
import '../../utils/apis/translation_api.dart';
import '../../utils/helperfunctions/languages.dart';
import '../../utils/helperfunctions/voiceAndLanguages.dart';
import '../../utils/services/notification_services.dart';

class GroupChatScreenController extends GetxController {
  static GroupChatScreenController get find => Get.find();

  TextEditingController messageTextEditingController = TextEditingController();

  NotificationServices notificationServices = NotificationServices();

  List<Map<String, String>> combinedMessages = [];

  bool isAnyMessageSelected = false;
  int? selectedMessageIndex;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  //group Details
  String? groupID, groupName, groupCreatorUserName;
  String messageID = "";

  // late List<dynamic> groupMembers;

  Map<String, dynamic> otherGroupMemberInfo = {};

  //helper methods
  void printData() {
    print("--------Combined Messages----------");
    print(combinedMessages);
  }

  void clearData() {
    otherGroupMemberInfo = {};
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

  //Local DB methods
  Future<void> updateSingleGroupMemberInfo(String userName) async {
    if (userName != gAccountUserName) {
      DocumentSnapshot? userDetailsSnapshot =
          await DatabaseMethods().getSingleUserByUserName(userName);
      if (userDetailsSnapshot != null) {
        otherGroupMemberInfo[userName] = {
          "userID": userDetailsSnapshot["id"],
          "userName": userDetailsSnapshot["username"],
          "userDisplayName": userDetailsSnapshot["displayname"],
          "userEmail": userDetailsSnapshot["email"],
          "userProfilePicURL": userDetailsSnapshot["profileURL"],
          "userToken": userDetailsSnapshot["token"]
        };
      }
    }
  }

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

  // Database methods
  createNewGroup(String groupName) async {
    var creationTimeStamp = DateTime.now();
    Map<String, dynamic> groupInfoMap = {
      "groupID": "",
      "groupName": groupName,
      "createdBy": gAccountUserName,
      "createdAt": creationTimeStamp,
      "members": [gAccountUserName],
      "activeMembers": [],
      "lastMessageTimeStamp": creationTimeStamp
    };
    String groupID =
        await DatabaseMethods().createNewGroupAndGetId(groupInfoMap);
    if (groupID.isNotEmpty) {
      Map<String, String> groupInfoMapForUser = {
        "groupID": groupID,
        "groupName": groupName
      };
      await DatabaseMethods()
          .addGroupDataToUserInfo(gAccountID, groupInfoMapForUser);
      print("group created successfully");
    }
  }

  deleteGroupChatRoomMsg() async {
    await DatabaseMethods().deleteGroupChatRoomMessages(groupID!);
  }

  addMessage(String selectedLanguage, bool isAudioMessage) async {
    if (messageTextEditingController.text.trim() != "" || isAudioMessage) {
      final tempPath = await _localPath;
      String? filePath = '$tempPath/ChatScreen-Original.wav';
      String message = messageTextEditingController.text.trimRight();
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
          .addMessageToGroupChatRoom(groupID!, messageID, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessageTimeStamp": messageTimeStamp,
        };
        DatabaseMethods()
            .updateLastMessageInfoInGroup(groupID!, lastMessageInfoMap);

        messageTextEditingController.text = "";
        messageID = "";
      });
    }
  }

  leaveGroup(String userName) async {
    await DatabaseMethods().leaveGroup(groupID!, userName, gAccountID);
  }

  deleteGroup() async {
    List listOfMembers = await DatabaseMethods().getGroupMembers(groupID!);
    await DatabaseMethods()
        .deleteGroup(groupID!, listOfMembers, otherGroupMemberInfo)
        .then((value) {
      Get.offAll(() => GroupChatScreen());
    });
  }

  addSelfToGroup() async {
    await DatabaseMethods().addMyselfToExistingGroup(groupID!);
  }

  addSelfToActiveMembers(String userName) async {
    await DatabaseMethods().addToActiveMembers(groupID!, userName);
  }

  removeSelfFromActiveMembers(String userName) async {
    await DatabaseMethods().removeFromActiveMembers(groupID!, userName);
  }

  Future<List> getGroupMemberList() async {
    return await DatabaseMethods().getGroupMembers(groupID!);
  }

  Future<List> getGroupActiveMemberList(String grpID) async {
    return await DatabaseMethods().getGroupActiveMembers(grpID);
  }

  //Notification methods
  inviteUserToGroup(String userName) async {
    Map<String, String> notificationDetails = {
      "title": "Group Invite",
      "body": "$gAccountUserName invites you to join his Group"
    };

    Map<String, dynamic> dataInfoMap = {
      'type': 'groupInvite',
      'groupID': groupID!,
      'groupName': groupName!,
      'groupCreatorUserName': groupCreatorUserName!,
      'senderID': gAccountID,
      'senderEmail': gAccountEmail,
      'senderUserName': gAccountUserName,
      'senderDisplayName': gAccountName,
      'senderProfilePic': (gUser_icon_image != null) ? gUser_icon_image! : "",
      'senderToken': gAccountUserFCMToken
    };

    DocumentSnapshot? ds =
        await DatabaseMethods().getSingleUserByUserName(userName);

    if (ds != null) {
      notificationServices.sendPushNotificationToUser(
          ds["token"]!, notificationDetails, dataInfoMap);
    }
  }

  Future inviteAllUsersToGroup() async {
    List members = await getGroupMemberList();
    List activeList = await getGroupActiveMemberList(groupID!);

    for (String userName in members){
      if(!activeList.contains(userName)){
        if(gAccountUserName != userName){
          inviteUserToGroup(userName);
        }

      }
    }

  }

  sendAcceptanceAlert(String senderToken) async {
    // Map<String,dynamic> alertDetails = {
    //   "type" : "Acceptance",
    //   "message": "$gAccountUserName has joined your room."
    // };
    Map<String, String> notificationDetails = {
      "title": "Acceptance Alert",
      "body": "$gAccountUserName has joined your group."
    };
    Map<String, String> dataInfoMap = {
      'type': 'Alert',
      'message': '$gAccountUserName has joined your room.'
    };

    notificationServices.sendPushNotificationToUser(
        senderToken, notificationDetails, dataInfoMap);
    // notificationServices.sendAlertToUser(selectedUserToken!, alertDetails);
  }

  sendRejectionAlert(String senderToken) async {
    // Map<String,dynamic> alertDetails = {
    //   "type" : "Rejection",
    //   "message": "$gAccountUserName has declined your invitation."
    // };

    Map<String, String> notificationDetails = {
      "title": "Rejection Alert",
      "body": "$gAccountUserName has declined your invitation."
    };
    Map<String, String> dataInfoMap = {
      'type': 'Alert',
      'message': '$gAccountUserName has declined your invitation.'
    };

    notificationServices.sendPushNotificationToUser(
        senderToken, notificationDetails, dataInfoMap);
    // notificationServices.sendAlertToUser(selectedUserToken!, alertDetails);
  }

  //Navigation methods
  goToGroupChatMainScreenFunc(selectedLanguage, controller) {
    Get.to(() => GroupChatMainScreen(
        selectedLanguage: selectedLanguage,
        groupChatScreenController: controller));
  }

  goToManageMembersScreenFunc(selectedLanguage, controller) {
    Get.to(() => ManageMembersScreen(
        selectedLanguage: selectedLanguage,
        groupChatScreenController: controller));
  }

  goToGroupChatScreenFunc() {
    Get.off(() => const GroupChatScreen());
  }

  goBackOnePageFunc() {
    Get.back();
  }
}

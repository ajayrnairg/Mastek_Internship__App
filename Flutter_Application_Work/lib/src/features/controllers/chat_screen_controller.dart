import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:rough_app/src/constants/image_strings.dart';
import 'package:rough_app/src/features/screens/chat_screen/chat_main_screen.dart';
import 'package:rough_app/src/utils/services/database.dart';

import '../../constants/text_strings.dart';

class ChatScreenController extends GetxController {
  static ChatScreenController get find => Get.find();

  String? selectedUserName,
      selectedUserDisplayName,
      selectedUserProfilePicURL,
      selectedUserEmail;

  String chatRoomID = "";
  String messageID = "";

  TextEditingController messageTextEditingController = TextEditingController();

  String getChatRoomIdByUsernames(String userA, String userB) {
    if (userA.substring(0, 1).codeUnitAt(0) >
        userB.substring(0, 1).codeUnitAt(0)) {
      return "${userB}_$userA";
    } else {
      return "${userA}_$userB";
    }
  }

  generateChatRoom() async {
    chatRoomID = getChatRoomIdByUsernames(gAccountUserName, selectedUserName!);
    Map<String, dynamic> chatRoomInfoMap = {
      "room_id": chatRoomID,
      "createdBy": gAccountUserName,
      "members": [gAccountUserName, selectedUserName]
    };

    await DatabaseMethods().createChatRoom(chatRoomID, chatRoomInfoMap);
  }

  deleteChatRoom() async{
    await DatabaseMethods().deleteChatRoom(chatRoomID);
  }

  addMessage(String selectedLanguage) {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;
      var messageTimeStamp = DateTime.now();

      if (messageID == "") {
        messageID = randomAlphaNumeric(12);
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/text_strings.dart';
import '../../controllers/chat_screen_controller.dart';
import '../../controllers/home_screen_controller.dart';

class ReceiverChatScreen extends StatefulWidget {
  const ReceiverChatScreen({
    super.key,
    required this.chatRoomID,
    required this.senderID,
    required this.senderEmail,
    required this.senderUserName,
    required this.senderDisplayName,
    required this.senderProfilePic,
    required this.senderToken,

  });

  final String chatRoomID;
  final String senderID;
  final String senderEmail;
  final String senderUserName;
  final String senderDisplayName;
  final String senderProfilePic;
  final String senderToken;

  @override
  State<ReceiverChatScreen> createState() => _ReceiverChatScreenState();
}

class _ReceiverChatScreenState extends State<ReceiverChatScreen> {
  final homeScreenController = Get.put(HomeScreenController());
  final chatScreenController = Get.put(ChatScreenController());

  static const List<String> languageList = <String>[
    gLanguage1,
    gLanguage2,
    gLanguage3,
    gLanguage4,
    gLanguage5,
    gLanguage6,
  ];

  String dropdown1Value = languageList.first;

   setRoomAndSelectedUserDetails(){
    chatScreenController.chatRoomID = widget.chatRoomID;
    chatScreenController.selectedUserID = widget.senderID;
    chatScreenController.selectedUserDisplayName = widget.senderDisplayName;
    chatScreenController.selectedUserEmail = widget.senderEmail;
    chatScreenController.selectedUserName = widget.senderUserName;
    chatScreenController.selectedUserProfilePicURL = (widget.senderProfilePic.length == 0)? null : widget.senderProfilePic;
    chatScreenController.selectedUserToken = widget.senderToken;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setRoomAndSelectedUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Screen Invite"),
        leading: IconButton(
          onPressed: () {
            homeScreenController.goToHomePageFunc();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: dropdown1Value,
                  items: languageList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) async {
                    dropdown1Value = val!;
                    // print(translatedTextController.text);
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.blue,
                  ),
                  decoration: const InputDecoration(
                      labelText: gLangSelectionPage,
                      floatingLabelStyle: TextStyle(color: Colors.blue),
                      prefixIconColor: Colors.blue,
                      prefixIcon: Icon(Icons.sort_by_alpha_rounded),
                      border: OutlineInputBorder()),
                ),
              ),

              // Widget you want at the bottom
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // await chatScreenController.generateChatRoom();
                    // await chatScreenController.inviteUserToChatRoom();

                    await setRoomAndSelectedUserDetails();
                    await chatScreenController.sendAcceptanceAlert();
                    chatScreenController.goToChatMainScreenFunc(
                        dropdown1Value, chatScreenController);
                  },
                  child: Text(
                    gStartConversation.toUpperCase(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await setRoomAndSelectedUserDetails();
                    await chatScreenController.sendRejectionAlert();
                    homeScreenController.goToHomePageFunc();
                  },
                  child: Text(
                    gDecline.toUpperCase(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

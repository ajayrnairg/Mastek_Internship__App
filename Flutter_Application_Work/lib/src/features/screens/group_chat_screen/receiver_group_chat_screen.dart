import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/text_strings.dart';
import '../../controllers/group_chat_screen_controller.dart';
import '../../controllers/home_screen_controller.dart';
import 'group_chat_main_screen.dart';

class ReceiverGroupChatScreen extends StatefulWidget {
  const ReceiverGroupChatScreen({super.key,
    required this.groupID,
    required this.groupName,
    required this.groupCreatorUserName,

    required this.senderID,
    required this.senderEmail,
    required this.senderUserName,
    required this.senderDisplayName,
    required this.senderProfilePic,
    required this.senderToken,
  });

  final String groupID;
  final String groupName;
  final String groupCreatorUserName;

  final String senderID;
  final String senderEmail;
  final String senderUserName;
  final String senderDisplayName;
  final String senderProfilePic;
  final String senderToken;

  @override
  State<ReceiverGroupChatScreen> createState() => _ReceiverGroupChatScreenState();
}

class _ReceiverGroupChatScreenState extends State<ReceiverGroupChatScreen> {
  final homeScreenController = Get.put(HomeScreenController());
  final groupChatScreenController = Get.put(GroupChatScreenController());

  static const List<String> languageList = <String>[
    gLanguage1,
    gLanguage2,
    gLanguage3,
    gLanguage4,
    gLanguage5,
    gLanguage6,
  ];

  String dropdown1Value = languageList.first;

  setRoomDetails(){
    groupChatScreenController.groupID = widget.groupID;
    groupChatScreenController.groupName = widget.groupName;
    groupChatScreenController.groupCreatorUserName = widget.groupCreatorUserName;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setRoomDetails();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Invite"),
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

                    await setRoomDetails();
                    await groupChatScreenController.addSelfToGroup();
                    await groupChatScreenController.sendAcceptanceAlert(widget.senderToken);
                    Get.off(() => GroupChatMainScreen(
                        selectedLanguage: dropdown1Value,
                        groupChatScreenController: groupChatScreenController));
                    // groupChatScreenController.goToGroupChatMainScreenFunc(dropdown1Value, groupChatScreenController);
                  },
                  child: Text(
                      "JOIN GROUP"
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
                    // await setRoomDetails();
                    await groupChatScreenController.sendRejectionAlert(widget.senderToken);
                    homeScreenController.goToHomePageFunc();
                  },
                  child: Text(
                    "DECLINE INVITATION"
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

import 'package:flutter/material.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/controllers/chat_screen_controller.dart';
import 'package:rough_app/src/features/screens/chat_screen/chat_widget/chat_bottom_container_widget.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen(
      {super.key,
      required this.selectedLanguage,
      required this.chatScreenController});

  final String selectedLanguage;
  final ChatScreenController chatScreenController;

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  getAndSetMessages() {}

  doThisOnLaunch() {

  }

  Widget chatMessages() {
    return ListView();
  }

  @override
  void initState() {
    // TODO: implement initState
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Chat - ${widget.chatScreenController.selectedUserName}"),
          leading: IconButton(
            onPressed: () async{
              await widget.chatScreenController.deleteChatRoom();
              widget.chatScreenController.goBackOnePageFunc();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Stack(
              children: [
                Container(
                  // flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 65),
                      color: Colors.red,
                    ),
                  ),
                ),
                ChatBottomContainerWidget(
                  selectedLanguage: widget.selectedLanguage,
                  chatScreenController: widget.chatScreenController,
                ),
              ],
            ),
          ),
        ));
  }
}

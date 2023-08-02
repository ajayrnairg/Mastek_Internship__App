import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/controllers/chat_screen_controller.dart';
import 'package:rough_app/src/features/screens/chat_screen/chat_widget/chat_bottom_container_widget.dart';

import 'package:rough_app/src/features/screens/chat_screen/chat_widget/receive_chat_message_widget.dart';
import 'package:rough_app/src/features/screens/chat_screen/chat_widget/send_chat_message_widget.dart';
import 'package:rough_app/src/utils/services/database.dart';

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
  StreamSubscription<QuerySnapshot<Object?>>? _messageStreamSubscription;

  //Helper functions
  Future<void> updateMyUI() async {
    setState(() {});
  }

  void deselectMessage() {
    widget.chatScreenController.isAnyMessageSelected = false;
    widget.chatScreenController.selectedMessageIndex = null;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.chatScreenController.clearData();
    deselectMessage();
    initializeMessageStream();
  }

  void initializeMessageStream() async {
    final Stream<QuerySnapshot<Object?>> messageStream = await DatabaseMethods()
        .getChatRoomMessages(widget.chatScreenController.chatRoomID);

    _messageStreamSubscription = messageStream.listen((querySnapshot) {
      // Handle the data as it arrives
      // querySnapshot.docs.first
      DocumentSnapshot ds = querySnapshot.docs.first;
      // print("first element from stream ${firstElement["message_text"]}");

      widget.chatScreenController
          .buildAndAddDataToLocalDSA(
              widget.selectedLanguage,
              ds["message_id"],
              ds["message_text"],
              ds["message_text_language"],
              ds["sendBy"],
              ds["senderImageURL"],
              DateTime.fromMillisecondsSinceEpoch(
                      ds["message_timestamp"].millisecondsSinceEpoch)
                  .toString())
          .then((value) {
            print("updating UI");
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _messageStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat - ${widget.chatScreenController.selectedUserName}"),
        leading: widget.chatScreenController.isAnyMessageSelected
            ? IconButton(
                onPressed: () {
                  deselectMessage();
                },
                icon: const Icon(Icons.arrow_back),
              )
            : IconButton(
                onPressed: () async {
                  widget.chatScreenController.combinedMessages = [];
                  _messageStreamSubscription?.cancel();
                  await widget.chatScreenController.deleteChatRoom();
                  widget.chatScreenController.clearData();
                  widget.chatScreenController.goBackOnePageFunc();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
        actions: widget.chatScreenController.isAnyMessageSelected
            ? [
                IconButton(
                    onPressed: () {
                      widget.chatScreenController
                          .addSelectedMessageToClipboard();
                    },
                    icon: const Icon(Icons.copy)),
                IconButton(
                    onPressed: () {
                      widget.chatScreenController
                          .playSelectedMessageAsAudio(widget.selectedLanguage);
                    },
                    icon: const Icon(Icons.volume_up))
              ]
            : null,
      ),
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(bottom: 65),
                // color: Colors.red,
                child: ListView(
                  children: [
                    Container(
                      // height: size.height,
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount:
                            widget.chatScreenController.combinedMessages.length,
                        itemBuilder: (context, index) {
                          if (widget.chatScreenController
                                  .combinedMessages[index]["message_sent_by"] ==
                              gAccountUserName) {
                            return Container(
                              color: widget
                                      .chatScreenController.isAnyMessageSelected
                                  ? (widget.chatScreenController
                                              .selectedMessageIndex ==
                                          index)
                                      ? Colors.black.withOpacity(0.5)
                                      : null
                                  : null,
                              child: SendChatMessageWidget(
                                index: index,
                                size: size,
                                chatScreenController:
                                    widget.chatScreenController,
                                updateParentUI: updateMyUI,
                              ),
                            );
                          } else {
                            return Container(
                              color: widget
                                      .chatScreenController.isAnyMessageSelected
                                  ? (widget.chatScreenController
                                              .selectedMessageIndex ==
                                          index)
                                      ? Colors.black.withOpacity(0.5)
                                      : null
                                  : null,
                              child: ReceivedChatMessageWidget(
                                index: index,
                                size: size,
                                chatScreenController:
                                    widget.chatScreenController,
                                updateParentUI: updateMyUI,
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            ChatBottomContainerWidget(
                selectedLanguage: widget.selectedLanguage,
                chatScreenController: widget.chatScreenController)
          ],
        ),
      ),
    );
  }
}

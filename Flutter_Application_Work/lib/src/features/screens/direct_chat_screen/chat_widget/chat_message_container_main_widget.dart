import 'package:flutter/material.dart';

import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';
import 'package:rough_app/src/features/screens/direct_chat_screen/chat_widget/receive_chat_message_widget.dart';
import 'package:rough_app/src/features/screens/direct_chat_screen/chat_widget/send_chat_message_widget.dart';

import 'chat_bottom_container_widget.dart';

class ChatMessageContainerMainWidget extends StatefulWidget {
  const ChatMessageContainerMainWidget(
      {super.key,
      required this.size,
      required this.directChatScreenController,
      required this.selectedLang1,
      required this.selectedLang2,
      required this.updateParentUI});

  final Size size;
  final DirectChatScreenController directChatScreenController;
  final String selectedLang1, selectedLang2;
  final Function updateParentUI;

  @override
  State<ChatMessageContainerMainWidget> createState() =>
      _ChatMessageContainerMainWidgetState();
}

class _ChatMessageContainerMainWidgetState
    extends State<ChatMessageContainerMainWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> callback() async {
    if (widget.directChatScreenController.selectedLanguages[0]) {
      await widget.directChatScreenController.buildAndAddMessage(
          widget.directChatScreenController.getSideValue(),
          widget.selectedLang1,
          widget.selectedLang2);
    } else {
      await widget.directChatScreenController.buildAndAddMessage(
          widget.directChatScreenController.getSideValue(),
          widget.selectedLang2,
          widget.selectedLang1);
    }
    // widget.directChatScreenController.addMessage();
    setState(() {});
  }

  Future<void> updateMyUI() async {
    setState(() {});
  }

  Future<void> updateRootUI() async {
    setState(() {});
    widget.updateParentUI();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.8,
      child: ListView(
        children: [
          Container(
            height: widget.size.height * 0.665,
            child: ListView.builder(
              shrinkWrap: true,
              reverse: false,
              itemCount:
                  widget.directChatScreenController.combinedMessages.length,
              itemBuilder: (context, index) {
                if (widget.directChatScreenController.combinedMessages[index]
                        ["message_language_side"] ==
                    "Left") {
                  return Container(
                    color:
                        widget.directChatScreenController.isAnyMessageSelected
                            ? (widget.directChatScreenController
                                        .selectedMessageIndex ==
                                    index)
                                ? Colors.black.withOpacity(0.5)
                                : null
                            : null,
                    child: ReceivedChatMessageWidget(
                      index: index,
                      size: widget.size,
                      directChatScreenController:
                          widget.directChatScreenController,
                      updateParentUI: updateMyUI,
                      updateRootUI: updateRootUI,
                    ),
                  );
                } else {
                  return Container(
                    color:
                        widget.directChatScreenController.isAnyMessageSelected
                            ? (widget.directChatScreenController
                                        .selectedMessageIndex ==
                                    index)
                                ? Colors.black.withOpacity(0.5)
                                : null
                            : null,
                    child: SendChatMessageWidget(
                      index: index,
                      size: widget.size,
                      directChatScreenController:
                          widget.directChatScreenController,
                      updateParentUI: updateMyUI,
                      updateRootUI: updateRootUI,
                    ),
                  );
                }
              },
            ),
          ),
          ChatBottomContainerWidget(
            callback: callback,
            directChatScreenController: widget.directChatScreenController,
            selectedLang1: widget.selectedLang1,
            selectedLang2: widget.selectedLang2,
            updateParentUI: updateMyUI,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rough_app/src/common_widgets/chat_widget/chat_bottom_container_widget.dart';
import 'package:rough_app/src/common_widgets/chat_widget/receive_chat_message_widget.dart';
import 'package:rough_app/src/common_widgets/chat_widget/send_chat_message_widget.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';

class ChatMessageContainerMainWidget extends StatefulWidget {
  const ChatMessageContainerMainWidget({
    super.key,
    required this.size,
    required this.directChatScreenController,
    required this.selectedLang1,
    required this.selectedLang2,
  });

  final Size size;
  final DirectChatScreenController directChatScreenController;
  final String selectedLang1, selectedLang2;

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

      if (widget.directChatScreenController.switchValue) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.8,
      child: ListView(
        children: [
          Container(
            height: widget.size.height * 0.71,
            child: ListView.builder(
              shrinkWrap: true,
              reverse: false,
              itemCount:
                  widget.directChatScreenController.combinedMessages.length,
              itemBuilder: (context, index) {
                if (widget.directChatScreenController.combinedMessages[index]
                        ["message_language_side"] ==
                    "Left") {
                  return SendChatMessageWidget(
                      index: index,
                      size: widget.size,
                      directChatScreenController:
                          widget.directChatScreenController);
                } else {
                  return ReceiveChatMessageWidget(
                      index: index,
                      size: widget.size,
                      directChatScreenController:
                          widget.directChatScreenController);
                }
              },
            ),
          ),
          ChatBottomContainerWidget(
              callback: callback,
              directChatScreenController: widget.directChatScreenController,
              selectedLang1: widget.selectedLang1,
              selectedLang2: widget.selectedLang2
          ),
        ],
      ),
    );
  }
}

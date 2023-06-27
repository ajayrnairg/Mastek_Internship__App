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
  });

  final Size size;
  final DirectChatScreenController directChatScreenController;

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

  void callback() {
    setState(() {
      widget.directChatScreenController.addMessage();
    });
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
              reverse: true,
              itemCount: widget.directChatScreenController.combineMsgs.length,
              itemBuilder: (context, index) {
                if (widget.directChatScreenController.combineMsgs[index]
                        ["who"] ==
                    "a") {
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
              directChatScreenController: widget.directChatScreenController),
        ],
      ),
    );
  }
}

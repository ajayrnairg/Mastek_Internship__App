import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';

class ChatBottomContainerWidget extends StatefulWidget {
  const ChatBottomContainerWidget({
    super.key,
    required this.directChatScreenController,
    required this.callback,
  });


  final Function callback;

  final DirectChatScreenController directChatScreenController;

  @override
  State<ChatBottomContainerWidget> createState() =>
      _ChatBottomContainerWidgetState();
}

class _ChatBottomContainerWidgetState extends State<ChatBottomContainerWidget> {


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.black.withOpacity(0.8)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller:
                    widget.directChatScreenController.messageTextEditingController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "type a message ....",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            IconButton(
              color: Colors.blue,
              onPressed: () {},
              icon: Icon(Icons.mic_outlined),
            ),
            IconButton(
              color: Colors.blue,
              onPressed: () {},
              icon: Icon(Icons.volume_up_outlined),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                widget.callback();

                // setState(() {
                //   directChatScreenController.addMessage();
                // });
              },
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

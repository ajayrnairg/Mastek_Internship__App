import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/chat_screen_controller.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';
import 'package:rough_app/src/features/controllers/group_chat_screen_controller.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';

class ReceivedChatMessageWidget extends StatefulWidget {
  const ReceivedChatMessageWidget({
    super.key,
    required this.size,
    required this.groupChatScreenController,
    required this.index,
    required this.updateParentUI,
    // required this.updateRootUI,
  });

  final Size size;
  final GroupChatScreenController groupChatScreenController;
  final int index;
  final Function updateParentUI;

  // final Function updateRootUI;

  @override
  State<ReceivedChatMessageWidget> createState() =>
      _ReceivedChatMessageWidgetState();
}

class _ReceivedChatMessageWidgetState extends State<ReceivedChatMessageWidget> {
  String? requiredUserName;

  @override
  void initState() {
    // TODO: implement initState
    requiredUserName = widget.groupChatScreenController
        .combinedMessages[widget.index]["message_translation_text"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            // color: Colors.red,
            child:
                (widget.groupChatScreenController.combinedMessages[widget.index]
                            ["message_sender_profilePic"] !=
                        "")
                    ? ClipOval(
                        child: Image.network(
                        widget.groupChatScreenController
                                .combinedMessages[widget.index]
                            ["message_sender_profilePic"]!,
                        width: 25,
                        height: 25,
                        fit: BoxFit.cover,
                      ))
                    : ClipOval(
                        child: Image.asset(
                        gUser_icon_2_image!,
                        width: 25,
                        height: 25,
                        fit: BoxFit.cover,
                      )),
          ),
          InkWell(
            child: Container(
              constraints: BoxConstraints(maxWidth: widget.size.width * 0.80),
              decoration: BoxDecoration(
                color: isDarkMode ? gChatColorDark2 : gChatColorLight2,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                            text: "",
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    "${widget
                                        .groupChatScreenController
                                        .combinedMessages[widget.index]
                                    ["message_sent_by"]} \n",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextSpan(
                                text: widget
                                    .groupChatScreenController
                                    .combinedMessages[widget.index]
                                        ["message_translation_text"]
                                    .toString(),
                                style: const TextStyle(fontSize: 16),
                              )
                            ]),
                      )


                      ),
                ],
              ),
            ),
            onLongPress: () {

              if (!widget.groupChatScreenController.isAnyMessageSelected) {
                widget.groupChatScreenController.isAnyMessageSelected = true;
                widget.groupChatScreenController.selectedMessageIndex = widget.index;
              }
              setState(() {});
              widget.updateParentUI();
            },
          ),
        ],
      ),
    );
  }
}

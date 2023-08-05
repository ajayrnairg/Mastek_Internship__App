import 'package:flutter/material.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/controllers/chat_screen_controller.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';

class SendChatMessageWidget extends StatefulWidget {
  const SendChatMessageWidget({
    super.key,
    required this.size,
    required this.chatScreenController,
    required this.index,
    required this.updateParentUI,
    // required this.updateRootUI,
  });

  final Size size;
  final ChatScreenController chatScreenController;
  final int index;

  final Function updateParentUI;

  // final Function updateRootUI;

  @override
  State<SendChatMessageWidget> createState() => _SendChatMessageWidgetState();
}

class _SendChatMessageWidgetState extends State<SendChatMessageWidget> {
  //
  // String decideWhatToDisplay() {
  //   if (widget.directChatScreenController.selectedLanguages[0]) {
  //
  //       return "message_translation_text";
  //
  //   } else {
  //
  //       return "message_original_text";
  //
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            child: Container(
              constraints: BoxConstraints(maxWidth: widget.size.width * 0.80),
              decoration: BoxDecoration(
                color: isDarkMode ? gChatColorDark1 : gChatColorLight1,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(textAlign: TextAlign.right,
                        text: TextSpan(
                            text: "",
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: "$gAccountUserName \n",
                                style: const TextStyle(

                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextSpan(
                                text: widget
                                    .chatScreenController
                                    .combinedMessages[widget.index]
                                        ["message_translation_text"]
                                    .toString(),
                                style: const TextStyle(fontSize: 16),
                              )
                            ]),
                      )

                      // Text(
                      //       "$gAccountUserName\n ${widget
                      //       .chatScreenController
                      //       .combinedMessages[widget.index]
                      //           ["message_original_text"]
                      //       .toString()}",
                      //   style: const TextStyle(fontSize: 16),
                      // ),

                      // toggleText
                      //     ? Text(widget
                      //         .directChatScreenController
                      //         .combinedMessages[widget.index]
                      //             ["message_original_text"]
                      //         .toString())
                      //     : Text(widget
                      //         .directChatScreenController
                      //         .combinedMessages[widget.index]
                      //             ["message_translation_text"]
                      //         .toString()),
                      ),
                ],
              ),
            ),
            onLongPress: () {
              print("hehe");
              if (!widget.chatScreenController.isAnyMessageSelected) {
                widget.chatScreenController.isAnyMessageSelected = true;
                widget.chatScreenController.selectedMessageIndex = widget.index;
              }
              setState(() {});
              widget.updateParentUI();
            },
          ),
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            // color: Colors.red,
            child: (gUser_icon_image != null)
                ? ClipOval(
                    child: Image.network(
                    gUser_icon_image!,
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
        ],
      ),
    );
  }
}

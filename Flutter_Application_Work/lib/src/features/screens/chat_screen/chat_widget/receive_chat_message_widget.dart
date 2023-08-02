import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/chat_screen_controller.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';

class ReceivedChatMessageWidget extends StatefulWidget {
  const ReceivedChatMessageWidget({
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
  State<ReceivedChatMessageWidget> createState() =>
      _ReceivedChatMessageWidgetState();
}

class _ReceivedChatMessageWidgetState extends State<ReceivedChatMessageWidget> {
  //
  // String decideWhatToDisplay() {
  //   if (widget.directChatScreenController.selectedLanguages[1]) {
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            // color: Colors.red,
            child: (widget.chatScreenController
                .selectedUserProfilePicURL !=
                null)
                ? ClipOval(
                child: Image.network(
                  widget.chatScreenController
                      .selectedUserProfilePicURL!,
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
                                    "${widget.chatScreenController.selectedUserName} \n",
                                style: TextStyle(
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

                      // Text(widget.chatScreenController
                      //     .combinedMessages[widget.index]["message_text"]
                      //     .toString(),style: const TextStyle(fontSize: 16),),

                      // toggleText
                      //     ? Text(widget.directChatScreenController
                      //     .combinedMessages[widget.index]["message_original_text"]
                      //     .toString())
                      //     : Text(widget.directChatScreenController
                      //     .combinedMessages[widget.index]["message_translation_text"]
                      //     .toString()),
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
        ],
      ),
    );
  }
}
//
// class ReceiveChatMessageWidget extends StatelessWidget {
//   const ReceiveChatMessageWidget({
//     super.key,
//     required this.size,
//     required this.directChatScreenController,
//     required this.index,
//   });
//
//   final Size size;
//   final DirectChatScreenController directChatScreenController;
//   final int index;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           InkWell(
//             child: Container(
//               constraints:
//               BoxConstraints(maxWidth: size.width * 0.90),
//               child: Wrap(
//                 alignment: WrapAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(directChatScreenController
//                         .combinedMessages[index]["message_translation_text"]
//                         .toString()),
//                   ),
//                 ],
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(10.0),
//                   topRight: Radius.zero,
//                   bottomLeft: Radius.circular(10.0),
//                   bottomRight: Radius.circular(10.0),
//                 ),
//               ),
//             ),
//             onTap: () {},
//
//           ),
//         ],
//       ),
//       // ListTile(
//       //   shape: RoundedRectangleBorder(
//       //     borderRadius: BorderRadius.only(
//       //         topLeft: Radius.circular(10.0),
//       //         topRight: Radius.zero,
//       //         bottomLeft: Radius.circular(10.0),
//       //         bottomRight: Radius.circular(10.0),
//       //   ),
//       //   ),
//       //   tileColor: Colors.blue,
//       //   title: Text(combineMsgs[index]["what"].toString()),
//       //   trailing: Text(combineMsgs[index]["time"].toString()),
//       //   onTap: () {},
//       // ),
//     );
//   }
// }

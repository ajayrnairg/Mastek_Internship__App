import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';


class ReceivedChatMessageWidget extends StatefulWidget {
  const ReceivedChatMessageWidget({
    super.key,
    required this.size,
    required this.directChatScreenController,
    required this.index,
    required this.updateParentUI,
    required this.updateRootUI,
  });

  final Size size;
  final DirectChatScreenController directChatScreenController;
  final int index;
  final Function updateParentUI;
  final Function updateRootUI;

  @override
  State<ReceivedChatMessageWidget> createState() => _ReceivedChatMessageWidgetState();
}

class _ReceivedChatMessageWidgetState extends State<ReceivedChatMessageWidget> {
  bool showOriginalText = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            child: Container(
              constraints: BoxConstraints(maxWidth: widget.size.width * 0.90),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
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
                    child: showOriginalText
                        ? Text(widget.directChatScreenController
                        .combinedMessages[widget.index]["message_original_text"]
                        .toString())
                        : Text(widget.directChatScreenController
                        .combinedMessages[widget.index]["message_translation_text"]
                        .toString()),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                showOriginalText = !showOriginalText;
              });
            },
            onLongPress: () {
              print("hehe");
              if (!widget.directChatScreenController.isAnyMessageSelected) {

                widget.directChatScreenController.isAnyMessageSelected = true;
                widget.directChatScreenController.selectedMessageIndex = widget.index;
              }
              setState(() {

              });
              widget.updateRootUI();
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

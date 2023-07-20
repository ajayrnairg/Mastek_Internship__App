import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';

class SendChatMessageWidget extends StatefulWidget {
  const SendChatMessageWidget({
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
  State<SendChatMessageWidget> createState() => _SendChatMessageWidgetState();
}

class _SendChatMessageWidgetState extends State<SendChatMessageWidget> {
  bool showOriginalText = false;




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            child: Container(
              constraints: BoxConstraints(maxWidth: widget.size.width * 0.90),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
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
                    child: showOriginalText
                        ? Text(widget
                            .directChatScreenController
                            .combinedMessages[widget.index]
                                ["message_original_text"]
                            .toString())
                        : Text(widget
                            .directChatScreenController
                            .combinedMessages[widget.index]
                                ["message_translation_text"]
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
// class SendChatMessageWidget extends StatelessWidget {
//   const SendChatMessageWidget({
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
//   bool showOriginalText = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           InkWell(
//             child: Container(
//               constraints: BoxConstraints(maxWidth: size.width * 0.90),
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.zero,
//                   topRight: Radius.circular(10.0),
//                   bottomLeft: Radius.circular(10.0),
//                   bottomRight: Radius.circular(10.0),
//                 ),
//               ),
//               child: Wrap(
//                 alignment: WrapAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: showOriginalText
//                         ? Text(directChatScreenController
//                             .combinedMessages[index]["message_original_text"]
//                             .toString())
//                         : Text(directChatScreenController
//                             .combinedMessages[index]["message_translation_text"]
//                             .toString()),
//                   ),
//                 ],
//               ),
//             ),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

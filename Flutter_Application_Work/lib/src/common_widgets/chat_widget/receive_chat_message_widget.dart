import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';


class ReceiveChatMessageWidget extends StatelessWidget {
  const ReceiveChatMessageWidget({
    super.key,
    required this.size,
    required this.directChatScreenController,
    required this.index,
  });

  final Size size;
  final DirectChatScreenController directChatScreenController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            child: Container(
              constraints:
              BoxConstraints(maxWidth: size.width * 0.90),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(directChatScreenController
                        .combineMsgs[index]["what"]
                        .toString()),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
            ),
            onTap: () {},

          ),
        ],
      ),
      // ListTile(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(10.0),
      //         topRight: Radius.zero,
      //         bottomLeft: Radius.circular(10.0),
      //         bottomRight: Radius.circular(10.0),
      //   ),
      //   ),
      //   tileColor: Colors.blue,
      //   title: Text(combineMsgs[index]["what"].toString()),
      //   trailing: Text(combineMsgs[index]["time"].toString()),
      //   onTap: () {},
      // ),
    );
  }
}

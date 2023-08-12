import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/common_widgets/toast_widget/toast_widget.dart';
import 'package:rough_app/src/features/controllers/group_chat_screen_controller.dart';
import 'package:rough_app/src/features/screens/group_chat_screen/chat_widget/receive_chat_message_widget.dart';
import 'package:rough_app/src/features/screens/group_chat_screen/chat_widget/send_chat_message_widget.dart';
import 'package:rough_app/src/features/screens/group_chat_screen/chat_widget/chat_bottom_container_widget.dart';
import 'package:rough_app/src/features/screens/group_chat_screen/group_chat_screen.dart';
import 'package:rough_app/src/features/screens/home_screen/home_screen.dart';

import '../../../constants/text_strings.dart';
import '../../../utils/services/database.dart';
import 'manages_members_screen.dart';

class GroupChatMainScreen extends StatefulWidget {
  const GroupChatMainScreen(
      {super.key,
      required this.selectedLanguage,
      required this.groupChatScreenController});

  final String selectedLanguage;
  final GroupChatScreenController groupChatScreenController;

  @override
  State<GroupChatMainScreen> createState() => _GroupChatMainScreenState();
}

class _GroupChatMainScreenState extends State<GroupChatMainScreen> {
  StreamSubscription<QuerySnapshot<Object?>>? _messageStreamSubscription;
  StreamSubscription<DocumentSnapshot>? _groupStreamSubscription;

  //Helper functions
  Future<void> updateMyUI() async {
    setState(() {});
  }

  void deselectMessage() {
    widget.groupChatScreenController.isAnyMessageSelected = false;
    widget.groupChatScreenController.selectedMessageIndex = null;
    // setState(() {});
  }

  void startListeningToGroup() {
    _groupStreamSubscription = FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.groupChatScreenController.groupID!)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        List<dynamic> members = (snapshot["members"] as List).cast<dynamic>();
        // print(members);
        for (String userName in members) {
          widget.groupChatScreenController
              .updateSingleGroupMemberInfo(userName);
        }
      }
    });
  }

  void initializeMessageStream() async {
    final Stream<QuerySnapshot<Object?>> messageStream = await DatabaseMethods()
        .getGroupChatRoomMessages(widget.groupChatScreenController.groupID!);

    _messageStreamSubscription = messageStream.listen((querySnapshot) {
      // Handle the data as it arrives
      // querySnapshot.docs.first
      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.length > 1 &&
            widget.groupChatScreenController.combinedMessages.isEmpty) {
          // print("printing length");
          // print("${querySnapshot.docs.length}");
          List<DocumentSnapshot> documents =
              querySnapshot.docs.toList().reversed.toList();
          // print("$documents");
          for (DocumentSnapshot ds in documents) {
            // print("${ds["message_text"]}");
            widget.groupChatScreenController
                .buildAndAddDataToLocalDSA(
                    widget.selectedLanguage,
                    ds["message_id"],
                    ds["message_text"],
                    ds["message_text_language"],
                    ds["sendBy"],
                    ds["senderImageURL"],
                    DateTime.fromMillisecondsSinceEpoch(
                            ds["message_timestamp"].millisecondsSinceEpoch)
                        .toString())
                .then((value) {
              print("updating UI");
              setState(() {});
            });
          }
        } else {
          DocumentSnapshot ds = querySnapshot.docs.first;
          // print("first element from stream ${ds["message_text"]}");

          widget.groupChatScreenController
              .buildAndAddDataToLocalDSA(
                  widget.selectedLanguage,
                  ds["message_id"],
                  ds["message_text"],
                  ds["message_text_language"],
                  ds["sendBy"],
                  ds["senderImageURL"],
                  DateTime.fromMillisecondsSinceEpoch(
                          ds["message_timestamp"].millisecondsSinceEpoch)
                      .toString())
              .then((value) {
            print("updating UI");
            setState(() {});
          });
        }
      } else {
        // Handle the case when there are no documents
        print("No documents available");
      }
    });
  }

  doThisOnLaunch() async {
    widget.groupChatScreenController.addSelfToActiveMembers(gAccountUserName);
    widget.groupChatScreenController.clearData();
    deselectMessage();
    await widget.groupChatScreenController.inviteAllUsersToGroup().then((value) => ToastWidget().raiseToast(context, "Invitations Sent."));
    startListeningToGroup();
    initializeMessageStream();
  }

  doThisOnDisposal() async {
    List currentActiveMembers = await widget.groupChatScreenController
        .getGroupActiveMemberList(widget.groupChatScreenController.groupID!);
    widget.groupChatScreenController
        .removeSelfFromActiveMembers(gAccountUserName);
    await _messageStreamSubscription?.cancel();
    await _groupStreamSubscription?.cancel();
    widget.groupChatScreenController.clearData();
    widget.groupChatScreenController.printData();
    deselectMessage();
    if (currentActiveMembers.length == 1 &&
        currentActiveMembers.contains(gAccountUserName)) {
      // print("here");
      await widget.groupChatScreenController
          .deleteGroupChatRoomMsg(); // delelte the msgs when user is only one active
      // print("done");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    doThisOnLaunch();
    super.initState();
  }

  @override
  void dispose() {
    doThisOnDisposal();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.groupChatScreenController.groupName}"),
        leading: widget.groupChatScreenController.isAnyMessageSelected
            ? IconButton(
                onPressed: () {
                  deselectMessage();
                  setState(() {});
                },
                icon: const Icon(Icons.arrow_back),
              )
            : IconButton(
                onPressed: () async {
                  // widget.groupChatScreenController.removeSelfFromActiveMembers(gAccountUserName);
                  // _messageStreamSubscription?.cancel();
                  // _groupStreamSubscription?.cancel();
                  // widget.groupChatScreenController.clearData();
                  // deselectMessage();
                  // List currentActiveMembers = await widget.groupChatScreenController.getGroupActiveMemberList();
                  // if(currentActiveMembers.length == 1 && currentActiveMembers.contains(gAccountUserName)){
                  //   await widget.groupChatScreenController
                  //       .deleteGroupChatRoomMsg(); // delelte the msgs when user is only one active
                  // }
                  // _messageStreamSubscription?.cancel();
                  // _groupStreamSubscription?.cancel();
                  // widget.groupChatScreenController.clearData();
                  // deselectMessage();
                  // List currentActiveMembers = await widget.groupChatScreenController.getGroupActiveMemberList();
                  // if(currentActiveMembers.length == 1 && currentActiveMembers.contains(gAccountUserName)){
                  //   await widget.groupChatScreenController
                  //       .deleteGroupChatRoomMsg(); // delelte the msgs when user is only one active
                  // }

                  widget.groupChatScreenController.goBackOnePageFunc();

                  // widget.groupChatScreenController.goToGroupChatScreenFunc();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
        actions: widget.groupChatScreenController.isAnyMessageSelected
            ? [
                IconButton(
                    onPressed: () {
                      widget.groupChatScreenController
                          .addSelectedMessageToClipboard();
                      ToastWidget().raiseToast(context, "Message Copied");
                    },
                    icon: const Icon(Icons.copy)),
                IconButton(
                    onPressed: () {
                      widget.groupChatScreenController
                          .playSelectedMessageAsAudio(widget.selectedLanguage);
                    },
                    icon: const Icon(Icons.volume_up))
              ]
            : [
                IconButton(
                  onPressed: () async {
                    // Get.to(() => ManageMembersScreen(
                    //     selectedLanguage: widget.selectedLanguage,
                    //     groupChatScreenController: widget.groupChatScreenController));
                    widget.groupChatScreenController
                        .goToManageMembersScreenFunc(widget.selectedLanguage,
                            widget.groupChatScreenController);
                  },
                  icon: const Icon(Icons.manage_accounts),
                  // icon: const Icon(Icons.person_add),
                ),
                // IconButton(
                //   onPressed: () async {
                //     print("printing data");
                //     print(await widget.groupChatScreenController
                //         .getGroupMemberList());
                //     print(
                //         widget.groupChatScreenController.otherGroupMemberInfo);
                //     print(widget.groupChatScreenController.combinedMessages);
                //   },
                //   icon: const Icon(Icons.abc),
                //   // icon: const Icon(Icons.person_add),
                // ),
              ],
      ),
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(bottom: 65),
                // color: Colors.red,
                child: ListView(
                  children: [
                    Container(
                      // height: size.height,
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: widget
                            .groupChatScreenController.combinedMessages.length,
                        itemBuilder: (context, index) {
                          if (widget.groupChatScreenController
                                  .combinedMessages[index]["message_sent_by"] ==
                              gAccountUserName) {
                            print("building ui");
                            return Container(
                              color: widget.groupChatScreenController
                                      .isAnyMessageSelected
                                  ? (widget.groupChatScreenController
                                              .selectedMessageIndex ==
                                          index)
                                      ? Colors.black.withOpacity(0.5)
                                      : null
                                  : null,
                              child: SendChatMessageWidget(
                                index: index,
                                size: size,
                                groupChatScreenController:
                                    widget.groupChatScreenController,
                                updateParentUI: updateMyUI,
                              ),
                            );
                          } else {
                            return Container(
                              color: widget.groupChatScreenController
                                      .isAnyMessageSelected
                                  ? (widget.groupChatScreenController
                                              .selectedMessageIndex ==
                                          index)
                                      ? Colors.black.withOpacity(0.5)
                                      : null
                                  : null,
                              child: ReceivedChatMessageWidget(
                                index: index,
                                size: size,
                                groupChatScreenController:
                                    widget.groupChatScreenController,
                                updateParentUI: updateMyUI,
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            ChatBottomContainerWidget(
                selectedLanguage: widget.selectedLanguage,
                groupChatScreenController: widget.groupChatScreenController)
          ],
        ),
      ),
    );
  }
}

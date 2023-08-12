import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/image_strings.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';
import '../../../utils/services/database.dart';
import '../../controllers/group_chat_screen_controller.dart';
import 'group_chat_screen.dart';

class ManageMembersScreen extends StatefulWidget {
  const ManageMembersScreen(
      {super.key,
      required this.selectedLanguage,
      required this.groupChatScreenController});

  final String selectedLanguage;
  final GroupChatScreenController groupChatScreenController;

  @override
  State<ManageMembersScreen> createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  bool isSearching = false;
  late Stream usersStream;
  bool isAnyUserSelected = false;

  String? selectedUserID,
      selectedUserName,
      selectedUserDisplayName,
      selectedUserProfilePicURL,
      selectedUserEmail,
      selectedUserToken;

  int selectedIndex = -1;

  TextEditingController userSearchController = TextEditingController();

  handleListTileTap(
      int index,
      String userID,
      String userName,
      String displayName,
      String? profilePicURL,
      String userEmail,
      String userToken) {
    isAnyUserSelected = true;
    selectedIndex = index;
    selectedUserID = userID;
    selectedUserDisplayName = displayName;
    selectedUserEmail = userEmail;
    selectedUserName = userName;
    selectedUserProfilePicURL = profilePicURL;
    selectedUserToken = userToken;
    setState(() {});
  }

  onSearchButtonClick() async {
    isSearching = true;
    setState(() {});
    usersStream =
        await DatabaseMethods().getUserByUserName(userSearchController.text);
  }

  deselectUser() {
    isAnyUserSelected = false;
    selectedIndex = -1;
    selectedUserID = null;
    selectedUserName = null;
    selectedUserDisplayName = null;
    selectedUserProfilePicURL = null;
    selectedUserEmail = null;
    selectedUserToken = null;
  }

  getActiveGuys(String grpID) async {
    List activeList =
        await widget.groupChatScreenController.getGroupActiveMemberList(grpID);
    return activeList;
  }

  Widget searchUsersList() {
    return StreamBuilder(
        stream: usersStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    if (ds["username"] != gAccountUserName) {
                      if(ds["token"] != "") {
                        return GestureDetector(
                          onTap: isAnyUserSelected
                              ? null
                              : () {
                            handleListTileTap(
                                index,
                                ds["id"],
                                ds["username"],
                                ds["displayname"],
                                ds["profileURL"],
                                ds["email"],
                                ds["token"]);
                          },
                          child: Container(
                            color: (isAnyUserSelected && selectedIndex == index)
                                ? Colors.blue.withOpacity(0.4)
                                : null,
                            child: ListTile(
                              leading: (ds["profileURL"] != null)
                                  ? Image.network(ds["profileURL"])
                                  : Image.asset(gUser_icon_2_image),
                              title: Text(ds["displayname"]),
                              subtitle: Text(ds["email"]),
                            ),
                          ),
                        );
                      }
                      else{
                        return null;
                      }
                    }else{
                      return null;
                    }

                    // Text(ds["displayname"]);
                  })
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget currentUsersList() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupChatScreenController.groupID!)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Container();
          // Text("Error: ${snapshot.error}");
        }
        if (snapshot.hasData && snapshot.data!.exists) {
          DocumentSnapshot ds = snapshot.data!;
          List<dynamic> members = (ds["members"] as List).cast<dynamic>();

          if (members.isNotEmpty) {
            return ListView.builder(
              itemCount: members.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String userName = members[index];
                if (userName != gAccountUserName) {
                  print(userName);
                  return FutureBuilder(
                    future: getActiveGuys(
                        widget.groupChatScreenController.groupID!),
                    builder: (context, activeMembersSnapshot) {
                      if (activeMembersSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container();
                        // Text("Loading...");
                      }
                      if (activeMembersSnapshot.hasError) {
                        return Container();
                        // Text("Error fetching active members"),
                      }

                      List currentActiveMembers =
                          activeMembersSnapshot.data as List;

                      return ListTile(
                        leading: (widget.groupChatScreenController
                                        .otherGroupMemberInfo["$userName"]
                                    ["userProfilePicURL"] !=
                                null)
                            ? Image.network(widget.groupChatScreenController
                                    .otherGroupMemberInfo["$userName"]
                                ["userProfilePicURL"])
                            : Image.asset(gUser_icon_2_image),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.groupChatScreenController
                                    .otherGroupMemberInfo["$userName"]
                                ["userDisplayName"]),
                            SizedBox(width: 5,),
                            Icon(
                              Icons.circle,
                              color: (currentActiveMembers.contains(userName)) ? Colors.green: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                        subtitle: Text(widget.groupChatScreenController
                            .otherGroupMemberInfo["$userName"]["userEmail"]),
                        trailing: (widget.groupChatScreenController
                                    .groupCreatorUserName ==
                                gAccountUserName)
                            ? IconButton(
                                onPressed: () {
                                  // Handle removing the member
                                  widget.groupChatScreenController
                                      .leaveGroup("$userName");
                                },
                                icon: Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                              )
                            : null,
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
            // Text("No group members");
          }
        } else {
          return Container();
          // Text("No group data available");
        }
      },
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    deselectUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage - ${widget.groupChatScreenController.groupName}"),
        leading: IconButton(
          onPressed: () async {
            widget.groupChatScreenController.goBackOnePageFunc();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     // print(widget.groupChatScreenController.groupMembers.length);
          //     print(
          //         await widget.groupChatScreenController.getGroupMemberList());
          //     print(widget.groupChatScreenController.otherGroupMemberInfo);
          //   },
          //   icon: const Icon(Icons.abc),
          //   // icon: const Icon(Icons.person_add),
          // ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(gSmallSpace * 2,
                      gSmallSpace, gSmallSpace * 2, gSmallSpace * 2),
                  child: Row(
                    children: [
                      isSearching
                          ? Padding(
                              // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              padding: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  if (isAnyUserSelected) {
                                    deselectUser();
                                    setState(() {});
                                  } else {
                                    isSearching = false;
                                    userSearchController.text = "";
                                    setState(() {});
                                  }
                                },
                                child: Icon(Icons.arrow_back),
                              ),
                            )
                          : Container(),
                      Expanded(
                          child: Container(
                        // margin: EdgeInsets.symmetric(vertical: 16),
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(gBorderRadius)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: userSearchController,
                                style: Theme.of(context).textTheme.titleSmall,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Username"),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (userSearchController.text != "") {
                                  onSearchButtonClick();
                                }
                              },
                              child: Icon(Icons.search),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                isSearching ? searchUsersList() : Container(),

                SizedBox(
                  height: gSmallSpace,
                ),
                // Widget you want at the bottom

                (isAnyUserSelected)
                    ? Padding(
                        padding: const EdgeInsets.all(gSmallSpace * 2),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              widget.groupChatScreenController
                                  .inviteUserToGroup(selectedUserName!);
                            },
                            child: Text("INVITE USER TO GROUP"),
                          ),
                        ),
                      )
                    : Container(),

                // SizedBox(
                //   height: gSmallSpace,
                // ),

                isSearching
                    ? Container()
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            border: Border(
                                bottom: BorderSide(
                              color:
                                  Colors.white, // Set the color of the border
                              width: 4.0,
                            ))),
                        child: Center(
                            child: Text(
                          "Group Members",
                          style: TextStyle(fontSize: 18),
                        )),
                      ),

                isSearching
                    ? Container()
                    : Container(
                        width: double.infinity,
                        // padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                        ),
                        child: currentUsersList(),
                      ),

                isSearching
                    ? Container()
                    : Container(
                        width: double.infinity,
                        // padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                        ),
                        child: ListTile(
                          leading: (gUser_icon_image != null)
                              ? Image.network(gUser_icon_image!)
                              : Image.asset(gUser_icon_2_image),
                          title: Text(gAccountName),
                          subtitle: Text(gAccountEmail),
                        ),
                      ),

                SizedBox(
                  height: gSmallSpace,
                ),
                // Widget you want at the bottom

                (!isSearching)
                    ? (widget.groupChatScreenController.groupCreatorUserName ==
                            gAccountUserName)
                        ? Padding(
                            padding: const EdgeInsets.all(gSmallSpace * 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  widget.groupChatScreenController
                                      .deleteGroup();
                                },
                                child: Text("DELETE GROUP"),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(gSmallSpace * 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  widget.groupChatScreenController
                                      .leaveGroup(gAccountUserName)
                                      .then((value) {
                                    Get.offAll(() => GroupChatScreen());
                                  });
                                },
                                child: Text("LEAVE GROUP"),
                              ),
                            ),
                          )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

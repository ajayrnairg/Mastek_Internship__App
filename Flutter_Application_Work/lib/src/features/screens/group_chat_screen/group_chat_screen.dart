import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/controllers/home_screen_controller.dart';
import 'package:rough_app/src/features/screens/chat_screen/chat_main_screen.dart';
import 'package:rough_app/src/features/screens/group_chat_screen/group_chat_main_screen.dart';
import 'package:rough_app/src/features/screens/home_screen/home_screen.dart';
import 'package:rough_app/src/utils/services/database.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../controllers/group_chat_screen_controller.dart';
import '../chat_screen/chat_screen.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final homeScreenController = Get.put(HomeScreenController());
  final GroupChatScreenController groupChatScreenController =
      Get.put(GroupChatScreenController());

  late Stream groupsStream = const Stream.empty();

  TextEditingController nameInputController = TextEditingController();

  static const List<String> languageList = <String>[
    gLanguage1,
    gLanguage2,
    gLanguage3,
    gLanguage4,
    gLanguage5,
    gLanguage6,
  ];

  String dropdown1Value = languageList.first;

  getGroupsList() async {
    groupsStream = await DatabaseMethods().getMyGroups(gAccountUserName);
    setState(() {});
  }

  getActiveGuys(String grpID) async {
    List activeList =
        await groupChatScreenController.getGroupActiveMemberList(grpID);
    return activeList;
  }

  Widget groupsList() {
    return StreamBuilder(
      stream: groupsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<DocumentSnapshot> groupDocs = snapshot.data.docs;

        return ListView.builder(
          itemCount: groupDocs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = groupDocs[index];

            return FutureBuilder(
              future: getActiveGuys(ds["groupID"]),
              builder: (context, activeMembersSnapshot) {
                if (activeMembersSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (activeMembersSnapshot.hasError) {
                  return Container();
                  // Text("Error fetching active members"),
                }

                List currentActiveMembers = activeMembersSnapshot.data as List;

                return GestureDetector(
                  onTap: () async {
                    setGroupDetailsOnTap(
                            ds["groupID"], ds["groupName"], ds["createdBy"])
                        .then((value) {
                      groupChatScreenController.goToGroupChatMainScreenFunc(
                          dropdown1Value, groupChatScreenController);
                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 1),
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    child: ListTile(
                      title: Text("${ds["groupName"]}"),
                      subtitle: Text("Total Members: ${ds["members"].length}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            color: (currentActiveMembers.length > 0)
                                ? Colors.green
                                : Colors.white,
                            size: 12,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("${currentActiveMembers.length}")
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Widget groupsList() {
  //   return StreamBuilder(
  //       stream: groupsStream,
  //       builder: (context, snapshot) {
  //         return snapshot.hasData
  //             ? ListView.builder(
  //                 itemCount: snapshot.data.docs.length,
  //                 shrinkWrap: true,
  //                 itemBuilder: (context, index) {
  //                   DocumentSnapshot ds = snapshot.data.docs[index];
  //                   List currentActiveMembers = getActiveGuys(ds["groupID"]);
  //                   return GestureDetector(
  //                     onTap: () async {
  //                       // print(ds["members"]);
  //                       setGroupDetailsOnTap(
  //                               ds["groupID"], ds["groupName"], ds["createdBy"])
  //                           .then((value) {
  //                         groupChatScreenController.goToGroupChatMainScreenFunc(
  //                             dropdown1Value, groupChatScreenController);
  //                       });
  //                     },
  //                     child: Container(
  //                       decoration: const BoxDecoration(
  //                         border: Border(
  //                           top: BorderSide(color: Colors.grey, width: 1),
  //                           // Border at the top
  //                           bottom: BorderSide(
  //                               color: Colors.grey,
  //                               width: 1), // Border at the bottom
  //                         ),
  //                       ),
  //                       child: ListTile(
  //                         title: Text("${ds["groupName"]}"),
  //                         subtitle:
  //                             Text("Total Members: ${ds["members"].length}"),
  //                         trailing: Row(
  //                           children: [
  //                             Icon(Icons.devices_other_outlined),
  //                             // Text("${currentActiveMembers.length}")
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //
  //                   Text("${ds["groupName"]}");
  //                 })
  //             : Center(
  //                 child: CircularProgressIndicator(),
  //               );
  //       });
  // }

  Future<void> setGroupDetailsOnTap(
      String groupID, String groupName, String creatorName) async {
    groupChatScreenController.groupID = groupID;
    groupChatScreenController.groupName = groupName;
    groupChatScreenController.groupCreatorUserName = creatorName;
  }

  @override
  void initState() {
    // TODO: implement initState
    getGroupsList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(gGroupChatScreenName),
        backgroundColor: isDarkMode ? gDarkPurple : gDarkPurple,
        leading: IconButton(
          onPressed: () {
            homeScreenController.goToHomePageFunc();
            // Get.to(()=>HomeScreen());
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Get.to(() => GroupChatMainScreen(
          //         selectedLanguage: dropdown1Value,
          //         groupChatScreenController: groupChatScreenController));
          //   },
          //   icon: Icon(Icons.arrow_back_ios),
          // )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(gSmallSpace),
                  child: Container(
                    height: height * 0.4,
                    padding: const EdgeInsets.all(gSmallSpace),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(gBorderRadius),
                      color: gDarkPurple,
                    ),
                    // color: Colors.blue,
                    child: Center(
                      child: Text(
                        gLangSelectionPage,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(gSmallSpace),
                    child:

                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            value: dropdown1Value,
                            items: languageList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) async {
                              dropdown1Value = val!;
                              // print(translatedTextController.text);
                            },
                            icon: const Icon(
                              Icons.arrow_drop_down_circle,
                              color: gDarkPurple,
                            ),
                            decoration: const InputDecoration(
                                labelText: gLangSelectionPage,
                                floatingLabelStyle: TextStyle(
                                  color: gDarkPurple,
                                ),
                                prefixIconColor: gDarkPurple,

                                // prefixIconColor: Colors.blue,
                                prefixIcon: Icon(Icons.sort_by_alpha_rounded),
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  padding: EdgeInsets.symmetric(horizontal: 18),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: TextField(
                                    controller: nameInputController,
                                    style: TextStyle(fontSize: 20),
                                    decoration: InputDecoration(
                                        border: InputBorder.none, hintText: "Group Name"),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (nameInputController.text != '') {
                                    groupChatScreenController.createNewGroup(
                                        nameInputController.text.trim());
                                    nameInputController.text = '';
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "CREATE",
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        groupsList()
                      ],
                    )),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

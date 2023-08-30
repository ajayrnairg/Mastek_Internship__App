import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/image_strings.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/controllers/chat_screen_controller.dart';
import 'package:rough_app/src/features/controllers/home_screen_controller.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../utils/services/database.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final homeScreenController = Get.put(HomeScreenController());
  final chatScreenController = Get.put(ChatScreenController());

  bool isSearching = false;
  late Stream usersStream;
  bool isAnyUserSelected = false;

  int selectedIndex = -1;

  TextEditingController userSearchController = TextEditingController();

  static const List<String> languageList = <String>[
    gLanguage1,
    gLanguage2,
    gLanguage3,
    gLanguage4,
    gLanguage5,
    gLanguage6,
  ];

  String dropdown1Value = languageList.first;

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
    chatScreenController.selectedUserID = userID;
    chatScreenController.selectedUserDisplayName = displayName;
    chatScreenController.selectedUserEmail = userEmail;
    chatScreenController.selectedUserName = userName;
    chatScreenController.selectedUserProfilePicURL = profilePicURL;
    chatScreenController.selectedUserToken = userToken;
    setState(() {});
  }

  onSearchButtonClick() async {
    isSearching = true;
    setState(() {});
    usersStream =
        await DatabaseMethods().getUserByUserName(userSearchController.text);
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
                      if (ds["token"] != "") {
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
                              leading: (ds["profileURL"] != null) ? Image.network(ds["profileURL"]):Image.asset(gUser_icon_2_image),
                              title: Text(ds["displayname"]),
                              subtitle: Text(ds["email"]),
                            ),
                          ),
                        );
                      } else {
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(gChatScreenName),
        backgroundColor: isDarkMode ? gDarkPurple : gDarkPurple,
        leading: IconButton(
          onPressed: () {
            homeScreenController.goToHomePageFunc();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // margin: EdgeInsets.all(20),
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
                const SizedBox(height: gDefaultSize),

                Padding(
                  padding: const EdgeInsets.fromLTRB(gSmallSpace * 2,
                      gSmallSpace * 2, gSmallSpace * 2, gSmallSpace),
                  child: Container(
                    // padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(gBorderRadius)),
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
                          floatingLabelStyle: TextStyle(color: gDarkPurple),
                          prefixIconColor: gDarkPurple,
                          prefixIcon: Icon(Icons.sort_by_alpha_rounded),
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(gSmallSpace * 2,
                      gSmallSpace, gSmallSpace * 2, gSmallSpace * 2),
                  child: Row(
                    children: [
                      isSearching
                          ? Padding(
                              // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              padding: const EdgeInsets.all(0),
                              child: InkWell(
                                onTap: () {
                                  if (isAnyUserSelected) {
                                    isAnyUserSelected = false;
                                    selectedIndex = -1;
                                    chatScreenController.selectedUserID = null;
                                    chatScreenController.selectedUserName =
                                        null;
                                    chatScreenController
                                        .selectedUserDisplayName = null;
                                    chatScreenController
                                        .selectedUserProfilePicURL = null;
                                    chatScreenController.selectedUserEmail =
                                        null;
                                    chatScreenController.selectedUserToken =
                                        null;
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
                        // padding: EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(5.0)),
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

                Padding(
                  padding: const EdgeInsets.all(gSmallSpace * 2),
                  child: (isAnyUserSelected)
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await chatScreenController.generateChatRoom();
                              await chatScreenController.inviteUserToChatRoom();
                              chatScreenController.goToChatMainScreenFunc(
                                  dropdown1Value, chatScreenController);
                            },
                            child: Text(
                              gStartConversation.toUpperCase(),
                            ),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

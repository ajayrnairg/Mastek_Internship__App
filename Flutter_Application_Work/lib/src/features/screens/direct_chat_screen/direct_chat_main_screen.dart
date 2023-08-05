import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';
import 'package:rough_app/src/features/controllers/home_screen_controller.dart';

import '../../../common_widgets/toggle_widget/toggle_switch_widget.dart';
import '../../../constants/colors.dart';
import '../../../constants/text_strings.dart';
import 'chat_widget/chat_message_container_main_widget.dart';

class DirectChatMainScreen extends StatefulWidget {
  DirectChatMainScreen({
    super.key,
    required this.selectedLang1,
    required this.selectedLang2,
  });

  final String selectedLang1, selectedLang2;

  @override
  State<DirectChatMainScreen> createState() => _DirectChatMainScreenState();
}

class _DirectChatMainScreenState extends State<DirectChatMainScreen> {
  final homeScreenController = Get.put(HomeScreenController());
  final directChatScreenController = Get.put(DirectChatScreenController());

  @override
  void initState() {
    // TODO: implement initState
    directChatScreenController.initializeTogglerData(
        widget.selectedLang1, widget.selectedLang2);
    super.initState();
  }

  Future<void> updateMyUI() async {
    setState(() {});
  }

  void deselectMessage() {
    directChatScreenController.isAnyMessageSelected = false;
    directChatScreenController.selectedMessageIndex = null;
    directChatScreenController.selectedMessageDesiredLanguage = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;


    return Scaffold(
        appBar: AppBar(
          title: const Text(gDirectChatScreenName),
          backgroundColor: isDarkMode ? gDarkPurple : gDarkPurple,
          leading: directChatScreenController.isAnyMessageSelected
              ? IconButton(
                  onPressed: () {
                    deselectMessage();
                  },
                  icon: const Icon(Icons.arrow_back),
                )
              : IconButton(
                  onPressed: () {
                    homeScreenController.goBackOnePageFunc();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
          actions: directChatScreenController.isAnyMessageSelected
              ? [
                  IconButton(
                      onPressed: () {
                        directChatScreenController.addSelectedMessageToClipboard();
                      },
                      icon: const Icon(Icons.copy)),
                  IconButton(
                      onPressed: () {
                        directChatScreenController.playSelectedMessageAsAudio();
                      },
                      icon: const Icon(Icons.volume_up))
                ]
              : null,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                    child: ToggleButtons(
                      borderColor: gDarkPurple,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      selectedBorderColor: gDarkPurple,
                      selectedColor: Colors.white,
                      fillColor: gDarkPurple,
                      color: gDarkPurple,
                      direction: Axis.horizontal,
                      constraints: BoxConstraints(
                        minHeight: 40.0,
                        minWidth: size.width * 0.45,
                      ),
                      textStyle: const TextStyle(fontSize: 20),
                      onPressed: (int index) {
                        setState(() {
                          //   // The button that is tapped is set to true, and the others to false.
                          for (int i = 0;
                              i <
                                  directChatScreenController
                                      .selectedLanguages.length;
                              i++) {
                            directChatScreenController.selectedLanguages[i] =
                                i == index;
                            // print(directChatScreenController.selectedLanguages[i]);
                          }
                        });
                      },
                      isSelected: directChatScreenController.selectedLanguages,
                      children: directChatScreenController.languages,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 9,

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ChatMessageContainerMainWidget(
                        size: size,
                        directChatScreenController: directChatScreenController,
                        selectedLang1: widget.selectedLang1,
                        selectedLang2: widget.selectedLang2,
                        updateParentUI: updateMyUI),
                  ),
                ),
              ),
            ],
          ),
        )

        // Center(
        //   child: SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         Center(
        //           child: ToggleButtons(
        //             borderColor: Colors.blue,
        //             borderRadius: const BorderRadius.all(Radius.circular(5)),
        //             selectedBorderColor: Colors.blue,
        //             selectedColor: Colors.white,
        //             fillColor: Colors.blue,
        //             color: Colors.blue,
        //             direction: Axis.horizontal,
        //             constraints: BoxConstraints(
        //               minHeight: 40.0,
        //               minWidth: size.width * 0.45,
        //             ),
        //             onPressed: (int index) {
        //
        //               setState(() {
        //               //   // The button that is tapped is set to true, and the others to false.
        //                 for (int i = 0; i < directChatScreenController.selectedLanguages.length; i++) {
        //                   directChatScreenController.selectedLanguages[i] = i == index;
        //                   // print(directChatScreenController.selectedLanguages[i]);
        //                 }
        //               });
        //             },
        //             isSelected: directChatScreenController.selectedLanguages,
        //             children: directChatScreenController.languages,
        //           ),
        //         ),
        //         // Center(
        //         //   child: ToggleSwitchWidget(
        //         //       size: size,
        //         //       selectedLang1: widget.selectedLang1,
        //         //       selectedLang2: widget.selectedLang2),
        //         // ),
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: ChatMessageContainerMainWidget(
        //               size: size,
        //               directChatScreenController: directChatScreenController,
        //               selectedLang1: widget.selectedLang1,
        //               selectedLang2: widget.selectedLang2),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}

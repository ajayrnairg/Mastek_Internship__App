import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';
import 'package:rough_app/src/features/controllers/home_screen_controller.dart';
import '../../../common_widgets/chat_widget/chat_message_container_main_widget.dart';
import '../../../common_widgets/toggle_widget/toggle_switch_widget.dart';
import '../../../constants/text_strings.dart';

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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text(gDirectChatScreenName),
          leading: IconButton(
            onPressed: () {
              homeScreenController.goBackOnePageFunc();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.copy)),
            Switch(
                // This bool value toggles the switch.
                value: directChatScreenController.switchValue,
                activeColor: Colors.red,
                onChanged: (bool value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    directChatScreenController.switchValue = value;
                  });
                  // print(directChatScreenController.switchValue);
                })
          ]),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ToggleSwitchWidget(
                    size: size,
                    selectedLang1: widget.selectedLang1,
                    selectedLang2: widget.selectedLang2),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatMessageContainerMainWidget(
                    size: size,
                    directChatScreenController: directChatScreenController,
                    selectedLang1: widget.selectedLang1,
                    selectedLang2: widget.selectedLang2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

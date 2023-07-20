import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/features/controllers/home_screen_controller.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';
import '../../controllers/direct_chat_screen_controller.dart';
import 'direct_chat_main_screen.dart';

class DirectChatScreen extends StatefulWidget {
  const DirectChatScreen({Key? key}) : super(key: key);

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {
  _DirectChatScreenState() {
    _selectedVal1 = dropDownListItems1.firstOrNull;
    _selectedVal2 = dropDownListItems2.firstOrNull;
  }

  final dropDownListItems1 = [
    gFirstLang1,
    gFirstLang2,
    gFirstLang3,
    gFirstLang4
  ];
  String? _selectedVal1 = "";
  final dropDownListItems2 = [
    gSecondLang2,
    gSecondLang1,
    gSecondLang3,
    gSecondLang4
  ];
  String? _selectedVal2 = "";

  @override
  Widget build(BuildContext context) {
    final homeScreenController = Get.put(HomeScreenController());
    // final directChatScreenController = Get.put(DirectChatScreenController());

    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(gDirectChatScreenName),
        leading: IconButton(
          onPressed: () {
            homeScreenController.goToHomePageFunc();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(gSmallSpace),
              child: Container(
                height: height * 0.4,
                padding: const EdgeInsets.all(gSmallSpace),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(gBorderRadius),
                  color: Colors.blue,
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
              padding: const EdgeInsets.fromLTRB(gSmallSpace * 2, gSmallSpace * 2,
                  gSmallSpace * 2, gSmallSpace),
              child: DropdownButtonFormField(
                isExpanded: true,
                value: _selectedVal1,
                items: dropDownListItems1
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
                onChanged: (val) {
                  setState(() {
                    _selectedVal1 = val;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                    labelText: gChooseFirstLang,
                    prefixIcon: Icon(Icons.sort_by_alpha_rounded),
                    border: OutlineInputBorder()),
              ),
            ),
            // const SizedBox(height: gSmallSpace),

            Padding(
              padding: const EdgeInsets.fromLTRB(gSmallSpace * 2, gSmallSpace,
                  gSmallSpace * 2, gSmallSpace * 2),
              child: DropdownButtonFormField(
                isExpanded: true,
                value: _selectedVal2,
                items: dropDownListItems2
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
                onChanged: (val) {
                  setState(() {
                    _selectedVal2 = val;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                    labelText: gChooseFirstLang,
                    prefixIcon: Icon(Icons.language_sharp),
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(gSmallSpace * 2),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => DirectChatMainScreen(
                      selectedLang1: _selectedVal1!, selectedLang2: _selectedVal2!));
                  // directChatScreenController.goToDirectMainChatFunc(
                  //     _selectedVal1, _selectedVal2);
                },
                child: const Center(
                  child: Text(gNextButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

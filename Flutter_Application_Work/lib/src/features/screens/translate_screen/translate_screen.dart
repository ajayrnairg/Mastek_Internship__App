import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/controllers/home_screen_controller.dart';

class TranslateScreen extends StatelessWidget {
  const TranslateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = Get.put(HomeScreenController());
    return Scaffold(
      appBar: AppBar(
        title: Text(gTranslateScreenName),
        leading: IconButton(
          onPressed: () {
            homeScreenController.goToHomePageFunc();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        child: Center(
          child: Text("Translate Screen"),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/colors.dart';
import 'package:rough_app/src/constants/text_strings.dart';

import '../../../constants/image_strings.dart';
import '../../../constants/sizes.dart';
import '../../controllers/welcome_screen_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final welcomeScreenController = Get.put(WelcomeScreenController());

    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? gSecondaryColor : gPrimaryColor,
      body: Container(
        padding: EdgeInsets.all(gDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage(gWelcome_1_image),
              height: height * 0.4,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  gWelcomeTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  gWelcomeSubTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      welcomeScreenController.logInFunc();
                    },
                    child: Text(gLogin),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      welcomeScreenController.signUpFunc();
                    },
                    child: Text(gSignup),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

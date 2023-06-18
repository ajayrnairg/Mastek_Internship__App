import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rough_app/src/features/screens/onboarding_screen/onboarding_screen.dart';

import '../screens/welcome_screen/welcome_screen.dart';


class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();
  RxBool animate = false.obs;

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 200));
    animate.value = true;
    await Future.delayed(Duration(milliseconds: 6000));
    // Get.to(() => WelcomeScreen());
    Get.to(() => OnboardingScreen());
  }
}
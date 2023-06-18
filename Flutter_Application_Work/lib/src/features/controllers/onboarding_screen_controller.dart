import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:rough_app/src/constants/colors.dart';
import 'package:rough_app/src/constants/image_strings.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/models/model_onboarding.dart';

import '../screens/onboarding_screen/onboarding_screen_page_widget.dart';
import '../screens/welcome_screen/welcome_screen.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get find => Get.find();
  final controller = LiquidController();

  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
        model: OnBoardingModel(
      image: gOnboarding_1_image,
      title: gOnBoardingTitle1,
      subTitle: gOnBoardingSubTitle1,
      counterText: gOnBoardingCounter1,
      bgColor: gOnboardingPage1Color,
    )),
    OnBoardingPageWidget(
        model: OnBoardingModel(
      image: gOnboarding_2_image,
      title: gOnBoardingTitle2,
      subTitle: gOnBoardingSubTitle2,
      counterText: gOnBoardingCounter2,
      bgColor: gOnboardingPage2Color,
    )),
    OnBoardingPageWidget(
        model: OnBoardingModel(
      image: gOnboarding_3_image,
      title: gOnBoardingTitle3,
      subTitle: gOnBoardingSubTitle3,
      counterText: gOnBoardingCounter3,
      bgColor: gOnboardingPage3Color,
    )),
    OnBoardingPageWidget(
        model: OnBoardingModel(
      image: gOnboarding_4_image,
      title: gOnBoardingTitle4,
      subTitle: gOnBoardingSubTitle4,
      counterText: gOnBoardingCounter4,
      bgColor: gOnboardingPage4Color,
    )),
  ];

  onPageChangedCallback(int activePageIndex){
    currentPage.value = activePageIndex;
  }

  // skip() => controller.jumpToPage(page: 3);

  skip() {
    Get.to(() => WelcomeScreen());
  }


  animateToNextSlide(){
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }
}

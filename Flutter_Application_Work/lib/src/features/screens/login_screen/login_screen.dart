import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/image_strings.dart';
import 'package:rough_app/src/constants/sizes.dart';
import 'package:rough_app/src/features/controllers/signup_login_screen_controller.dart';
import 'package:rough_app/src/features/screens/login_screen/login_footer_widget.dart';
import 'package:rough_app/src/features/screens/login_screen/login_form_widget.dart';

import '../../../common_widgets/form_widget/form_header_widget.dart';
import '../../../constants/text_strings.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupLoginScreenController = Get.put(SignupLoginScreenController());
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(gDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Section - 1 */
                FormHeaderWidget(
                    size: size,
                    image: gWelcome_1_image,
                    title: gLoginTitle,
                    subTitle: gLoginSubTitle, controller: signupLoginScreenController),

                /* Section - 2 */
                LoginFormWidget(controller: signupLoginScreenController),

                /* Section - 3 */

                LoginFooterWidget(controller: signupLoginScreenController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

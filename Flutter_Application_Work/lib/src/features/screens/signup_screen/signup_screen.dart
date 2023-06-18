import 'package:flutter/material.dart';
import 'package:rough_app/src/common_widgets/form_widget/form_header_widget.dart';
import 'package:rough_app/src/constants/image_strings.dart';
import 'package:rough_app/src/constants/sizes.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/screens/signup_screen/signup_footer_widget.dart';
import 'package:rough_app/src/features/screens/signup_screen/signup_form_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(gDefaultSize),
            child: Column(
              children: [
                /* Section - 1 */
                FormHeaderWidget(
                    size: size,
                    image: gWelcome_1_image,
                    title: gSignupTitle,
                    subTitle: gSignUpSubTitle),

                /* Section - 2 */
                SignupFormWidget(),

                /* Section - 3 */
                SignupFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

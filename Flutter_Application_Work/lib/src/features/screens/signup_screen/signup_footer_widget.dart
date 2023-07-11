import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/signup_login_screen_controller.dart';

import '../../../constants/image_strings.dart';
import '../../../constants/text_strings.dart';

class SignupFooterWidget extends StatelessWidget {
  const SignupFooterWidget({
    super.key,
    required this.controller,
  });

  final SignupLoginScreenController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        TextButton(
          onPressed: () {controller.goToLoginPageFunc();},
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: gAlreadyHaveAnAccount,
                    style: Theme.of(context).textTheme.titleSmall),
                TextSpan(text: gLogin.toUpperCase()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

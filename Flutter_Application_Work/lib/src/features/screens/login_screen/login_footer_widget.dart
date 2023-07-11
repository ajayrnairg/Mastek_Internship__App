import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/signup_login_screen_controller.dart';

import '../../../constants/image_strings.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';
import '../../../utils/services/auth.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
    required this.controller,
  });

  final SignupLoginScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('OR'),
        const SizedBox(
          height: gFormHeight - 20.0,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(
              image: AssetImage(gGoogleLogoImage),
              width: 20.0,
            ),
            onPressed: () {
              AuthMethods().signInWithGoogle(context);
            },
            label: const Text(gSignInWithGoogle),
          ),
        ),
        const SizedBox(height: gFormHeight - 20.0),
        TextButton(
          onPressed: () {
            controller.goToSignupPageFunc();
          },
          child: Text.rich(
            TextSpan(
              text: gDontHaveAnAccount,
              style: Theme.of(context).textTheme.titleSmall,
              children: const [
                TextSpan(
                  text: gSignup,
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

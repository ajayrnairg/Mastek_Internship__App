import 'package:flutter/material.dart';

import '../../../constants/image_strings.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

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
            icon: Image(
              image: AssetImage(gGoogleLogoImage),
              width: 20.0,
            ),
            onPressed: () {},
            label: Text(gSignInWithGoogle),
          ),
        ),
        const SizedBox(height: gFormHeight - 20.0),
        TextButton(
          onPressed: () {},
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

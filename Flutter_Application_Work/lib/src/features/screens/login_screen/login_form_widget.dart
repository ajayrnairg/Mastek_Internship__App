import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/signup_login_screen_controller.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';


class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({
    super.key,
    required this.controller,
  });

  final SignupLoginScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: gFormHeight - 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: gEmail,
                hintText: gEmail,
                // border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.fingerprint),
                labelText: gPassword,
                hintText: gPassword,
                // border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye_sharp),
                ),
              ),
            ),
            const SizedBox(height: gFormHeight - 20.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(gForgotPassword),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {controller.goToHomePageFunc();},
                child: Text(
                  gLogin.toUpperCase(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

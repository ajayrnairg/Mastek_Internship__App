import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/signup_login_screen_controller.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({
    super.key,
    required this.controller,
  });
  final SignupLoginScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: gFormHeight - 10.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                decoration: InputDecoration(
                  label: Text(gFullName, style: Theme.of(context).textTheme.titleSmall),
                  prefixIcon: Icon(Icons.person_outline_rounded),
                )),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
                decoration: InputDecoration(
                  label: Text(gEmail, style: Theme.of(context).textTheme.titleSmall),
                  prefixIcon: Icon(Icons.email_outlined),
                )),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
                decoration: InputDecoration(
                  label: Text(gPhone, style: Theme.of(context).textTheme.titleSmall),
                  prefixIcon: Icon(Icons.numbers),
                )),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
                decoration: InputDecoration(
                  label: Text(gPassword, style: Theme.of(context).textTheme.titleSmall),
                  prefixIcon: Icon(Icons.fingerprint),
                )),
            const SizedBox(height: gFormHeight - 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {controller.goToLoginPageFunc();},
                child: Text(gSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
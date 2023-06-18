import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({
    super.key,
  });

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
                  label: Text(gFullName),
                  prefixIcon: Icon(Icons.person_outline_rounded),
                )),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
                decoration: InputDecoration(
                  label: Text(gEmail),
                  prefixIcon: Icon(Icons.email_outlined),
                )),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
                decoration: InputDecoration(
                  label: Text(gPhone),
                  prefixIcon: Icon(Icons.numbers),
                )),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
                decoration: InputDecoration(
                  label: Text(gPassword),
                  prefixIcon: Icon(Icons.fingerprint),
                )),
            const SizedBox(height: gFormHeight - 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(gSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
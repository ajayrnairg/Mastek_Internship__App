import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/signup_login_screen_controller.dart';
import 'package:rough_app/src/features/screens/login_screen/login_screen.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';
import '../../../utils/services/auth.dart';


class SignupFormWidget extends StatefulWidget {
  const SignupFormWidget({
    super.key,
    required this.controller,
  });

  final SignupLoginScreenController controller;
  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();


}

class _SignupFormWidgetState extends State<SignupFormWidget> {

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController displayNameTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    displayNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: gFormHeight - 10.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                controller: displayNameTextController,
                enableSuggestions: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  label: Text(gFullName,
                      style: Theme.of(context).textTheme.titleSmall),
                  prefixIcon: Icon(Icons.person_outline_rounded),
                )),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
                controller: emailTextController,
                enableSuggestions: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  label: Text(gEmail,
                      style: Theme.of(context).textTheme.titleSmall),
                  prefixIcon: Icon(Icons.email_outlined),
                )),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
                controller: passwordTextController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  label: Text(gPassword,
                      style: Theme.of(context).textTheme.titleSmall),
                  prefixIcon: const Icon(Icons.fingerprint),
                )),
            const SizedBox(height: gFormHeight),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AuthMethods()
                      .signUpWithEmailPassword(context,
                      displayNameTextController.text,
                      emailTextController.text,
                      passwordTextController.text)
                      .then((value) {
                    print("Created new account");
                    widget.controller.goToLoginPageFunc();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => const LogInScreen()));
                  }).onError((error, stackTrace) {
                    print("Error while creating new account: ${error.toString()}");
                  });

                },
                child: Text(gSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// class SignupFormWidget extends StatelessWidget {
//   SignupFormWidget({
//     super.key,
//     required this.controller,
//   });
//
//   final SignupLoginScreenController controller;
//   TextEditingController emailTextController = TextEditingController();
//   TextEditingController passwordTextController = TextEditingController();
//   TextEditingController displayNameTextController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: gFormHeight - 10.0),
//       child: Form(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//                 controller: displayNameTextController,
//                 enableSuggestions: true,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   label: Text(gFullName,
//                       style: Theme.of(context).textTheme.titleSmall),
//                   prefixIcon: Icon(Icons.person_outline_rounded),
//                 )),
//             const SizedBox(height: gFormHeight - 20.0),
//             TextFormField(
//                 controller: emailTextController,
//                 enableSuggestions: true,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   label: Text(gEmail,
//                       style: Theme.of(context).textTheme.titleSmall),
//                   prefixIcon: Icon(Icons.email_outlined),
//                 )),
//             const SizedBox(height: gFormHeight - 20.0),
//             TextFormField(
//                 controller: passwordTextController,
//                 obscureText: true,
//                 enableSuggestions: false,
//                 autocorrect: false,
//                 decoration: InputDecoration(
//                   label: Text(gPassword,
//                       style: Theme.of(context).textTheme.titleSmall),
//                   prefixIcon: Icon(Icons.fingerprint),
//                 )),
//             const SizedBox(height: gFormHeight),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   AuthMethods()
//                       .signUpWithEmailPassword(context,
//                       displayNameTextController.text,
//                       emailTextController.text,
//                       passwordTextController.text)
//                       .then((value) {
//                     print("Created new account");
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => LogInScreen()));
//                   }).onError((error, stackTrace) {
//                     print("Error while creating new account: ${error.toString()}");
//                   });
//                   // controller.goToLoginPageFunc();
//                 },
//                 child: Text(gSignup.toUpperCase()),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:rough_app/src/features/controllers/signup_login_screen_controller.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';
import '../../../utils/services/auth.dart';

class LoginFormWidget extends StatefulWidget {
  // const LoginFormWidget({super.key});
  const LoginFormWidget({
    super.key,
    required this.controller,
  });

  final SignupLoginScreenController controller;

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool hidePassword = true;
  final formKey = GlobalKey<FormState>();
  String? errorMessage;

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void togglePassword() {
    if (hidePassword == true) {
      hidePassword = false;
    } else {
      hidePassword = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: gFormHeight - 10.0),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                controller: emailTextController,
                enableSuggestions: true,
                keyboardType: TextInputType.emailAddress,
                style: Theme.of(context).textTheme.titleSmall,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: gEmail,
                  hintText: gEmail,
                  // border: OutlineInputBorder(),
                ),
                validator: (emailId) {
                  if (emailId != null && !EmailValidator.validate(emailId)) {
                    return "Enter a valid email";
                  } else {
                    return null;
                  }
                }),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
              controller: passwordTextController,
              obscureText: hidePassword,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              style: Theme.of(context).textTheme.titleSmall,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint),
                labelText: gPassword,
                hintText: gPassword,
                // border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    togglePassword();
                  },
                  icon: hidePassword
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.remove_red_eye_sharp),
                ),
              ),
              validator: (value) {
                if (value != null && value.contains(" ")) {
                  return "Password cannot contain empty spaces.";
                } else if (value != null && value.length < 6) {
                  return "Enter minimum 6 characters";
                } else {
                  return null;
                }
              },
            ),
            (errorMessage != null)
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, gFormHeight, 0, 0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: gFormHeight - 20.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  widget.controller.goToForgotPasswordFunc();
                },
                child: const Text(gForgotPassword),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final isValidForm = formKey.currentState!.validate();
                  if (isValidForm) {
                    errorMessage = await AuthMethods().signInWithEmailPassword(
                        emailTextController.text.trim(),
                        passwordTextController.text.trim());
                    setState(() {});
                    if (errorMessage == null) {
                      print("Logged In Successfully");

                      widget.controller.goToHomePageFunc();
                    }

                    // AuthMethods()
                    //     .signInWithEmailPassword(emailTextController.text,
                    //     passwordTextController.text)
                    //     .then((value) {
                    //   print("Logged In Successfully");
                    //
                    //   widget.controller.goToHomePageFunc();
                    //   // Get.offAll(()=>const HomeScreen());
                    //   // Navigator.pushReplacement(context,
                    //   //     MaterialPageRoute(builder: (context) => const HomeScreen()));
                    // }).onError((error, stackTrace) {
                    //
                    //   print("Error Logging In:  ${error.toString()}");
                    // });
                  }
                },
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

//
// class LoginFormWidget extends StatelessWidget {
//   LoginFormWidget({
//     super.key,
//     required this.controller,
//   });
//
//   final SignupLoginScreenController controller;
//   TextEditingController emailTextController = TextEditingController();
//   TextEditingController passwordTextController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: gFormHeight - 10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: emailTextController,
//               enableSuggestions: true,
//               keyboardType: TextInputType.emailAddress,
//               style: Theme.of(context).textTheme.titleSmall,
//               decoration: const InputDecoration(
//                 prefixIcon: Icon(Icons.person_outline_outlined),
//                 labelText: gEmail,
//                 hintText: gEmail,
//                 // border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: gFormHeight - 20.0),
//             TextFormField(
//               controller: passwordTextController,
//               obscureText: true,
//               enableSuggestions: false,
//               autocorrect: false,
//               keyboardType: TextInputType.visiblePassword,
//               style: Theme.of(context).textTheme.titleSmall,
//               decoration: const InputDecoration(
//                 prefixIcon: Icon(Icons.fingerprint),
//                 labelText: gPassword,
//                 hintText: gPassword,
//                 // border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   onPressed: null,
//                   icon: Icon(Icons.remove_red_eye_sharp),
//                 ),
//               ),
//             ),
//             const SizedBox(height: gFormHeight - 20.0),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {},
//                 child: Text(gForgotPassword),
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   AuthMethods()
//                       .signInWithEmailPassword(emailTextController.text,
//                       passwordTextController.text)
//                       .then((value) {
//                     print("Logged In Successfully");
//
//                     controller.goToHomePageFunc();
//                     // Navigator.push(context,
//                     //     MaterialPageRoute(builder: (context) => Home()));
//                   }).onError((error, stackTrace) {
//                     print("Error Logging In:  ${error.toString()}");
//                   });
//
//                 },
//                 child: Text(
//                   gLogin.toUpperCase(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: gFormHeight - 10.0),
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
            ),
            const SizedBox(height: gFormHeight - 20.0),
            TextFormField(
              controller: passwordTextController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              style: Theme.of(context).textTheme.titleSmall,
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
                child: const Text(gForgotPassword),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AuthMethods()
                      .signInWithEmailPassword(emailTextController.text,
                      passwordTextController.text)
                      .then((value) {
                    print("Logged In Successfully");

                    widget.controller.goToHomePageFunc();
                    // Get.offAll(()=>const HomeScreen());
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => const HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error Logging In:  ${error.toString()}");
                  });

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

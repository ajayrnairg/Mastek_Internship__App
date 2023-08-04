import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/colors.dart';
import 'package:rough_app/src/constants/text_strings.dart';

import '../../../constants/sizes.dart';
import '../../../utils/services/auth.dart';
import '../../controllers/signup_login_screen_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final signupLoginScreenController = Get.put(SignupLoginScreenController());
  final formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  bool mailSent = false;
  String? errorMessage;

  void onSuccessfulMail() {
    setState(() {
      mailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(gResetPassword),
          leading: IconButton(
            onPressed: () {
              signupLoginScreenController.goToLoginPageFunc();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  gForgotPasswordEmailRequest,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    controller: emailTextController,
                    onChanged: (p){setState(() {
                      errorMessage =null;
                    });},
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
                      if (emailId != null &&
                          !EmailValidator.validate(emailId)) {
                        return "Enter a valid email";
                      } else {
                        return null;
                      }
                    }),
              ),
              (errorMessage != null)
                  ? Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 20, 8.0, 0.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              )
                  : Container(),
              mailSent
                  ? const Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 20, 8.0, 0.0),
                      child: Text(
                        "Password Reset Mail sent Successfully",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      ))
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final isValidForm = formKey.currentState!.validate();
                      if (isValidForm) {
                        errorMessage = await AuthMethods()
                            .passwordReset(
                          emailTextController.text,
                        );
                        mailSent = false;
                        setState(() {

                        });

                        if(errorMessage == null){
                          print("Password Reset Mail sent Successfully");
                          onSuccessfulMail();
                        }
                        //
                        // AuthMethods()
                        //     .passwordReset(
                        //   emailTextController.text,
                        // )
                        //     .then((value) {
                        //   print("Password Reset Mail sent Successfully");
                        //   onSuccessfulMail();
                        //   // widget.controller.goToHomePageFunc();
                        //   // Get.offAll(()=>const HomeScreen());
                        //   // Navigator.pushReplacement(context,
                        //   //     MaterialPageRoute(builder: (context) => const HomeScreen()));
                        // }).onError((error, stackTrace) {
                        //   mailSent = false;
                        //   print(
                        //       "Error sending Password Reset Mail:  ${error.toString()}");
                        // });
                      }
                    },
                    child: Text(
                      gResetPassword.toUpperCase(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "$gAssistance $gMastekEmail",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

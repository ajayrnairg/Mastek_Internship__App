import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/signup_login_screen_controller.dart';


class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    super.key,
    required this.size,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.controller,
  });

  final Size size;
  final String image, title, subTitle;
  final SignupLoginScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(image),
          height: size.height * 0.2,
        ),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        Text(subTitle, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}

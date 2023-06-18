import 'package:flutter/material.dart';
import 'package:rough_app/src/constants/colors.dart';

class GTextFormFieldTheme {
  GTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: gSecondaryColor,
    floatingLabelStyle: TextStyle(color: gSecondaryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: gSecondaryColor),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme =
      const InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: gPrimaryColor,
    floatingLabelStyle: TextStyle(color: gPrimaryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: gPrimaryColor),
    ),
  );
}

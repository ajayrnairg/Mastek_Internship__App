import 'package:flutter/material.dart';
import 'package:rough_app/src/constants/colors.dart';
import 'package:rough_app/src/constants/sizes.dart';

class GElevatedButtonTheme {
  GElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      foregroundColor: gWhiteColor,
      backgroundColor: gSecondaryColor,
      side: BorderSide(color: gSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: gButtonHeight),

    ),
  );


  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      foregroundColor: gSecondaryColor,
      backgroundColor: gWhiteColor,
      side: BorderSide(color: gSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: gButtonHeight),


    ),
  );

}
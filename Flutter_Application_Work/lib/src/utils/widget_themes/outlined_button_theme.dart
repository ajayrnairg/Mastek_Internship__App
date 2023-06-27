import 'package:flutter/material.dart';
import 'package:rough_app/src/constants/colors.dart';

import '../../constants/sizes.dart';

class GOutlinedButtonTheme {
  GOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      foregroundColor: gSecondaryColor,
      side: BorderSide(color: gSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: gButtonHeight),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      foregroundColor: gWhiteColor,
      side: BorderSide(color: gWhiteColor),
      padding: EdgeInsets.symmetric(vertical: gButtonHeight),
    ),
  );
}

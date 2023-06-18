import 'package:flutter/material.dart';
import 'package:rough_app/src/utils/widget_themes/elevated_button_theme.dart';
import 'package:rough_app/src/utils/widget_themes/outlined_button_theme.dart';
import 'package:rough_app/src/utils/widget_themes/text_field_theme.dart';
import 'package:rough_app/src/utils/widget_themes/text_theme.dart';

class GAppTheme {
  GAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: GTextTheme.lightTextTheme,
    outlinedButtonTheme: GOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: GElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: GTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: GTextTheme.darkTextTheme,
    outlinedButtonTheme: GOutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: GElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: GTextFormFieldTheme.darkInputDecorationTheme,
  );
}

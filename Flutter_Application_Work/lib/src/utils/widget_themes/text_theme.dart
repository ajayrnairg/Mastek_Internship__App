import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';


class GTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      color: gTextColor1,
      fontSize: 36,
    ),
   headlineMedium: GoogleFonts.montserrat(
     color: gTextColor1,
     fontSize: 28,
   ),
    titleLarge: GoogleFonts.montserrat(
      color: gTextColor1,
      fontSize: 24,
    ),

    titleMedium: GoogleFonts.montserrat(
    color: gTextColor1,
    fontSize: 20,
  ),
    titleSmall: GoogleFonts.montserrat(
      color: gTextColor1,
      fontSize: 16,
    ),

  );


  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      color: gTextColor2,
      fontSize: 36,
      fontWeight: FontWeight.bold,

    ),
    headlineMedium: GoogleFonts.montserrat(
      color: gTextColor2,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.montserrat(
      color: gTextColor2,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.montserrat(
      color: gTextColor2,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: GoogleFonts.montserrat(
      color: gTextColor2,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
  );

}
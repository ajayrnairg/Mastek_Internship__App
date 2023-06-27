import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class GTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      color: Colors.black87,
      fontSize: 36,
    ),
   headlineMedium: GoogleFonts.montserrat(
     color: Colors.black87,
     fontSize: 28,
   ),
    titleLarge: GoogleFonts.montserrat(
      color: Colors.black54,
      fontSize: 24,
    ),
    titleSmall: GoogleFonts.montserrat(
      color: Colors.black54,
      fontSize: 20,
    ),

  );


  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      color: Colors.white70,
      fontSize: 36,
      fontWeight: FontWeight.bold,

    ),
    headlineMedium: GoogleFonts.montserrat(
      color: Colors.white70,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.montserrat(
      color: Colors.white60,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.montserrat(
      color: Colors.white60,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
  );

}
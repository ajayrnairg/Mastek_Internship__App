import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class GTextTheme {
  static TextTheme lightTextTheme = TextTheme(
   headlineMedium: GoogleFonts.montserrat(
     color: Colors.black87,
     fontSize: 28,

   ),
    titleSmall: GoogleFonts.poppins(
      color: Colors.black54,
      fontSize: 16,
    ),
  );


  static TextTheme darkTextTheme = TextTheme(
    headlineMedium: GoogleFonts.montserrat(
      color: Colors.white70,
      fontSize: 28,
      fontWeight: FontWeight.bold,

    ),
    titleSmall: GoogleFonts.poppins(
      color: Colors.white60,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
  );

}
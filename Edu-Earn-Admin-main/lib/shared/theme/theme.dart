import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ColorScheme lightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color(0xFF6A3993),
  onBackground: const Color(0xFFF8F5FA),
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  splashColor: const Color(0xFFE6C8FF),
  focusColor: lightColorScheme.primary,
  textTheme: GoogleFonts.montserratTextTheme(),
  primaryTextTheme: GoogleFonts.montserratTextTheme(),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
      foregroundColor: Colors.white,
      backgroundColor: lightColorScheme.primary,
      padding: const EdgeInsets.all(13),
      elevation: 0,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      alignment: Alignment.center,
      enableFeedback: true,
    ),
  ),
);

ColorScheme darkColorScheme = ColorScheme.fromSwatch(
  primarySwatch: Colors.deepPurple,
  accentColor: Colors.deepPurpleAccent,
  brightness: Brightness.dark,
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey[900],
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  splashColor: Colors.deepPurpleAccent,
  focusColor: Colors.deepPurple,
  textTheme: GoogleFonts.montserratTextTheme().apply(bodyColor: Colors.white),
  primaryTextTheme: GoogleFonts.montserratTextTheme().apply(bodyColor: Colors.white),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
      foregroundColor: Colors.white,
      backgroundColor: Colors.deepPurple,
      padding: const EdgeInsets.all(13),
      elevation: 0,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      alignment: Alignment.center,
      enableFeedback: true,
    ),
  ),
);
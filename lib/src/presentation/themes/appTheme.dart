import 'package:flutter/material.dart';

class AppTheme {
  static const Color dark = Color(0xFF1F2544);
  static const Color light = Color(0xFF81689D);
  static const Color accent = Color(0xFF474F7A);
  static const Color disabledBackgroundColor = Color(0xFF121212);

  static const Color danger = Color(0xFF7A2C5E);
  static const Color success = Color(0xFF283A49);

  static const Color disabledBackground = Color(0xFF434343);
  static const Color disabledText = Color(0xFF686868);

  static const Color cursorColor = Color(0xFF686868);

  static ThemeData _baseTheme(Brightness brightness) => ThemeData(
        appBarTheme: AppBarTheme(
          // backgroundColor: Color.fromRGBO(78, 78, 78, 1),
          backgroundColor: accent,
        ),
        scaffoldBackgroundColor: accent,
        primaryColor: accent,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: dark,
          brightness: brightness,
        ).copyWith(
          primary: accent,
          secondary: dark,
        ),
        brightness: brightness,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
            // fillColor: AppTheme.light,
            // filled: false,
            // border: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.transparent),
            //   borderRadius: BorderRadius.circular(12.0),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.transparent),
            //   borderRadius: BorderRadius.circular(12.0),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.transparent),
            //   borderRadius: BorderRadius.circular(12.0),
            // ),
            // hintStyle: TextStyle(
            //   color: Colors.grey[500],
            // ),
            ),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: dark,
          cursorColor: cursorColor,
        ),
      );

  static ThemeData lightTheme() => _baseTheme(Brightness.light);
  static ThemeData darkTheme() => _baseTheme(Brightness.dark);
}

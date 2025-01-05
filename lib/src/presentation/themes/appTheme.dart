import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData _baseTheme(Brightness brightness) => ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(78, 78, 78, 1),
        ),
        brightness: brightness,
        useMaterial3: true,
      );

  static ThemeData lightTheme() => _baseTheme(Brightness.light);
  static ThemeData darkTheme() => _baseTheme(Brightness.dark);
}

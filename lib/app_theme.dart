import 'package:flutter/material.dart';

class AppTheme {
  static const Color coral = Color(0xFFFD6F6F);
  static const Color background = Color(0xFFFDFDFD);

  static ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: coral,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(coral),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
      ),
    );
  }
}

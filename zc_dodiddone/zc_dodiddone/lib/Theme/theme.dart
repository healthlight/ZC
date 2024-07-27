import 'package:flutter/material.dart';

class DoDidDoneTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9f7bf6), // Primary color
      brightness: Brightness.light,
      primary: const Color(0xFF9F7BF6),  // Primary color
      secondary: const Color(0xFF4ceb8b), // Secondary color
    ),
    useMaterial3: true,
    // Customize the ElevatedButton style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          const Color(0xFF4ceb8b), // Цвет фона кнопок
        ),
      )
    ),
    // Customize the BottomNavigationBar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xFF9F7BF6), // Primary color for selected icons
      unselectedItemColor: Colors.grey, // Grey color for unselected icons
      backgroundColor: Colors.transparent, // Прозрачный BottomNavigationBar
    ),
  );
}

// lib/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Light Theme Definition
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFDFDFD), // Very light background
      cardColor: const Color(0xFFFFF6F6), // Subtle light peach for cards
      canvasColor: Colors.white, // For surfaces like sidebar
      primaryColor: const Color(0xFFFFB6C1), // Light pink
      hintColor: const Color(0xFFD3D3D3), // Light grey for subtle hints/placeholders
      dividerColor: const Color(0xFFF0F0F0), // Very light divider
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          displayLarge: TextStyle(color: Colors.grey[800]),
          displayMedium: TextStyle(color: Colors.grey[800]),
          displaySmall: TextStyle(color: Colors.grey[800]),
          headlineLarge: TextStyle(color: Colors.grey[800]),
          headlineMedium: TextStyle(color: Colors.grey[800]),
          headlineSmall: TextStyle(color: Colors.grey[800]),
          titleLarge: TextStyle(color: Colors.grey[800]),
          titleMedium: TextStyle(color: Colors.grey[800]),
          titleSmall: TextStyle(color: Colors.grey[800]),
          bodyLarge: TextStyle(color: Colors.grey[700]),
          bodyMedium: TextStyle(color: Colors.grey[700]),
          bodySmall: TextStyle(color: Colors.grey[700]),
          labelLarge: TextStyle(color: Colors.grey[700]),
          labelMedium: TextStyle(color: Colors.grey[700]),
          labelSmall: TextStyle(color: Colors.grey[700]),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
        iconTheme: IconThemeData(color: Colors.grey[700]),
      ),
      iconTheme: IconThemeData(color: Colors.grey[700]),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFFB6C1), // Light pink
        secondary: Color(0xFFFFCCCC), // Lighter pink/peach
        background: Color(0xFFFDFDFD),
        surface: Colors.white,
        onPrimary: Colors.black87,
        onSecondary: Colors.black87,
        onBackground: Colors.black87,
        onSurface: Colors.black87,
        error: Colors.red,
        onError: Colors.white,
      ),
      buttonTheme: ButtonThemeData( // Example button theme
        buttonColor: const Color(0xFFFFB6C1),
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Dark Theme Definition
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF3E2723), // Dark coffee brown
      cardColor: const Color(0xFF4E342E), // Slightly lighter coffee brown for cards
      canvasColor: const Color(0xFF3E2723), // For surfaces like sidebar
      primaryColor: const Color(0xFF795548), // Muted brown
      hintColor: const Color(0xFF8D6E63), // Lighter brown for hints
      dividerColor: const Color(0xFF5D4037), // Darker divider
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          displayLarge: TextStyle(color: Colors.grey[200]),
          displayMedium: TextStyle(color: Colors.grey[200]),
          displaySmall: TextStyle(color: Colors.grey[200]),
          headlineLarge: TextStyle(color: Colors.grey[200]),
          headlineMedium: TextStyle(color: Colors.grey[200]),
          headlineSmall: TextStyle(color: Colors.grey[200]),
          titleLarge: TextStyle(color: Colors.grey[200]),
          titleMedium: TextStyle(color: Colors.grey[200]),
          titleSmall: TextStyle(color: Colors.grey[200]),
          bodyLarge: TextStyle(color: Colors.grey[300]),
          bodyMedium: TextStyle(color: Colors.grey[300]),
          bodySmall: TextStyle(color: Colors.grey[300]),
          labelLarge: TextStyle(color: Colors.grey[300]),
          labelMedium: TextStyle(color: Colors.grey[300]),
          labelSmall: TextStyle(color: Colors.grey[300]),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey[200],
        ),
        iconTheme: IconThemeData(color: Colors.grey[300]),
      ),
      iconTheme: IconThemeData(color: Colors.grey[300]),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF795548), // Muted brown
        secondary: Color(0xFF5D4037), // Darker brown
        background: Color(0xFF3E2723),
        surface: Color(0xFF4E342E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white70,
        onSurface: Colors.white70,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
      buttonTheme: ButtonThemeData( // Example button theme
        buttonColor: const Color(0xFF795548),
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
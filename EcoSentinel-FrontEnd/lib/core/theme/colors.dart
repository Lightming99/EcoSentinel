import 'package:flutter/material.dart';

class UNColors {
  // Primary Colors
  static const Color unBlue = Color(0xFF009EDB); // UN Official Blue
  static const Color unLightBlue = Color(0xFF4FC3F7); // Secondary Blue
  static const Color unWhite = Color(0xFFFFFFFF); // Pure White

  // Status Colors
  static const Color unGreen = Color(0xFF4CAF50); // Success/Good
  static const Color unOrange = Color(0xFFFF9800); // Warning/Moderate
  static const Color unRed = Color(0xFFF44336); // Error/Critical

  // Neutral Colors
  static const Color unDarkGray = Color(0xFF424242); // Headers
  static const Color unGray = Color(0xFF757575); // Body text
  static const Color unLightGray = Color(0xFFE0E0E0); // Borders
  static const Color unBackground = Color(0xFFF5F5F5); // Background
}
// lib/core/theme/colors.dart

class AppColors {
  // Primary Colors - UN Standards
  static const Color unBlue = Color(0xFF009EDB); // UN Official Blue
  static const Color unLightBlue = Color(0xFF4FC3F7); // Secondary Blue
  static const Color unWhite = Color(0xFFFFFFFF); // Pure White

  // Status Colors
  static const Color unGreen = Color(0xFF4CAF50); // Success/Good
  static const Color unOrange = Color(0xFFFF9800); // Warning/Moderate
  static const Color unRed = Color(0xFFF44336); // Error/Critical

  // Neutral Colors
  static const Color unDarkGray = Color(0xFF424242); // Headers
  static const Color unGray = Color(0xFF757575); // Body text
  static const Color unLightGray = Color(0xFFE0E0E0); // Borders
  static const Color unBackground = Color(0xFFF5F5F5); // Background

  // Additional Colors
  static const Color unSuccess = unGreen;
  static const Color unWarning = unOrange;
  static const Color unError = unRed;
  static const Color unInfo = unBlue;

  // Gradient Colors
  static const LinearGradient unBlueGradient = LinearGradient(
    colors: [unBlue, unLightBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient unBackgroundGradient = LinearGradient(
    colors: [unWhite, unBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

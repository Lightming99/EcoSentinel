// lib/core/theme/text_styles.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  // Headers
  static TextStyle heading1 = GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.unDarkGray,
  );

  static TextStyle heading2 = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.unDarkGray,
  );

  static TextStyle heading3 = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.unDarkGray,
  );

  static TextStyle heading4 = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.unDarkGray,
  );

  // Body Text
  static TextStyle bodyLarge = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.unDarkGray,
  );

  static TextStyle bodyMedium = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.unDarkGray,
  );

  static TextStyle bodySmall = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.unGray,
  );

  // Special Text Styles
  static TextStyle caption = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.unGray,
  );

  static TextStyle button = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.unWhite,
  );

  static TextStyle subtitle = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.unGray,
  );

  static TextStyle overline = GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.unGray,
    letterSpacing: 1.5,
  );

  // Link Text
  static TextStyle link = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.unBlue,
    decoration: TextDecoration.underline,
  );

  // Error Text
  static TextStyle error = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.unRed,
  );

  // Success Text
  static TextStyle success = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.unGreen,
  );

  // Warning Text
  static TextStyle warning = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.unOrange,
  );
}

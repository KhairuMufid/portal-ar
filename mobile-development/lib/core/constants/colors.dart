import 'package:flutter/material.dart';

class AppColors {
  // Primary color - Orange cerah
  static const Color primary = Color(0xFFF57C13);
  static const Color primaryLight = Color(0xFFFFAD52);
  static const Color primaryDark = Color(0xFFD05600);

  // Secondary colors - Biru langit dan hijau daun
  static const Color skyBlue = Color(0xFF87CEEB);
  static const Color leafGreen = Color(0xFF90EE90);
  static const Color softPink = Color(0xFFFFB6C1);
  static const Color lightYellow = Color(0xFFFFFACD);

  // Background colors for neumorphism
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFFE0E0E0);

  // Shadow colors for neumorphism effect
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color shadowDark = Color(0xFFBDBDBD);

  // Text colors
  static const Color textPrimary = Color(0xFF2E2E2E);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53E3E);

  // Gradient combinations
  static const List<Color> primaryGradient = [
    Color(0xFFF57C13),
    Color(0xFFFFAD52),
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFFF5F5F5),
    Color(0xFFE8F4FD),
  ];

  static const List<Color> cardGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF0F8FF),
  ];
}

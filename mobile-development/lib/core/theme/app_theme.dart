import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.skyBlue,
        surface: AppColors.backgroundLight,
        onPrimary: AppColors.textLight,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),

      // Set Nunito font family with Google Fonts
      textTheme: GoogleFonts.nunitoTextTheme(),

      // AppBar theme - Nunito font implementation
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 26, // Increased from 24
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.primary, size: 28),
      ),

      // Bottom Navigation Bar theme - Nunito font implementation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.buttonBorderRadius,
            ),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        color: AppColors.backgroundLight,
      ),

      // Switch theme for settings
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.3);
          }
          return AppColors.textSecondary.withOpacity(0.3);
        }),
      ),
    );
  }

  // Helper method for enhanced neumorphism box decoration

  static BoxDecoration neumorphismDecoration({
    Color? color,
    double? borderRadius,
    bool isPressed = false,
    double? intensity, // New parameter for shadow intensity
  }) {
    final bgColor = color ?? AppColors.backgroundLight;
    final radius = borderRadius ?? AppConstants.cardBorderRadius;
    final shadowIntensity = intensity ?? 1.0;

    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow:
          isPressed
              ? [
                // Pressed state - deeper inset effect
                BoxShadow(
                  color: AppColors.shadowDark.withOpacity(
                    0.4 * shadowIntensity,
                  ),
                  offset: Offset(3 * shadowIntensity, 3 * shadowIntensity),
                  blurRadius: 6 * shadowIntensity,
                  spreadRadius: -1,
                ),
                BoxShadow(
                  color: AppColors.shadowLight.withOpacity(0.6),
                  offset: Offset(-2 * shadowIntensity, -2 * shadowIntensity),
                  blurRadius: 4 * shadowIntensity,
                  spreadRadius: -1,
                ),
              ]
              : [
                // Normal state - enhanced elevated shadows with more depth
                BoxShadow(
                  color: AppColors.shadowDark.withOpacity(
                    0.25 * shadowIntensity,
                  ),
                  offset: Offset(
                    AppConstants.neumorphismOffset * shadowIntensity,
                    AppConstants.neumorphismOffset * shadowIntensity,
                  ),
                  blurRadius:
                      AppConstants.neumorphismBlurRadius * shadowIntensity,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: AppColors.shadowLight.withOpacity(0.9),
                  offset: Offset(
                    -AppConstants.neumorphismOffset * shadowIntensity,
                    -AppConstants.neumorphismOffset * shadowIntensity,
                  ),
                  blurRadius:
                      AppConstants.neumorphismBlurRadius * shadowIntensity,
                  spreadRadius: 1,
                ),
                // Additional subtle inner highlight
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  offset: const Offset(0, 0),
                  blurRadius: 1,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.inner,
                ),
              ],
    );
  }

  // Helper method for gradient decoration
  static BoxDecoration gradientDecoration({
    List<Color>? colors,
    double? borderRadius,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppConstants.cardBorderRadius,
      ),
      gradient: LinearGradient(
        colors: colors ?? AppColors.primaryGradient,
        begin: begin ?? Alignment.topLeft,
        end: end ?? Alignment.bottomRight,
      ),
    );
  }
}

// Extension for adding neumorphism shadows to any widget
extension NeumorphismExtension on Widget {
  Widget neumorphism({
    Color? color,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool isPressed = false,
  }) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: AppTheme.neumorphismDecoration(
        color: color,
        borderRadius: borderRadius,
        isPressed: isPressed,
      ),
      child: this,
    );
  }
}

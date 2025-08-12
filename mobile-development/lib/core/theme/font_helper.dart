import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontHelper {
  static const String fontFamily = 'Nunito';

  // Main text styles with Nunito font from Google Fonts (increased sizes)
  static TextStyle get heading1 =>
      GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.bold); // 32->36

  static TextStyle get heading2 =>
      GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.bold); // 28->32

  static TextStyle get heading3 =>
      GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w600); // 24->28

  static TextStyle get heading4 =>
      GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w600); // 20->24

  static TextStyle get bodyLarge =>
      GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.normal); // 18->20

  static TextStyle get bodyMedium =>
      GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.normal); // 16->18

  static TextStyle get bodySmall =>
      GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal); // 14->16

  static TextStyle get caption =>
      GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.normal); // 12->14

  static TextStyle get button =>
      GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600); // 16->18

  // Custom text style with Nunito font from Google Fonts
  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.nunito(
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Helper method to ensure Nunito font is used
  static TextStyle ensureNunito(TextStyle? style) {
    if (style == null) {
      return GoogleFonts.nunito();
    }
    return GoogleFonts.nunito(
      fontSize: style.fontSize,
      fontWeight: style.fontWeight,
      color: style.color,
      letterSpacing: style.letterSpacing,
      height: style.height,
    );
  }

  // Preload font method untuk dipanggil di main.dart
  static Future<void> preloadFont() async {
    try {
      await GoogleFonts.pendingFonts([
        GoogleFonts.nunito(),
        GoogleFonts.nunito(fontWeight: FontWeight.bold),
        GoogleFonts.nunito(fontWeight: FontWeight.w600),
      ]);
      print('✅ Google Fonts Nunito loaded successfully');
      print('🔤 Nunito font family should now be available');
    } catch (e) {
      print('❌ Error loading Nunito font: $e');
    }
  }
}

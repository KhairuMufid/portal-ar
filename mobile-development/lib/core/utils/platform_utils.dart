import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformUtils {
  // Detect if running on emulator
  static bool get isEmulator {
    if (kDebugMode) {
      // Check for common emulator indicators
      return Platform.isAndroid && 
             (Platform.version.contains('sdk_gphone') || 
              Platform.version.contains('google_sdk') ||
              Platform.version.contains('emulator') ||
              Platform.version.contains('x86'));
    }
    return false;
  }
  
  // Check if we should use safe mode (reduced visual effects)
  static bool get shouldUseSafeMode {
    return isEmulator || kDebugMode;
  }
  
  // Get safe animation duration
  static Duration get safeAnimationDuration {
    return shouldUseSafeMode 
        ? const Duration(milliseconds: 150) 
        : const Duration(milliseconds: 300);
  }
  
  // Check if complex shadows should be enabled
  static bool get enableComplexShadows {
    return !shouldUseSafeMode;
  }
  
  // Check if multiple gradients should be enabled
  static bool get enableComplexGradients {
    return !shouldUseSafeMode;
  }
}

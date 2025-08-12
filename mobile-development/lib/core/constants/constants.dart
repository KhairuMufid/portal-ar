class AppConstants {
  // App Info
  static const String appName = 'Kooka';
  static const String appVersion = '1.0.0';

  // Navigation
  static const String homeRoute = '/home';
  static const String collectionRoute = '/collection';
  static const String settingsRoute = '/settings';
  static const String arViewerRoute = '/ar-viewer';

  // Bottom Navigation Labels
  static const String homeLabel = 'Beranda';
  static const String collectionLabel = 'Koleksiku';
  static const String settingsLabel = 'Pengaturan';

  // Settings
  static const String musicEnabledKey = 'music_enabled';
  static const String soundEnabledKey = 'sound_enabled';

  // Parent Gate
  static const List<Map<String, dynamic>> parentGateQuestions = [
    {'question': '3 + 5 = ?', 'answer': 8},
    {'question': '7 - 2 = ?', 'answer': 5},
    {'question': '4 + 4 = ?', 'answer': 8},
    {'question': '9 - 3 = ?', 'answer': 6},
    {'question': '2 + 6 = ?', 'answer': 8},
  ];

  // AR Content Status
  static const String statusNotDownloaded = 'not_downloaded';
  static const String statusDownloading = 'downloading';
  static const String statusReady = 'ready';

  // AR Content Categories
  static const String categoryAll = 'Semua';
  static const String categoryAnimals = 'Hewan';
  static const String categoryReligion = 'Keagamaan';
  static const String categoryNature = 'Alam';
  static const String categoryScience = 'Sains';
  static const String categoryHistory = 'Sejarah';
  static const String categoryGeneral = 'Umum';

  static const List<String> categories = [
    categoryAll,
    categoryAnimals,
    categoryReligion,
    categoryNature,
    categoryScience,
    categoryHistory,
    categoryGeneral,
  ];

  // UI Constants
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 24.0;
  static const double neumorphismOffset = 6.0;
  static const double neumorphismBlurRadius = 12.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);
}

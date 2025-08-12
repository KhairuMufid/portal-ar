import 'package:flutter/foundation.dart';
import '../models/ar_content.dart';
import '../../core/constants/constants.dart';

class ARContentProvider extends ChangeNotifier {
  List<ARContent> _allContent = [];
  List<ARContent> _downloadedContent = [];
  Map<String, double> _downloadProgress = {};
  String _selectedCategory = AppConstants.categoryAll; // Filter kategori

  List<ARContent> get allContent => _allContent;
  List<ARContent> get downloadedContent => _downloadedContent;
  Map<String, double> get downloadProgress => _downloadProgress;
  String get selectedCategory => _selectedCategory;

  // Getter untuk content yang difilter berdasarkan kategori
  List<ARContent> get filteredContent {
    if (_selectedCategory == AppConstants.categoryAll) {
      return _allContent;
    }
    return _allContent
        .where((content) => content.category == _selectedCategory)
        .toList();
  }

  // Getter untuk content unggulan (untuk grid 1 kolom)
  List<ARContent> get featuredContent {
    // Ambil content dengan play count tertinggi atau yang terbaru
    final featured =
        _allContent
            .where(
              (content) =>
                  content.playCount > 0 ||
                  content.status == AppConstants.statusReady,
            )
            .toList();

    featured.sort((a, b) => b.playCount.compareTo(a.playCount));
    return featured.take(3).toList(); // Maksimal 3 item unggulan
  }

  ARContentProvider() {
    _loadDummyData();
  }

  void _loadDummyData() {
    _allContent = [
      ARContent(
        id: '1',
        title: 'Petualangan Hutan Ajaib',
        description:
            'Jelajahi hutan yang penuh dengan makhluk-makhluk lucu dan ramah!',
        thumbnailUrl: 'assets/images/forest_adventure.jpg',
        downloadUrl: 'https://example.com/forest.zip',
        sizeMB: 125.5,
        status: AppConstants.statusReady,
        ageGroup: '4-8 tahun',
        tags: ['petualangan', 'hutan', 'hewan'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        playCount: 12,
        category: AppConstants.categoryNature,
      ),
      ARContent(
        id: '2',
        title: 'Kastil Raja Dinosaurus',
        description: 'Bertemu dengan dinosaurus jinak di kastil yang megah!',
        thumbnailUrl: 'assets/images/dino_castle.jpg',
        downloadUrl: 'https://example.com/dino.zip',
        sizeMB: 89.2,
        status: AppConstants.statusNotDownloaded,
        ageGroup: '5-10 tahun',
        tags: ['dinosaurus', 'kastil', 'sejarah'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        category: AppConstants.categoryHistory,
      ),
      ARContent(
        id: '3',
        title: 'Planet Permen',
        description: 'Terbang ke planet yang terbuat dari permen dan cokelat!',
        thumbnailUrl: 'assets/images/candy_planet.jpg',
        downloadUrl: 'https://example.com/candy.zip',
        sizeMB: 67.8,
        status: AppConstants.statusReady,
        ageGroup: '3-7 tahun',
        tags: ['luar angkasa', 'permen', 'manis'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        playCount: 8,
        category: AppConstants.categoryScience,
      ),
      ARContent(
        id: '4',
        title: 'Taman Kupu-kupu',
        description:
            'Bermain dengan kupu-kupu warna-warni di taman yang indah!',
        thumbnailUrl: 'assets/images/butterfly_garden.jpg',
        downloadUrl: 'https://example.com/butterfly.zip',
        sizeMB: 45.3,
        status: AppConstants.statusNotDownloaded,
        ageGroup: '4-8 tahun',
        tags: ['kupu-kupu', 'taman', 'alam'],
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        category: AppConstants.categoryAnimals,
      ),
      ARContent(
        id: '5',
        title: 'Kapal Bajak Laut',
        description: 'Ahoy! Berlayar bersama bajak laut yang baik hati!',
        thumbnailUrl: 'assets/images/pirate_ship.jpg',
        downloadUrl: 'https://example.com/pirate.zip',
        sizeMB: 156.7,
        status: AppConstants.statusDownloading,
        ageGroup: '6-12 tahun',
        tags: ['bajak laut', 'petualangan', 'laut'],
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        category: AppConstants.categoryHistory,
      ),
      ARContent(
        id: '6',
        title: 'Laboratorium Sains Mini',
        description: 'Lakukan eksperimen sains yang aman dan menyenangkan!',
        thumbnailUrl: 'assets/images/science_lab.jpg',
        downloadUrl: 'https://example.com/science.zip',
        sizeMB: 98.4,
        status: AppConstants.statusReady,
        ageGroup: '7-12 tahun',
        tags: ['sains', 'eksperimen', 'belajar'],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        playCount: 5,
        category: AppConstants.categoryScience,
      ),
      ARContent(
        id: '7',
        title: 'Kisah Nabi dan Rasul',
        description: 'Belajar kisah-kisah inspiratif para nabi dan rasul!',
        thumbnailUrl: 'assets/images/prophets_story.jpg',
        downloadUrl: 'https://example.com/prophets.zip',
        sizeMB: 78.6,
        status: AppConstants.statusNotDownloaded,
        ageGroup: '5-12 tahun',
        tags: ['islam', 'nabi', 'agama'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        category: AppConstants.categoryReligion,
      ),
      ARContent(
        id: '8',
        title: 'Satwa Liar Indonesia',
        description: 'Mengenal satwa endemik Indonesia yang mengagumkan!',
        thumbnailUrl: 'assets/images/wildlife_indonesia.jpg',
        downloadUrl: 'https://example.com/wildlife.zip',
        sizeMB: 112.3,
        status: AppConstants.statusReady,
        ageGroup: '6-12 tahun',
        tags: ['hewan', 'indonesia', 'konservasi'],
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        playCount: 3,
        category: AppConstants.categoryAnimals,
      ),
    ];

    // Set initial download progress for downloading content
    _downloadProgress['5'] = 0.65; // Kapal Bajak Laut 65% downloaded

    _updateDownloadedContent();
    notifyListeners();
  }

  void _updateDownloadedContent() {
    _downloadedContent =
        _allContent
            .where((content) => content.status == AppConstants.statusReady)
            .toList();
  }

  Future<void> downloadContent(String contentId) async {
    final index = _allContent.indexWhere((content) => content.id == contentId);
    if (index == -1) return;

    // Update status to downloading
    _allContent[index] = _allContent[index].copyWith(
      status: AppConstants.statusDownloading,
      downloadProgress: 0.0,
    );
    _downloadProgress[contentId] = 0.0;
    notifyListeners();

    // Simulate download progress
    for (double progress = 0.0; progress <= 1.0; progress += 0.1) {
      await Future.delayed(const Duration(milliseconds: 500));
      _downloadProgress[contentId] = progress;
      _allContent[index] = _allContent[index].copyWith(
        downloadProgress: progress,
      );
      notifyListeners();
    }

    // Mark as ready
    _allContent[index] = _allContent[index].copyWith(
      status: AppConstants.statusReady,
      downloadProgress: 1.0,
    );
    _downloadProgress.remove(contentId);
    _updateDownloadedContent();
    notifyListeners();
  }

  Future<void> deleteContent(String contentId) async {
    final index = _allContent.indexWhere((content) => content.id == contentId);
    if (index == -1) return;

    _allContent[index] = _allContent[index].copyWith(
      status: AppConstants.statusNotDownloaded,
      downloadProgress: 0.0,
    );
    _downloadProgress.remove(contentId);
    _updateDownloadedContent();
    notifyListeners();
  }

  Future<void> toggleFavorite(String contentId) async {
    final index = _allContent.indexWhere((content) => content.id == contentId);
    if (index == -1) return;

    _allContent[index] = _allContent[index].copyWith(
      isFavorite: !_allContent[index].isFavorite,
    );
    _updateDownloadedContent();
    notifyListeners();
  }

  Future<void> incrementPlayCount(String contentId) async {
    final index = _allContent.indexWhere((content) => content.id == contentId);
    if (index == -1) return;

    _allContent[index] = _allContent[index].copyWith(
      playCount: _allContent[index].playCount + 1,
    );
    _updateDownloadedContent();
    notifyListeners();
  }

  ARContent? getContentById(String id) {
    try {
      return _allContent.firstWhere((content) => content.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ARContent> getContentByTag(String tag) {
    return _allContent
        .where((content) => content.tags.contains(tag.toLowerCase()))
        .toList();
  }

  List<ARContent> getFavoriteContent() {
    return _downloadedContent.where((content) => content.isFavorite).toList();
  }

  List<ARContent> getContentByAgeGroup(String ageGroup) {
    return _allContent
        .where((content) => content.ageGroup == ageGroup)
        .toList();
  }

  List<ARContent> getRecentlyPlayedContent() {
    // Get content that has been played at least once, sorted by play count
    final playedContent =
        _allContent.where((content) => content.playCount > 0).toList();

    // Sort by play count in descending order
    playedContent.sort((a, b) => b.playCount.compareTo(a.playCount));

    // Return max 5 items
    return playedContent.take(5).toList();
  }

  // Method untuk mengubah kategori yang dipilih
  void setSelectedCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  // Method untuk mendapatkan content berdasarkan kategori
  List<ARContent> getContentByCategory(String category) {
    if (category == AppConstants.categoryAll) {
      return _allContent;
    }
    return _allContent
        .where((content) => content.category == category)
        .toList();
  }

  // Method untuk mendapatkan semua kategori yang tersedia
  List<String> getAvailableCategories() {
    final categories = <String>{AppConstants.categoryAll};
    categories.addAll(_allContent.map((content) => content.category));
    return categories.toList();
  }
}

import '../../core/constants/constants.dart';

class ARContent {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String downloadUrl;
  final double sizeMB;
  final String status;
  final double downloadProgress;
  final List<String> tags;
  final DateTime createdAt;
  final bool isFavorite;
  final String ageGroup;
  final int playCount;
  final String category; // Field kategori baru

  ARContent({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.downloadUrl,
    required this.sizeMB,
    this.status = AppConstants.statusNotDownloaded,
    this.downloadProgress = 0.0,
    this.tags = const [],
    required this.createdAt,
    this.isFavorite = false,
    required this.ageGroup,
    this.playCount = 0,
    required this.category, // Kategori wajib diisi
  });

  ARContent copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? downloadUrl,
    double? sizeMB,
    String? status,
    double? downloadProgress,
    List<String>? tags,
    DateTime? createdAt,
    bool? isFavorite,
    String? ageGroup,
    int? playCount,
    String? category,
  }) {
    return ARContent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      sizeMB: sizeMB ?? this.sizeMB,
      status: status ?? this.status,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      ageGroup: ageGroup ?? this.ageGroup,
      playCount: playCount ?? this.playCount,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'downloadUrl': downloadUrl,
      'sizeMB': sizeMB,
      'status': status,
      'downloadProgress': downloadProgress,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
      'ageGroup': ageGroup,
      'playCount': playCount,
      'category': category,
    };
  }

  factory ARContent.fromJson(Map<String, dynamic> json) {
    return ARContent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      downloadUrl: json['downloadUrl'] as String,
      sizeMB: (json['sizeMB'] as num).toDouble(),
      status: json['status'] as String? ?? AppConstants.statusNotDownloaded,
      downloadProgress: (json['downloadProgress'] as num?)?.toDouble() ?? 0.0,
      tags: List<String>.from(json['tags'] as List? ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      ageGroup: json['ageGroup'] as String,
      playCount: json['playCount'] as int? ?? 0,
      category:
          json['category'] as String? ??
          'Umum', // Default kategori jika tidak ada
    );
  }

  // Helper getters
  bool get isDownloaded => status == AppConstants.statusReady;
  bool get isDownloading => status == AppConstants.statusDownloading;
  bool get canPlay => status == AppConstants.statusReady;

  String get formattedSize {
    if (sizeMB < 1000) {
      return '${sizeMB.toStringAsFixed(1)} MB';
    } else {
      return '${(sizeMB / 1000).toStringAsFixed(1)} GB';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ARContent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ARContent(id: $id, title: $title, status: $status)';
  }
}

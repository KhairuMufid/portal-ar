import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/models/ar_content.dart';
import '../../shared/providers/ar_content_provider.dart';
import '../../shared/widgets/neumorphic_button.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/constants.dart';

class ARContentCard extends StatelessWidget {
  final ARContent content;
  final VoidCallback? onTap;
  final bool showDownloadButton;

  const ARContentCard({
    super.key,
    required this.content,
    this.onTap,
    this.showDownloadButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ARContentProvider>(
      builder: (context, provider, child) {
        final progress = provider.downloadProgress[content.id] ?? 0.0;

        // Menggunakan NeumorphicButton dengan DNA "Aksi Cepat" yang sama persis
        // seperti tombol "Koleksi" dan "Favorit" di home page
        return NeumorphicButton(
          onPressed: content.canPlay ? onTap : null,
          margin: const EdgeInsets.all(8),
          padding: EdgeInsets.zero,
          borderRadius: AppConstants.cardBorderRadius,
          // Menggunakan warna transparan yang sama seperti menu "Aksi Cepat"
          color: AppColors.backgroundLight.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thumbnail section dengan DNA visual "Aksi Cepat"
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.cardBorderRadius),
                      topRight: Radius.circular(AppConstants.cardBorderRadius),
                    ),
                    // Background seperti menu "Aksi Cepat"
                    color: AppColors.backgroundLight.withOpacity(0.05),
                  ),
                  child: Stack(
                    children: [
                      // Icon utama dengan style yang sama seperti "Aksi Cepat"
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon container dengan efek yang sama seperti tombol "Koleksi" dan "Favorit"
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: _getColorForContent(
                                  content.title,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Icon(
                                _getIconForContent(content.title),
                                size: 32,
                                color: _getColorForContent(content.title),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status indicator dengan DNA 3D yang sama
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _buildEnhanced3DStatusIndicator(
                          context,
                          provider,
                          progress,
                        ),
                      ),

                      // Favorite indicator
                      if (content.isFavorite)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: AppColors.textLight,
                              size: 14,
                            ),
                          ),
                        ),

                      // Age group indicator dengan style menu "Aksi Cepat"
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            content.ageGroup,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content info section dengan style "Aksi Cepat"
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title dengan style yang sama seperti "Koleksi"/"Favorit"
                      Text(
                        content.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getColorForContent(content.title),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Info row dengan design minimalis seperti "Aksi Cepat"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Size indicator dengan style sederhana
                          Text(
                            content.formattedSize,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Separator
                          Container(
                            width: 2,
                            height: 2,
                            decoration: const BoxDecoration(
                              color: AppColors.textSecondary,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Play count
                          Text(
                            '${content.playCount} plays',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Mendapatkan warna yang sesuai untuk setiap konten,
  /// mengikuti pattern warna seperti menu "Aksi Cepat"
  Color _getColorForContent(String title) {
    if (title.contains('Hutan')) return AppColors.leafGreen;
    if (title.contains('Dinosaurus')) return AppColors.primary;
    if (title.contains('Planet')) return AppColors.skyBlue;
    if (title.contains('Kupu-kupu')) return AppColors.softPink;
    if (title.contains('Bajak Laut')) return AppColors.primary;
    if (title.contains('Sains')) return AppColors.skyBlue;
    return AppColors.primary; // Default color
  }

  IconData _getIconForContent(String title) {
    if (title.contains('Hutan')) return Icons.forest;
    if (title.contains('Dinosaurus')) return Icons.pets;
    if (title.contains('Planet')) return Icons.public;
    if (title.contains('Kupu-kupu')) return Icons.flutter_dash;
    if (title.contains('Bajak Laut')) return Icons.directions_boat;
    if (title.contains('Sains')) return Icons.science;
    return Icons.play_circle_filled;
  }

  /// Status indicator dengan DNA visual "Aksi Cepat" yang ditingkatkan
  Widget _buildEnhanced3DStatusIndicator(
    BuildContext context,
    ARContentProvider provider,
    double progress,
  ) {
    IconData icon;
    Color backgroundColor;
    Color iconColor;
    String tooltip;

    switch (content.status) {
      case AppConstants.statusNotDownloaded:
        icon = Icons.cloud_download_outlined;
        backgroundColor = AppColors.skyBlue;
        iconColor = AppColors.textLight;
        tooltip = 'Belum diunduh';
        break;
      case AppConstants.statusDownloading:
        icon = Icons.downloading;
        backgroundColor = AppColors.primary;
        iconColor = AppColors.textLight;
        tooltip = 'Mengunduh ${(progress * 100).toInt()}%';
        break;
      case AppConstants.statusReady:
        icon = Icons.play_circle_filled;
        backgroundColor = AppColors.success;
        iconColor = AppColors.textLight;
        tooltip = 'Siap dimainkan';
        break;
      default:
        icon = Icons.error_outline;
        backgroundColor = AppColors.error;
        iconColor = AppColors.textLight;
        tooltip = 'Error';
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          // Efek 3D mengikuti DNA "Aksi Cepat"
          boxShadow: [
            // Outer shadow untuk efek ketinggian
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(2, 3),
              blurRadius: 5,
              spreadRadius: 0,
            ),
            // Inner highlight untuk efek cahaya
            BoxShadow(
              color: Colors.white.withOpacity(0.4),
              offset: const Offset(-1, -1),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
          // Border halus
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
        ),
        child: Stack(
          children: [
            // Icon utama
            Center(child: Icon(icon, size: 16, color: iconColor)),

            // Progress indicator untuk status downloading
            if (content.status == AppConstants.statusDownloading)
              Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.8),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

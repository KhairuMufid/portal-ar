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
  final bool
  showDownloadSize; // Parameter baru untuk membedakan home vs collection

  const ARContentCard({
    super.key,
    required this.content,
    this.onTap,
    this.showDownloadButton = true,
    this.showDownloadSize = true, // Default true untuk home page
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ARContentProvider>(
      builder: (context, provider, child) {
        final progress = provider.downloadProgress[content.id] ?? 0.0;

        // Menggunakan NeumorphicButton dengan DNA "Aksi Cepat" yang sama persis
        // seperti tombol "Koleksi" dan "Favorit" di home page
        return NeumorphicButton(
          // Semua cards bisa diklik, tidak tergantung status download
          onPressed: onTap,
          margin: const EdgeInsets.all(8),
          padding: EdgeInsets.zero,
          borderRadius: AppConstants.cardBorderRadius,
          // Menggunakan warna transparan yang sama seperti menu "Aksi Cepat"
          color: AppColors.backgroundLight.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thumbnail section dengan DNA visual "Aksi Cepat" + Enhanced Visual
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.cardBorderRadius),
                      topRight: Radius.circular(AppConstants.cardBorderRadius),
                    ),
                    // Enhanced gradient background yang menarik untuk anak-anak
                    gradient: LinearGradient(
                      colors: [
                        AppColors.backgroundLight.withOpacity(0.15),
                        AppColors.primary.withOpacity(0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    // Subtle border untuk definisi yang lebih baik
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background pattern yang playful
                      Positioned.fill(
                        child: CustomPaint(painter: PlayfulPatternPainter()),
                      ),

                      // Icon utama dengan style yang lebih menarik untuk anak-anak
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Enhanced icon container dengan animasi-ready style
                            Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                // Multi-layer gradient yang eye-catching
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0.3),
                                    AppColors.primary.withOpacity(0.1),
                                    AppColors.primary.withOpacity(0.05),
                                  ],
                                  stops: const [0.3, 0.7, 1.0],
                                ),
                                borderRadius: BorderRadius.circular(37.5),
                                // Enhanced shadow system
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                // Colorful border
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.4),
                                  width: 2.5,
                                ),
                              ),
                              child: Icon(
                                _getIconForContent(content.title),
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Enhanced indicator dots dengan warna yang berbeda
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                final colors = [
                                  AppColors.primary,
                                  AppColors.skyBlue,
                                  AppColors.success,
                                  AppColors.primary.withOpacity(0.7),
                                  AppColors.skyBlue.withOpacity(0.7),
                                ];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  width:
                                      index == 2 ? 6 : 4, // Center dot bigger
                                  height: index == 2 ? 6 : 4,
                                  decoration: BoxDecoration(
                                    color: colors[index],
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors[index].withOpacity(0.3),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ), // Status indicator dengan DNA 3D yang sama
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

                      // Tidak lagi menampilkan age group - dihapus untuk visual yang lebih clean
                    ],
                  ),
                ),
              ),

              // Content info section dengan neumorphic accent yang indah
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // Subtle background gradient untuk depth
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.grey.shade50],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative neumorphic circles di background
                      Positioned(
                        top: -5,
                        right: 8,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white, Colors.grey.shade100],
                            ),
                            boxShadow: [
                              // Inner shadow (concave effect)
                              BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: const Offset(-2, -2),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Small decorative circle kiri
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary.withOpacity(0.1),
                                AppColors.primary.withOpacity(0.05),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.2),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                offset: const Offset(-1, -1),
                                blurRadius: 2,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Neumorphic decorative line
                      Positioned(
                        top: 35,
                        left: 16,
                        right: 16,
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.grey.shade200,
                                Colors.grey.shade300,
                                Colors.grey.shade200,
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                offset: const Offset(0, 1),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Main content
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title dengan neumorphic container
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.9),
                                    Colors.grey.shade50.withOpacity(0.9),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  // Neumorphic shadow
                                  BoxShadow(
                                    color: Colors.grey.shade300.withOpacity(
                                      0.5,
                                    ),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.9),
                                    offset: const Offset(-2, -2),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Text(
                                content.title,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // Spacer dengan decorative dots
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                3,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withOpacity(0.3),
                                        AppColors.primary.withOpacity(0.1),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.2,
                                        ),
                                        offset: const Offset(0.5, 0.5),
                                        blurRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.8),
                                        offset: const Offset(-0.5, -0.5),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Bottom section dengan enhanced neumorphic style
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: double.infinity,
                              ),
                              child: Column(
                                children: [
                                  // Info row untuk home page
                                  if (showDownloadSize) ...[
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 120,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        // Enhanced neumorphic design
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white,
                                            Colors.grey.shade50,
                                            Colors.grey.shade100,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          width: 0.5,
                                        ),
                                        boxShadow: [
                                          // Outer shadow (raised effect)
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: const Offset(3, 3),
                                            blurRadius: 6,
                                            spreadRadius: 0,
                                          ),
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: const Offset(-3, -3),
                                            blurRadius: 6,
                                            spreadRadius: 0,
                                          ),
                                          // Inner glow
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.05),
                                            offset: const Offset(0, 0),
                                            blurRadius: 8,
                                            spreadRadius: -2,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Enhanced download icon dengan neumorphic effect
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  AppColors.primary.withOpacity(
                                                    0.9,
                                                  ),
                                                  AppColors.primary.withOpacity(
                                                    0.7,
                                                  ),
                                                  AppColors.primary.withOpacity(
                                                    0.8,
                                                  ),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withOpacity(0.3),
                                                  offset: const Offset(2, 2),
                                                  blurRadius: 3,
                                                  spreadRadius: 0,
                                                ),
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  offset: const Offset(-1, -1),
                                                  blurRadius: 2,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.download_rounded,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ),

                                          const SizedBox(width: 6),

                                          Flexible(
                                            child: Text(
                                              content.formattedSize,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primary
                                                    .withOpacity(0.8),
                                                letterSpacing: 0.3,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  // Untuk collection page
                                  if (!showDownloadSize) ...[
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 100,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white,
                                            Colors.green.shade50,
                                            Colors.green.shade100.withOpacity(
                                              0.3,
                                            ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.green.withOpacity(0.2),
                                          width: 0.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            offset: const Offset(2, 2),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                          ),
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: const Offset(-2, -2),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.green.withOpacity(0.8),
                                                  Colors.green.withOpacity(0.6),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.green
                                                      .withOpacity(0.3),
                                                  offset: const Offset(1, 1),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.white,
                                              size: 10,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              'Tersimpan',
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green.shade700,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
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

  // Tidak lagi menggunakan sistem warna dinamis untuk icon,
  // semua icon sekarang menggunakan warna orange yang konsisten

  // Icon yang lebih beragam dan menarik untuk anak-anak
  IconData _getIconForContent(String title) {
    // Konten bertema alam
    if (title.contains('Hutan') || title.contains('Forest'))
      return Icons.forest;
    if (title.contains('Bunga') || title.contains('Flower'))
      return Icons.local_florist;
    if (title.contains('Pohon') || title.contains('Tree')) return Icons.park;

    // Konten bertema hewan
    if (title.contains('Dinosaurus') || title.contains('Dino'))
      return Icons.pets;
    if (title.contains('Kupu-kupu') || title.contains('Butterfly'))
      return Icons.flutter_dash;
    if (title.contains('Burung') || title.contains('Bird'))
      return Icons.flutter_dash;
    if (title.contains('Ikan') || title.contains('Fish')) return Icons.waves;

    // Konten bertema luar angkasa
    if (title.contains('Planet') || title.contains('Space'))
      return Icons.public;
    if (title.contains('Bintang') || title.contains('Star')) return Icons.star;
    if (title.contains('Bulan') || title.contains('Moon'))
      return Icons.brightness_3;
    if (title.contains('Roket') || title.contains('Rocket'))
      return Icons.rocket_launch;

    // Konten bertema petualangan
    if (title.contains('Bajak Laut') || title.contains('Pirate'))
      return Icons.directions_boat;
    if (title.contains('Kastil') || title.contains('Castle'))
      return Icons.castle;
    if (title.contains('Peta') || title.contains('Map')) return Icons.map;

    // Konten bertema edukasi
    if (title.contains('Sains') || title.contains('Science'))
      return Icons.science;
    if (title.contains('Matematika') || title.contains('Math'))
      return Icons.calculate;
    if (title.contains('Huruf') || title.contains('ABC')) return Icons.abc;
    if (title.contains('Angka') || title.contains('Number'))
      return Icons.numbers;

    // Konten bertema musik dan seni
    if (title.contains('Musik') || title.contains('Music'))
      return Icons.music_note;
    if (title.contains('Gambar') || title.contains('Art')) return Icons.palette;

    // Konten bertema olahraga
    if (title.contains('Bola') || title.contains('Ball'))
      return Icons.sports_soccer;
    if (title.contains('Renang') || title.contains('Swimming'))
      return Icons.pool;

    // Default icon yang menarik
    return Icons.toys;
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

// Custom painter untuk background pattern yang playful
class PlayfulPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary.withOpacity(0.03)
          ..style = PaintingStyle.fill;

    // Gambar pattern dots kecil yang tersebar
    for (int i = 0; i < 15; i++) {
      final x = (i * 37.5) % size.width;
      final y = (i * 23.7) % size.height;
      canvas.drawCircle(Offset(x, y), 1.5, paint);
    }

    // Tambah beberapa pattern geometris subtle
    final paint2 =
        Paint()
          ..color = AppColors.skyBlue.withOpacity(0.02)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;

    for (int i = 0; i < 3; i++) {
      final center = Offset(
        size.width * (0.2 + i * 0.3),
        size.height * (0.3 + i * 0.2),
      );
      canvas.drawCircle(center, 8 + i * 4, paint2);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

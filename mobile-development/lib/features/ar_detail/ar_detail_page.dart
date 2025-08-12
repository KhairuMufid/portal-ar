import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/models/ar_content.dart';
import '../../shared/providers/ar_content_provider.dart';
import '../../shared/widgets/kooka_3d_button.dart';
import '../../shared/widgets/neumorphic_button.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/theme/app_theme.dart';
import '../ar_viewer/ar_viewer_page.dart';

class ARDetailPage extends StatefulWidget {
  final String contentId;

  const ARDetailPage({super.key, required this.contentId});

  @override
  State<ARDetailPage> createState() => _ARDetailPageState();
}

class _ARDetailPageState extends State<ARDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  late Animation<double> _heroAnimation;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );

    _contentController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );

    _heroAnimation = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutBack,
    );

    _contentAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(_contentAnimation);

    // Start animations
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _contentController.forward();
      }
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ARContentProvider>(
        builder: (context, provider, child) {
          final content = provider.getContentById(widget.contentId);

          if (content == null) {
            return _buildErrorView();
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.backgroundGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header with back button
                  _buildHeader(context),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Hero image/animation section
                          _buildHeroSection(content),

                          // Content details
                          SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _contentAnimation,
                              child: _buildContentDetails(context, content),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          NeumorphicButton(
            onPressed: () => Navigator.pop(context),
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(12),
            borderRadius: 28,
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            'Detail Mainan',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 56), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildHeroSection(ARContent content) {
    return ScaleTransition(
      scale: _heroAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 280,
        decoration: AppTheme.neumorphismDecoration(
          borderRadius: 24,
          intensity: 1.2,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.skyBlue.withOpacity(0.05),
                      AppColors.leafGreen.withOpacity(0.05),
                    ],
                  ),
                ),
              ),

              // Placeholder for AR content preview
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 3),
                      ),
                      child: Icon(
                        _getIconForContent(content.title),
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Preview AR',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Status badge
              Positioned(top: 16, right: 16, child: _buildStatusBadge(content)),

              // Age group badge
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.skyBlue.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    content.ageGroup,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ARContent content) {
    Color badgeColor;
    IconData badgeIcon;
    String badgeText;

    switch (content.status) {
      case AppConstants.statusNotDownloaded:
        badgeColor = AppColors.warning;
        badgeIcon = Icons.cloud_download;
        badgeText = 'Belum Diunduh';
        break;
      case AppConstants.statusDownloading:
        badgeColor = AppColors.primary;
        badgeIcon = Icons.downloading;
        badgeText = 'Mengunduh...';
        break;
      case AppConstants.statusReady:
        badgeColor = AppColors.success;
        badgeIcon = Icons.check_circle;
        badgeText = 'Siap Dimainkan';
        break;
      default:
        badgeColor = AppColors.textSecondary;
        badgeIcon = Icons.help;
        badgeText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, color: AppColors.textLight, size: 16),
          const SizedBox(width: 4),
          Text(
            badgeText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentDetails(BuildContext context, ARContent content) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and favorite button
          Row(
            children: [
              Expanded(
                child: Text(
                  content.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Consumer<ARContentProvider>(
                builder: (context, provider, child) {
                  return NeumorphicButton(
                    onPressed: () => provider.toggleFavorite(content.id),
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(12),
                    borderRadius: 28,
                    child: Icon(
                      content.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          content.isFavorite
                              ? AppColors.error
                              : AppColors.textSecondary,
                      size: 24,
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.neumorphismDecoration(
              borderRadius: 16,
              intensity: 0.8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tentang Mainan Ini',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Info cards
          _buildInfoCards(content),

          const SizedBox(height: 24),

          // Main action button
          _buildMainActionButton(context, content),

          const SizedBox(height: 16),

          // Book purchase section
          _buildBookPurchaseSection(context),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoCards(ARContent content) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.neumorphismDecoration(
              borderRadius: 12,
              intensity: 0.6,
            ),
            child: Column(
              children: [
                Icon(Icons.file_download, color: AppColors.primary, size: 24),
                const SizedBox(height: 8),
                Text(
                  content.formattedSize,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Ukuran',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.neumorphismDecoration(
              borderRadius: 12,
              intensity: 0.6,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.play_circle_filled,
                  color: AppColors.success,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  '${content.playCount}x',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Dimainkan',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.neumorphismDecoration(
              borderRadius: 12,
              intensity: 0.6,
            ),
            child: Column(
              children: [
                Icon(Icons.child_care, color: AppColors.skyBlue, size: 24),
                const SizedBox(height: 8),
                Text(
                  content.ageGroup.split(' ')[0],
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Usia',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainActionButton(BuildContext context, ARContent content) {
    return Consumer<ARContentProvider>(
      builder: (context, provider, child) {
        String buttonText;
        VoidCallback? onPressed;
        IconData buttonIcon;

        switch (content.status) {
          case AppConstants.statusNotDownloaded:
            buttonText = 'Unduh Mainan';
            buttonIcon = Icons.download;
            onPressed = () => provider.downloadContent(content.id);
            break;
          case AppConstants.statusDownloading:
            final progress = provider.downloadProgress[content.id] ?? 0.0;
            buttonText = 'Mengunduh... ${(progress * 100).toInt()}%';
            buttonIcon = Icons.downloading;
            onPressed = null;
            break;
          case AppConstants.statusReady:
            buttonText = 'Mainkan Sekarang!';
            buttonIcon = Icons.play_arrow;
            onPressed = () => _openARViewer(context, content.id);
            break;
          default:
            buttonText = 'Tidak Tersedia';
            buttonIcon = Icons.error;
            onPressed = null;
        }

        // Menentukan style button berdasarkan status
        if (content.status == AppConstants.statusReady) {
          return Kooka3DPrimaryButton(
            text: buttonText,
            icon: buttonIcon,
            onPressed: onPressed,
            width: double.infinity,
            height: 60,
          );
        } else if (content.status == AppConstants.statusNotDownloaded) {
          // Button hijau untuk download
          return Kooka3DButton(
            onPressed: onPressed,
            width: double.infinity,
            height: 60,
            isPrimary: false,
            color: AppColors.success, // Hijau untuk download
            isEnabled: onPressed != null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(buttonIcon, color: AppColors.textLight, size: 20),
                const SizedBox(width: 8),
                Text(
                  buttonText,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        } else {
          // Status downloading atau error - gunakan tombol disabled
          return Kooka3DButton(
            onPressed: null,
            width: double.infinity,
            height: 60,
            isEnabled: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (content.status == AppConstants.statusDownloading) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else ...[
                  Icon(buttonIcon, color: AppColors.textSecondary, size: 24),
                  const SizedBox(width: 12),
                ],
                Text(
                  buttonText,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildBookPurchaseSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.neumorphismDecoration(
        borderRadius: 16,
        intensity: 0.8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_stories,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Belum punya bukunya?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dapatkan keajaibannya di sini!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Kooka3DSecondaryButton(
            text: 'Beli Buku Sekarang',
            icon: Icons.shopping_cart,
            onPressed: () => _showParentGate(context),
            width: double.infinity,
            height: 56,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: AppColors.error),
          const SizedBox(height: 20),
          Text(
            'Konten Tidak Ditemukan',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Kooka3DPrimaryButton(
            text: 'Kembali',
            icon: Icons.arrow_back,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _openARViewer(BuildContext context, String contentId) {
    // Increment play count
    context.read<ARContentProvider>().incrementPlayCount(contentId);

    // Navigate to AR viewer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ARViewerPage(contentId: contentId),
      ),
    );
  }

  void _showParentGate(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.neumorphismDecoration(
              borderRadius: 20,
              intensity: 1.2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.security, size: 60, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'Verifikasi Orang Tua',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Untuk melindungi anak-anak, akses ke toko online memerlukan konfirmasi orang tua.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Batal',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showBuyBooksPage(context);
                        },
                        gradientColors: AppColors.primaryGradient,
                        child: Text(
                          'Lanjutkan',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBuyBooksPage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.neumorphismDecoration(
              borderRadius: 20,
              intensity: 1.2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_stories,
                  size: 60,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Toko Buku AR',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Fitur ini akan tersedia segera!\nTerima kasih atas minatnya.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                NeumorphicButton(
                  onPressed: () => Navigator.pop(context),
                  gradientColors: AppColors.primaryGradient,
                  child: Text(
                    'Tutup',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
}

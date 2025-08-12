import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/ar_content_provider.dart';
import '../../shared/models/ar_content.dart';
import '../../shared/widgets/neumorphic_button.dart';
import '../../core/constants/colors.dart';

class ARViewerPage extends StatefulWidget {
  final String contentId;

  const ARViewerPage({super.key, required this.contentId});

  @override
  State<ARViewerPage> createState() => _ARViewerPageState();
}

class _ARViewerPageState extends State<ARViewerPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);

    // Simulate loading Unity AR view
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
                colors: [
                  Colors.black,
                  Colors.black87,
                  AppColors.primary.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // AR View Container (Unity will be embedded here)
                  if (_isLoading)
                    _buildLoadingView(content)
                  else
                    _buildARView(content),

                  // Back button
                  Positioned(
                    top: 20,
                    left: 20,
                    child: NeumorphicButton(
                      onPressed: () => Navigator.pop(context),
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(12),
                      color: AppColors.backgroundLight.withOpacity(0.9),
                      borderRadius: 28,
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),

                  // Content info (top right)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getIconForContent(content.title),
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            content.title,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Instructions or controls (bottom)
                  if (!_isLoading)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: _buildControlsPanel(content),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingView(ARContent content) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
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
              );
            },
          ),

          const SizedBox(height: 30),

          Text(
            'Mempersiapkan Dunia AR...',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Arahkan kamera ke buku untuk memulai petualangan!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textLight.withOpacity(0.8),
            ),
          ),

          const SizedBox(height: 30),

          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildARView(ARContent content) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            AppColors.primary.withOpacity(0.1),
            Colors.black.withOpacity(0.3),
            Colors.black87,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconForContent(content.title),
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unity AR View',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Placeholder',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text(
              '🎭 Selamat Bermain! 🎭',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Area ini akan diisi dengan tampilan Unity AR yang menampilkan konten 3D interaktif dari buku.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsPanel(ARContent content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instruksi:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Arahkan kamera ke halaman buku\n• Sentuh objek untuk berinteraksi\n• Gerakkan perangkat untuk melihat dari sudut berbeda',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: NeumorphicButton(
                  onPressed: () {
                    // Screenshot functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Screenshot tersimpan!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Foto',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: NeumorphicButton(
                  onPressed: () {
                    // Reset AR view
                    setState(() {
                      _isLoading = true;
                    });
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.refresh,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Reset',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          NeumorphicButton(
            onPressed: () => Navigator.pop(context),
            gradientColors: AppColors.primaryGradient,
            child: Text(
              'Kembali',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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

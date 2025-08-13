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
  late AnimationController _panelController;
  late AnimationController _backButtonController;
  late Animation<double> _heroAnimation;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _panelSlideAnimation;
  late Animation<double> _panelFadeAnimation;
  late Animation<double> _backButtonOpacity;

  PageController _imageController = PageController();
  int _currentImageIndex = 0;
  ScrollController _scrollController = ScrollController();

  bool _showBackButton = true;
  late double _backgroundVisibilityThreshold;

  static const double _horizontalPadding = 24.0;
  static const double _carouselFixedHeight = 300.0;

  // Tambah palet oranye terpusat untuk konsistensi
  static const Color _oPrimary = Color(0xFFFF8A00); // Orange
  static const Color _oSecondary = Color(0xFFFFB74D); // Orange 300
  static const Color _oTertiary = Color(0xFFFFE0B2); // Orange 100
  static const Color _oBgLight = Color(0xFFFFF3E0); // Orange 50

  final List<String> _carouselImages = [
    'assets/images/sample1.jpg',
    'assets/images/sample2.jpg',
    'assets/images/sample3.jpg',
    'assets/images/sample4.jpg',
  ];

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

    _panelController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _panelSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _panelController, curve: Curves.easeOutCubic),
    );

    _panelFadeAnimation = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeOut,
    );

    _backButtonOpacity = CurvedAnimation(
      parent: _backButtonController,
      curve: Curves.easeInOut,
    );

    _scrollController.addListener(_handleScrollForBackgroundVisibility);

    _heroController.forward();
    _backButtonController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _contentController.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _panelController.forward();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backgroundVisibilityThreshold = MediaQuery.of(context).size.height * 0.25;
  }

  void _handleScrollForBackgroundVisibility() {
    final double currentOffset = _scrollController.offset;

    if (currentOffset <= _backgroundVisibilityThreshold && !_showBackButton) {
      setState(() {
        _showBackButton = true;
      });
      _backButtonController.forward();
    } else if (currentOffset > _backgroundVisibilityThreshold &&
        _showBackButton) {
      setState(() {
        _showBackButton = false;
      });
      _backButtonController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScrollForBackgroundVisibility);
    _heroController.dispose();
    _contentController.dispose();
    _panelController.dispose();
    _backButtonController.dispose();
    _imageController.dispose();
    _scrollController.dispose();
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

          return Stack(
            children: [
              _buildBackgroundLayer(context, content),
              _buildScrollableContentLayer(context, content),
              _buildAnimatedBackButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackgroundLayer(BuildContext context, ARContent content) {
    return Positioned.fill(child: _buildFullScreenARPreview(content));
  }

  Widget _buildScrollableContentLayer(BuildContext context, ARContent content) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).size.height * 0.45),
        ),
        SliverToBoxAdapter(child: _buildMainContentPanel(context, content)),
      ],
    );
  }

  Widget _buildAnimatedBackButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      child: FadeTransition(
        opacity: _backButtonOpacity,
        child: ScaleTransition(
          scale: _backButtonOpacity,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenARPreview(ARContent content) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _oPrimary.withOpacity(0.85),
            _oSecondary.withOpacity(0.7),
            _oTertiary.withOpacity(0.55),
            _oBgLight.withOpacity(0.4),
          ],
        ),
      ),
      child: Stack(
        children: [
          _buildFloating3DElements(),
          Center(
            child: ScaleTransition(
              scale: _heroAnimation,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 3,
                  ),
                ),
                child: Icon(
                  _getIconForContent(content.title),
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    _oBgLight.withOpacity(0.6),
                    Colors.white.withOpacity(0.85),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TEMA: Elemen 3D dengan warna yang ceria dan ramah anak
  Widget _buildFloating3DElements() {
    return Stack(
      children: [
        Positioned(
          top: 100,
          left: 40,
          child: ScaleTransition(
            scale: _contentAnimation,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _oSecondary, // oranye terang
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: _oSecondary.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 180,
          right: 60,
          child: FadeTransition(
            opacity: _contentAnimation,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _oTertiary, // oranye lembut
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: _oTertiary.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 280,
          left: 80,
          child: SlideTransition(
            position: _panelSlideAnimation,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: _oSecondary, // oranye terang
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: _oSecondary.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContentPanel(BuildContext context, ARContent content) {
    return SlideTransition(
      position: _panelSlideAnimation,
      child: FadeTransition(
        opacity: _panelFadeAnimation,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 24),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: _buildAppHeaderWithIcon(context, content),
              ),
              const SizedBox(height: 40),
              _buildStableGallerySection(),
              const SizedBox(height: 40),
              _buildAboutSection(context, content),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: _buildActionButton(context, content),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeaderWithIcon(BuildContext context, ARContent content) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_oPrimary, _oSecondary],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _oPrimary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              _getIconForContent(content.title),
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                content.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_oBgLight, _oTertiary],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _oSecondary, width: 1),
                ),
                child: Text(
                  'Edukasi AR',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF8B4513),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // TEMA: Gallery section dengan warna yang ceria
  Widget _buildStableGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Text(
            'Galeri Gambar',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Container(
            width: double.infinity,
            height: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A00), Color(0xFFFFB74D)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: _carouselFixedHeight + 40,
          clipBehavior: Clip.none,
          child: PageView.builder(
            controller: _imageController,
            clipBehavior: Clip.none,
            pageSnapping: true,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: _carouselImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: _horizontalPadding,
                  right: _horizontalPadding,
                  top: 20,
                  bottom: 20,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _oPrimary.withOpacity(0.8),
                        _oSecondary.withOpacity(0.8),
                        _oTertiary.withOpacity(0.6)
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _oPrimary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 80, color: Colors.white),
                          const SizedBox(height: 16),
                          Text(
                            'Gambar ${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _carouselImages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentImageIndex == index ? 14 : 10,
                height: _currentImageIndex == index ? 14 : 10,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _currentImageIndex == index
                      ? const LinearGradient(
                          colors: [Color(0xFFFF8A00), Color(0xFFFFB74D)],
                        )
                      : null,
                  color:
                      _currentImageIndex == index ? null : Colors.grey.shade300,
                  boxShadow: _currentImageIndex == index
                      ? [
                          BoxShadow(
                            color: _oPrimary.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, ARContent content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Text(
            'Tentang Game Ini',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Container(
            width: double.infinity,
            height: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A00), Color(0xFFFFB74D)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Game AR interaktif ini menggunakan teknologi Augmented Reality untuk memberikan pengalaman belajar yang menyenangkan dan mendidik untuk anak-anak.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // TEMA: Button dengan gradient yang menarik
  Widget _buildActionButton(BuildContext context, ARContent content) {
    return Consumer<ARContentProvider>(
      builder: (context, provider, child) {
        String buttonText;
        VoidCallback? onPressed;
        IconData buttonIcon;

        switch (content.status) {
          case AppConstants.statusNotDownloaded:
            buttonText = 'Mainkan Sekarang';
            buttonIcon = Icons.play_arrow;
            onPressed = () {
              _showBookConfirmationPopup(context, content);
            };
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
            onPressed = () {
              _showBookConfirmationPopup(context, content);
            };
            break;
          default:
            buttonText = 'Mainkan Sekarang';
            buttonIcon = Icons.play_arrow;
            onPressed = () {
              _showBookConfirmationPopup(context, content);
            };
        }

        return Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            gradient: onPressed != null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_oPrimary, _oSecondary, _oTertiary],
                  )
                : LinearGradient(
                    colors: [Colors.grey.shade300, Colors.grey.shade400],
                  ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: onPressed != null
                ? [
                    BoxShadow(
                      color: _oPrimary.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (content.status == AppConstants.statusDownloading) ...[
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ] else ...[
                    Icon(buttonIcon, color: Colors.white, size: 28),
                    const SizedBox(width: 16),
                  ],
                  Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBookConfirmationPopup(BuildContext context, ARContent content) {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black54,
          builder: (BuildContext dialogContext) {
            return _BookConfirmationPopup(
              onHaveBook: () {
                Navigator.pop(dialogContext);
                if (mounted) {
                  if (content.status == AppConstants.statusReady) {
                    _openARViewer(context, content.id);
                  } else {
                    context.read<ARContentProvider>().downloadContent(
                          content.id,
                        );
                  }
                }
              },
              onNeedBook: () {
                Navigator.pop(dialogContext);
                if (mounted) {
                  _showMarketplacePopup(context);
                }
              },
            );
          },
        );
      }
    });
  }

  void _showMarketplacePopup(BuildContext context) {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black54,
          builder: (BuildContext dialogContext) {
            return _MarketplacePopup(
              onClose: () => Navigator.pop(dialogContext),
            );
          },
        );
      }
    });
  }

  Widget _buildErrorView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.backgroundGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
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
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A5ACD), Color(0xFF87CEEB)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Kembali',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openARViewer(BuildContext context, String contentId) {
    context.read<ARContentProvider>().incrementPlayCount(contentId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ARViewerPage(contentId: contentId),
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

// POPUP CLASSES - Dengan tema yang konsisten
class _BookConfirmationPopup extends StatelessWidget {
  final VoidCallback onHaveBook;
  final VoidCallback onNeedBook;

  const _BookConfirmationPopup({
    required this.onHaveBook,
    required this.onNeedBook,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF8A00).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8A00), Color(0xFFFFB74D)],
                ),
                shape: BoxShape.circle, // Ubah dari borderRadius ke shape
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Untuk bermain game AR ini, Anda memerlukan buku fisik sebagai marker.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    fontSize: 16,
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Apakah Anda sudah memiliki bukunya?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            Row(
              children: [
                Expanded(
                  child: _ThemedButton(
                    onPressed: onHaveBook,
                    text: 'Ya, Saya Punya',
                    isPrimary: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ThemedButton(
                    onPressed: onNeedBook,
                    text: 'Belum Punya',
                    isPrimary: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketplacePopup extends StatelessWidget {
  final VoidCallback onClose;

  const _MarketplacePopup({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF8A00).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8A00), Color(0xFFFFB74D)],
                ),
                shape: BoxShape.circle, // Ubah dari borderRadius ke shape
              ),
              child: const Icon(
                Icons.shopping_cart_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Dapatkan bukunya melalui marketplace partner kami:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            _ThemedButton(
              onPressed: onClose,
              text: 'Beli di Tokopedia',
              icon: Icons.shopping_bag,
              isPrimary: true,
              fullWidth: true,
            ),
            const SizedBox(height: 18),
            _ThemedButton(
              onPressed: onClose,
              text: 'Beli di Shopee',
              icon: Icons.shopping_cart,
              isPrimary: true,
              fullWidth: true,
            ),
            const SizedBox(height: 18),
            _ThemedButton(
              onPressed: onClose,
              text: 'Tutup',
              isPrimary: false,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

// Themed Button component untuk konsistensi
class _ThemedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final bool isPrimary;
  final bool fullWidth;

  const _ThemedButton({
    required this.onPressed,
    required this.text,
    this.icon,
    required this.isPrimary,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      height: 52,
      decoration: BoxDecoration(
        gradient: isPrimary
            ? const LinearGradient(
                colors: [Color(0xFFFF8A00), Color(0xFFFFB74D)],
              )
            : null,
        color: isPrimary ? null : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(26),
        border: isPrimary
            ? null
            : Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: const Color(0xFFFF8A00).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isPrimary ? Colors.white : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: isPrimary ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

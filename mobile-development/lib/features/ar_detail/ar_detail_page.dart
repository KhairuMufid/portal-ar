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

  // BARU: State untuk visibility tombol back berdasarkan background visibility
  bool _showBackButton = true;

  // KONSTANTA: Threshold untuk menentukan kapan background terlihat
  late double _backgroundVisibilityThreshold;

  // Konstanta untuk konsistensi padding
  static const double _horizontalPadding = 24.0;
  static const double _carouselFixedHeight = 300.0;
  static const double _carouselImageHeight = 260.0;

  // Sample images for carousel
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

    // BARU: Listener untuk background visibility
    _scrollController.addListener(_handleScrollForBackgroundVisibility);

    // Start animations
    _heroController.forward();
    _backButtonController.forward(); // Start dengan tombol visible
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
    // HITUNG: Threshold berdasarkan ukuran layar
    // Background terlihat ketika scroll offset < 40% dari tinggi layar
    _backgroundVisibilityThreshold = MediaQuery.of(context).size.height * 0.25;
  }

  // BARU: Handler untuk mengontrol tombol back berdasarkan visibility background
  void _handleScrollForBackgroundVisibility() {
    final double currentOffset = _scrollController.offset;

    // LOGIKA BARU:
    // - Background TERLIHAT (scroll offset kecil) -> SHOW button
    // - Background TIDAK TERLIHAT (panel mengisi layar) -> HIDE button

    if (currentOffset <= _backgroundVisibilityThreshold && !_showBackButton) {
      // Background AR terlihat -> Show tombol back
      setState(() {
        _showBackButton = true;
      });
      _backButtonController.forward();
      debugPrint(
        'Back button shown - AR background visible (offset: ${currentOffset.toStringAsFixed(1)})',
      );
    } else if (currentOffset > _backgroundVisibilityThreshold &&
        _showBackButton) {
      // Panel konten mengisi layar -> Hide tombol back
      setState(() {
        _showBackButton = false;
      });
      _backButtonController.reverse();
      debugPrint(
        'Back button hidden - content panel covers screen (offset: ${currentOffset.toStringAsFixed(1)})',
      );
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
              // LAPISAN BELAKANG: Latar Belakang AR
              _buildBackgroundLayer(context, content),

              // LAPISAN DEPAN: Panel Konten Putih (SCROLLABLE)
              _buildScrollableContentLayer(context, content),

              // LAPISAN ATAS: Tombol kembali dengan animasi berdasarkan background visibility
              _buildAnimatedBackButton(context),
            ],
          );
        },
      ),
    );
  }

  // LAPISAN BELAKANG: AR Background (tanpa tombol back)
  Widget _buildBackgroundLayer(BuildContext context, ARContent content) {
    return Positioned.fill(child: _buildFullScreenARPreview(content));
  }

  // LAPISAN DEPAN: Scrollable Content Layer
  Widget _buildScrollableContentLayer(BuildContext context, ARContent content) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: [
        // SPACER: Area untuk background AR (45% tinggi layar)
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).size.height * 0.45),
        ),

        // PANEL KONTEN: Mulai dari 45% tinggi layar
        SliverToBoxAdapter(child: _buildMainContentPanel(context, content)),
      ],
    );
  }

  // TOMBOL BACK: Dengan animasi berdasarkan background visibility
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _NeomorphicButton(
                size: 56,
                onPressed: () {
                  debugPrint(
                    'Back button pressed - Background visibility based',
                  );
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black54,
                  size: 24,
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
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            AppColors.primary.withOpacity(0.3),
            AppColors.skyBlue.withOpacity(0.2),
            AppColors.leafGreen.withOpacity(0.1),
            AppColors.primary.withOpacity(0.4),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated 3D elements
          _buildFloating3DElements(),

          // Central AR preview icon
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
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getIconForContent(content.title),
                  size: 100,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),

          // Gradient overlay untuk transisi ke konten
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
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloating3DElements() {
    return Stack(
      children: [
        // Floating element 1
        Positioned(
          top: 120,
          left: 50,
          child: ScaleTransition(
            scale: _contentAnimation,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withOpacity(0.4),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.skyBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Floating element 2
        Positioned(
          top: 250,
          right: 80,
          child: FadeTransition(
            opacity: _contentAnimation,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.leafGreen.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.leafGreen.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Floating element 3
        Positioned(
          bottom: 350,
          left: 100,
          child: SlideTransition(
            position: _panelSlideAnimation,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.softPink.withOpacity(0.3),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softPink.withOpacity(0.2),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
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
              // Handle bar
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

              // A. BARU: Header Aplikasi dengan Ikon + Judul & Kategori
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: _buildAppHeaderWithIcon(context, content),
              ),

              const SizedBox(height: 40),

              // B. STABILITAS: Seksi Galeri dengan Fixed Height & Padding untuk Shadow
              _buildStableGallerySection(),

              const SizedBox(height: 40),

              // C. Seksi Deskripsi dengan alignment presisi
              _buildAboutSection(context, content),

              const SizedBox(height: 48),

              // D. Tombol Aksi dengan padding konsisten
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: _buildNeomorphicActionButton(context, content),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // A. BARU: Header Aplikasi dengan Ikon + Judul & Kategori
  Widget _buildAppHeaderWithIcon(BuildContext context, ARContent content) {
    return Row(
      children: [
        // Ikon Aplikasi di sisi kiri
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                offset: const Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.white,
                offset: const Offset(-4, -4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              _getIconForContent(content.title),
              size: 40,
              color: AppColors.primary,
            ),
          ),
        ),

        const SizedBox(width: 20), // Spasi antara ikon dan teks
        // Blok Teks (Judul & Kategori) dengan alignment vertikal di tengah
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Alignment vertikal
            children: [
              // Judul Game
              Text(
                content.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 28, // Sedikit diperkecil karena ada ikon
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Kategori Game
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  'Edukasi',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.orange.shade700,
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

  // B. STABILITAS: Seksi Galeri dengan Fixed Height & Padding untuk Shadow
  Widget _buildStableGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul dengan padding konsisten
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

        // PENTING: Garis Pemisah Oranye Full-width dengan padding konsisten
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Container(
            width: double.infinity,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // PERBAIKAN SHADOW: Container dengan tinggi yang lebih besar untuk shadow
        SizedBox(
          height: _carouselFixedHeight + 40, // TAMBAH 40px untuk ruang shadow
          child: PageView.builder(
            controller: _imageController,
            // PERBAIKAN: Tambahkan clipBehavior untuk shadow tidak terpotong
            clipBehavior: Clip.none,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: _carouselImages.length,
            itemBuilder: (context, index) {
              return Container(
                // PERBAIKAN: Padding yang cukup untuk shadow di semua sisi
                padding: const EdgeInsets.only(
                  left: _horizontalPadding,
                  right: _horizontalPadding,
                  top: 20, // Ruang atas untuk shadow
                  bottom: 20, // Ruang bawah untuk shadow
                ),
                child: Container(
                  height: _carouselImageHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.4),
                        AppColors.skyBlue.withOpacity(0.4),
                        AppColors.leafGreen.withOpacity(0.2),
                      ],
                    ),
                    // PERBAIKAN: Shadow yang lebih terlihat dan tidak terpotong
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius:
                            20, // Diperbesar untuk shadow yang lebih soft
                        offset: const Offset(0, 8),
                        spreadRadius:
                            2, // Tambah spread untuk shadow yang lebih luas
                      ),
                      // TAMBAHAN: Shadow kedua untuk depth effect
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                        spreadRadius: 4,
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

        const SizedBox(
          height: 8,
        ), // KURANGI spacing karena sudah ada padding di atas
        // Dots indicator dengan padding konsisten
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
                  color:
                      _currentImageIndex == index
                          ? Colors.orange
                          : Colors.grey.shade300,
                  boxShadow:
                      _currentImageIndex == index
                          ? [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
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

  // C. PRESISI: Seksi Deskripsi dengan alignment yang sempurna
  Widget _buildAboutSection(BuildContext context, ARContent content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul dengan padding konsisten
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

        // PENTING: Garis Pemisah Oranye Full-width dengan padding konsisten
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Container(
            width: double.infinity,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Teks deskripsi dengan padding konsisten dan hierarki font
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
                  fontSize: 14, // Font lebih kecil dari judul untuk hierarki
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Game AR interaktif ini menggunakan teknologi Augmented Reality untuk memberikan pengalaman belajar yang menyenangkan dan mendidik untuk anak-anak.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: AppColors.textSecondary,
                  fontSize: 14, // Font lebih kecil dari judul untuk hierarki
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // D. WAJIB: Tombol pemicu alur pop-up dengan debugging
  Widget _buildNeomorphicActionButton(BuildContext context, ARContent content) {
    return Consumer<ARContentProvider>(
      builder: (context, provider, child) {
        String buttonText;
        VoidCallback? onPressed;
        IconData buttonIcon;

        switch (content.status) {
          case AppConstants.statusNotDownloaded:
            buttonText = 'Mainkan Sekarang';
            buttonIcon = Icons.play_arrow;
            // WAJIB: Pemicu alur pop-up dengan debugging
            onPressed = () {
              debugPrint('Button pressed - showing popup');
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
            onPressed = () => _openARViewer(context, content.id);
            break;
          default:
            buttonText = 'Tidak Tersedia';
            buttonIcon = Icons.error;
            onPressed = null;
        }

        return _NeomorphicButton(
          width: double.infinity,
          height: 64,
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (content.status == AppConstants.statusDownloading) ...[
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                  ),
                ),
                const SizedBox(width: 16),
              ] else ...[
                Icon(buttonIcon, color: Colors.black54, size: 28),
                const SizedBox(width: 16),
              ],
              Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // WAJIB: Alur Pop-up Buku (Langkah 1) dengan perbaikan
  void _showBookConfirmationPopup(BuildContext context, ARContent content) {
    debugPrint('Showing book confirmation popup');

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext dialogContext) {
        return _BookConfirmationPopup(
          onHaveBook: () {
            debugPrint('User has book - starting download');
            Navigator.pop(dialogContext);
            if (mounted) {
              context.read<ARContentProvider>().downloadContent(content.id);
            }
          },
          onNeedBook: () {
            debugPrint('User needs book - showing marketplace');
            Navigator.pop(dialogContext);
            if (mounted) {
              _showMarketplacePopup(context);
            }
          },
        );
      },
    );
  }

  // WAJIB: Alur Pop-up Marketplace (Langkah 2) dengan perbaikan
  void _showMarketplacePopup(BuildContext context) {
    debugPrint('Showing marketplace popup');

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder:
          (BuildContext dialogContext) =>
              _MarketplacePopup(onClose: () => Navigator.pop(dialogContext)),
    );
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
            _NeomorphicButton(
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.arrow_back, color: Colors.black54),
                  SizedBox(width: 8),
                  Text(
                    'Kembali',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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

// Enhanced Neomorphic Button Widget
class _NeomorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double size;

  const _NeomorphicButton({
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.size = 48,
  });

  @override
  State<_NeomorphicButton> createState() => _NeomorphicButtonState();
}

class _NeomorphicButtonState extends State<_NeomorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.onPressed != null
              ? (_) => setState(() => _isPressed = true)
              : null,
      onTapUp:
          widget.onPressed != null
              ? (_) => setState(() => _isPressed = false)
              : null,
      onTapCancel:
          widget.onPressed != null
              ? () => setState(() => _isPressed = false)
              : null,
      onTap: () {
        if (widget.onPressed != null) {
          debugPrint('NeomorphicButton tapped');
          widget.onPressed!();
        }
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width ?? widget.size,
          height: widget.height ?? widget.size,
          decoration: BoxDecoration(
            color: _isPressed ? Colors.grey.shade200 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(
              widget.width != null ? 20 : widget.size / 2,
            ),
            boxShadow:
                _isPressed
                    ? [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                        spreadRadius: -1,
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(-4, -4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
          ),
          child:
              widget.onPressed != null
                  ? Center(child: widget.child)
                  : Opacity(opacity: 0.5, child: Center(child: widget.child)),
        ),
      ),
    );
  }
}

// WAJIB: Enhanced Book Confirmation Popup (Langkah 1)
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
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(6, 6),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.white,
              offset: const Offset(-6, -6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 56,
              color: Colors.orange.shade600,
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
                  child: _NeomorphicButton(
                    height: 52,
                    onPressed: () {
                      debugPrint('Ya button pressed');
                      onHaveBook();
                    },
                    child: const Text(
                      'Ya',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _NeomorphicButton(
                    height: 52,
                    onPressed: () {
                      debugPrint('Belum button pressed');
                      onNeedBook();
                    },
                    child: const Text(
                      'Belum',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
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
  }
}

// WAJIB: Enhanced Marketplace Popup (Langkah 2)
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
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(6, 6),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.white,
              offset: const Offset(-6, -6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_rounded,
              size: 56,
              color: Colors.blue.shade600,
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
            _NeomorphicButton(
              width: double.infinity,
              height: 52,
              onPressed: () {
                debugPrint('Tokopedia button pressed');
                onClose();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag,
                    color: Colors.green.shade600,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Beli di Tokopedia',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _NeomorphicButton(
              width: double.infinity,
              height: 52,
              onPressed: () {
                debugPrint('Shopee button pressed');
                onClose();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.orange.shade600,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Beli di Shopee',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _NeomorphicButton(
              width: double.infinity,
              height: 48,
              onPressed: () {
                debugPrint('Tutup button pressed');
                onClose();
              },
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

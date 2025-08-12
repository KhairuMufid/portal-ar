import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/providers/ar_content_provider.dart';
import '../../shared/widgets/neumorphic_button.dart';
import '../../shared/widgets/magical_decorations.dart';
import '../../shared/models/ar_content.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/constants.dart';
import '../ar_detail/ar_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _sparkleController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _sparkleAnimation;
  String selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _sparkleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.backgroundGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Magical floating decorations
          const MagicalFloatingElements(),

          // Additional floating decorations
          ..._buildFloatingDecorations(),

          // Main content with CustomScrollView
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Simple Header dengan Welcome Text
              _buildWelcomeHeaderSliver(),

              // Search Bar Section
              _buildSearchBarSliver(),

              // AR Baru Featured Section
              _buildNewARFeaturedSliver(),

              // Filter Kategori
              _buildCategoryFilterSliver(),

              // Grid Konten Utama (2 kolom)
              _buildMainContentGridSliver(),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingDecorations() {
    return [
      // Floating stars
      AnimatedBuilder(
        animation: _floatingAnimation,
        builder: (context, child) {
          return Positioned(
            top: 100 + _floatingAnimation.value,
            right: 30,
            child: AnimatedBuilder(
              animation: _sparkleAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.3 + (_sparkleAnimation.value * 0.4),
                  child: const Icon(
                    Icons.star,
                    color: AppColors.lightYellow,
                    size: 20,
                  ),
                );
              },
            ),
          );
        },
      ),

      // Floating shapes
      AnimatedBuilder(
        animation: _floatingAnimation,
        builder: (context, child) {
          return Positioned(
            top: 200 - _floatingAnimation.value,
            left: 20,
            child: AnimatedBuilder(
              animation: _sparkleAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.2 + (_sparkleAnimation.value * 0.3),
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: AppColors.softPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      // More floating elements
      AnimatedBuilder(
        animation: _floatingAnimation,
        builder: (context, child) {
          return Positioned(
            top: 300 + (_floatingAnimation.value * 0.5),
            right: 50,
            child: AnimatedBuilder(
              animation: _sparkleAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.25 + (_sparkleAnimation.value * 0.35),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.skyBlue,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    ];
  }

  Widget _buildWelcomeHeaderSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ).createShader(bounds),
              child: Text(
                'Selamat Datang di Portal AR',
                style: GoogleFonts.nunito(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Jelajahi dunia Augmented Reality yang menakjubkan!',
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBarSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: NeumorphicButton(
          onPressed: () {},
          elevation: 8,
          borderRadius: 20,
          padding: EdgeInsets.zero,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari mainan AR favoritmu...',
                hintStyle: GoogleFonts.nunito(
                  color: AppColors.textSecondary.withOpacity(0.7),
                  fontSize: 16,
                ),
                prefixIcon: Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(16),
                  child: Icon(Icons.search, color: AppColors.primary, size: 24),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewARFeaturedSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title tanpa emoji dan deskripsi
            Text(
              'AR Terbaru Kami!',
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            // Featured card dengan shadow neumorphic seperti filter kategori
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: NeumorphicButton(
                onPressed: () {
                  final arContents =
                      context.read<ARContentProvider>().allContent;
                  if (arContents.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ARDetailPage(contentId: arContents.first.id),
                      ),
                    );
                  }
                },
                elevation: 0,
                borderRadius: 20,
                padding: EdgeInsets.zero,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.skyBlue.withOpacity(0.3),
                        AppColors.primary.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background image placeholder
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.skyBlue.withOpacity(0.6),
                                  AppColors.primary.withOpacity(0.4),
                                  AppColors.primaryLight.withOpacity(0.3),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.pets,
                                size: 60,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Dark gradient overlay at bottom
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 8,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul AR
                            Text(
                              'Petualangan Hutan Ajaib',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),

                            Row(
                              children: [
                                // Category label
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(8),
                                    // Subtle inner shadow effect untuk label
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.1),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    'Animal',
                                    style: GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                // Play button 3D
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(3, 3),
                                        blurRadius: 6,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: NeumorphicButton(
                                    onPressed: () {
                                      // Play AR content
                                    },
                                    color: const Color(0xFF4CAF50),
                                    elevation: 3,
                                    borderRadius: 22,
                                    padding: const EdgeInsets.all(10),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContentGridSliver() {
    return Consumer<ARContentProvider>(
      builder: (context, provider, child) {
        final filteredContent =
            selectedCategory == 'Semua'
                ? provider.allContent
                : provider.allContent
                    .where((content) => content.category == selectedCategory)
                    .toList();

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final content = filteredContent[index];
              return _buildGridContentCard(content);
            }, childCount: filteredContent.length),
          ),
        );
      },
    );
  }

  Widget _buildGridContentCard(ARContent content) {
    return NeumorphicButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ARDetailPage(contentId: content.id),
          ),
        );
      },
      elevation: 6,
      borderRadius: 16,
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(0.6),
              offset: const Offset(3, 3),
              blurRadius: 6,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              offset: const Offset(-2, -2),
              blurRadius: 4,
              spreadRadius: -1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.7),
                  AppColors.primaryLight.withOpacity(0.5),
                  AppColors.skyBlue.withOpacity(0.4),
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: const Offset(-1, -1),
                          blurRadius: 2,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      _getIconForCategory(content.category),
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                // Dark gradient overlay at bottom
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.25, 0.6, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content overlay
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        content.title,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          shadows: [
                            Shadow(
                              color: Colors.black87,
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Category label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              offset: const Offset(-1, -1),
                              blurRadius: 2,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Text(
                          content.category,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Animal':
        return Icons.pets;
      case 'Pembelajaran':
        return Icons.school;
      case 'Permainan':
        return Icons.games;
      case 'Kreativitas':
        return Icons.palette;
      default:
        return Icons.category;
    }
  }

  Widget _buildCategoryFilterSliver() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 55,
            margin: const EdgeInsets.only(top: 8, bottom: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.categories.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemBuilder: (context, index) {
                final category = AppConstants.categories[index];
                final isSelected = selectedCategory == category;

                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: NeumorphicButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    color:
                        isSelected
                            ? AppColors.primary
                            : AppColors.backgroundLight.withOpacity(0.1),
                    elevation: 6.0,
                    borderRadius: 20,
                    use3DEffect: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          color:
                              isSelected
                                  ? AppColors.textLight
                                  : AppColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: GoogleFonts.nunito(
                            color:
                                isSelected
                                    ? AppColors.textLight
                                    : AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case AppConstants.categoryAll:
        return Icons.grid_view;
      case AppConstants.categoryAnimals:
        return Icons.pets;
      case AppConstants.categoryReligion:
        return Icons.mosque;
      case AppConstants.categoryNature:
        return Icons.nature;
      case AppConstants.categoryScience:
        return Icons.science;
      case AppConstants.categoryHistory:
        return Icons.history_edu;
      case AppConstants.categoryGeneral:
        return Icons.category;
      default:
        return Icons.category;
    }
  }
}

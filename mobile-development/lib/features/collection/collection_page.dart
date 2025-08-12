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

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage>
    with TickerProviderStateMixin {
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
              // Header
              _buildHeaderSliver(),

              // Filter Kategori
              _buildCategoryFilterSliver(),

              // Downloaded content list (single column)
              _buildContentListSliver(),

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

  Widget _buildHeaderSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
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
                hintText: 'Cari konten AR mu...',
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

  Widget _buildContentListSliver() {
    return Consumer<ARContentProvider>(
      builder: (context, provider, child) {
        final filteredContent =
            selectedCategory == 'Semua'
                ? provider.downloadedContent
                : provider.downloadedContent
                    .where((content) => content.category == selectedCategory)
                    .toList();

        if (filteredContent.isEmpty) {
          return SliverToBoxAdapter(child: _buildEmptyState());
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final content = filteredContent[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildHorizontalARContentCard(content),
              );
            }, childCount: filteredContent.length),
          ),
        );
      },
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

  Widget _buildHorizontalARContentCard(ARContent content) {
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
        height: 120,
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
          child: Stack(
            children: [
              // Background thumbnail (full cover)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.primaryLight.withOpacity(0.6),
                        AppColors.skyBlue.withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _getIconForCategory(content.category),
                      size: 60,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),

              // Dark overlay gradient (fade from bottom to top)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Content overlay - Left side (title and category)
              Positioned(
                bottom: 16,
                left: 16,
                right: 80, // Leave space for play button
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      content.title,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                    const SizedBox(height: 8),

                    // Category label
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(10),
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

              // Play button - Right side
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: NeumorphicButton(
                    onPressed: () {
                      // Navigate to AR Viewer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ARDetailPage(contentId: content.id),
                        ),
                      );
                    },
                    color: const Color(0xFF4CAF50),
                    elevation: 4,
                    borderRadius: 25,
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.toys,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Koleksi AR mu masih kosong.\nUnduh beberapa konten AR dari beranda!',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/ar_content_provider.dart';
import '../../shared/widgets/ar_content_card.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/app_theme.dart';
import '../ar_detail/ar_detail_page.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  String _selectedFilter = 'Semua';
  final List<String> _filterOptions = ['Semua', 'Favorit', 'Terbaru'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kotak Mainan',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pribadi ✨',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              color: AppColors.skyBlue,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Consumer<ARContentProvider>(
                            builder: (context, provider, child) {
                              return Text(
                                '${provider.downloadedContent.length} mainan siap dimainkan',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: AppTheme.neumorphismDecoration(
                        borderRadius: 30,
                      ),
                      child: const Icon(
                        Icons.toys,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

              // Filter tabs (Favorites, Recently Played, etc.)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _FilterChip(
                        label: 'Semua',
                        isSelected: _selectedFilter == 'Semua',
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Semua';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FilterChip(
                        label: 'Favorit ❤️',
                        isSelected: _selectedFilter == 'Favorit',
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Favorit';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FilterChip(
                        label: 'Terbaru',
                        isSelected: _selectedFilter == 'Terbaru',
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Terbaru';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Downloaded content grid
              Expanded(
                child: Consumer<ARContentProvider>(
                  builder: (context, provider, child) {
                    List<dynamic> filteredContent = _getFilteredContent(
                      provider,
                    );

                    if (filteredContent.isEmpty) {
                      return _buildEmptyState();
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                      itemCount: filteredContent.length,
                      itemBuilder: (context, index) {
                        final content = filteredContent[index];
                        return ARContentCard(
                          content: content,
                          showDownloadButton: false,
                          showDownloadSize: false,
                          onTap: () => _openARDetail(context, content.id),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic> _getFilteredContent(ARContentProvider provider) {
    final downloadedContent = provider.downloadedContent;

    switch (_selectedFilter) {
      case 'Favorit':
        return downloadedContent
            .where((content) => content.isFavorite)
            .toList();
      case 'Terbaru':
        final sortedContent = List.from(downloadedContent);
        sortedContent.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return sortedContent;
      default:
        return downloadedContent;
    }
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    switch (_selectedFilter) {
      case 'Favorit':
        message =
            'Belum ada mainan favorit.\nTandai mainan sebagai favorit untuk melihatnya di sini!';
        icon = Icons.favorite_border;
        break;
      case 'Terbaru':
        message =
            'Belum ada mainan yang diunduh.\nUnduh beberapa mainan AR terlebih dahulu!';
        icon = Icons.new_releases;
        break;
      default:
        message =
            'Kotak mainanmu masih kosong.\nUnduh beberapa mainan AR dari beranda!';
        icon = Icons.toys;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.textSecondary.withOpacity(0.5)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openARDetail(BuildContext context, String contentId) {
    // Navigate to AR detail page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ARDetailPage(contentId: contentId),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration:
            isSelected
                ? AppTheme.gradientDecoration(
                  colors: AppColors.primaryGradient,
                  borderRadius: 20,
                )
                : AppTheme.neumorphismDecoration(borderRadius: 20),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? AppColors.textLight : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

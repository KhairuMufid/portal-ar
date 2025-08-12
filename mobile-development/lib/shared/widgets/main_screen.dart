import 'package:flutter/material.dart';
import 'dart:ui';
import '../../features/home/home_page.dart';
import '../../features/collection/collection_page.dart';
import '../../features/settings/settings_page.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late List<AnimationController> _iconControllers;
  late List<Animation<double>> _iconAnimations;
  bool _isAnimatingToPage = false; // Flag untuk mencegah konflik onPageChanged

  final List<Widget> _pages = [
    const HomePage(),
    const CollectionPage(),
    const SettingsPage(),
  ];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.toys,
    Icons.settings_rounded,
  ];

  final List<String> _labels = [
    AppConstants.homeLabel,
    AppConstants.collectionLabel,
    AppConstants.settingsLabel,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _iconControllers = List.generate(
      _icons.length,
      (index) => AnimationController(
        duration: AppConstants.shortAnimation,
        vsync: this,
      ),
    );

    _iconAnimations =
        _iconControllers
            .map(
              (controller) => Tween<double>(begin: 1.0, end: 1.3).animate(
                CurvedAnimation(parent: controller, curve: Curves.elasticOut),
              ),
            )
            .toList();

    // Animate the first icon
    _iconControllers[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    _isAnimatingToPage = true; // Set flag sebelum animasi

    setState(() {
      _currentIndex = index;
    });

    _pageController
        .animateToPage(
          index,
          duration: AppConstants.mediumAnimation,
          curve: Curves.easeInOut,
        )
        .then((_) {
          // Reset flag setelah animasi selesai
          _isAnimatingToPage = false;
        });

    // Animate icons
    for (int i = 0; i < _iconControllers.length; i++) {
      if (i == index) {
        _iconControllers[i].forward();
      } else {
        _iconControllers[i].reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Penting untuk floating effect
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          // Hanya update state jika bukan animasi manual dari tap
          if (!_isAnimatingToPage) {
            setState(() {
              _currentIndex = index;
            });

            // Animate icons when page changes via swipe
            for (int i = 0; i < _iconControllers.length; i++) {
              if (i == index) {
                _iconControllers[i].forward();
              } else {
                _iconControllers[i].reverse();
              }
            }
          }
        },
        children: _pages,
      ),
      bottomNavigationBar: _buildFloatingBottomNavBar(),
    );
  }

  Widget _buildFloatingBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30), // Floating dari bottom
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ), // Frosted glass effect
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.85), // Lebih terang
                  Colors.white.withValues(alpha: 0.75), // Lebih terang
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.3,
                ), // Border lebih terlihat
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.08,
                  ), // Shadow lebih soft
                  offset: const Offset(0, 8),
                  blurRadius: 32,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.04,
                  ), // Shadow lebih soft
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Home menu - positioned to the left
                Expanded(
                  flex: 1,
                  child: Center(child: _buildFloatingNavItem(0)),
                ),
                // Collection menu - perfectly centered
                Expanded(
                  flex: 1,
                  child: Center(child: _buildFloatingNavItem(1)),
                ),
                // Settings menu - positioned to the right
                Expanded(
                  flex: 1,
                  child: Center(child: _buildFloatingNavItem(2)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingNavItem(int index) {
    final isSelected = index == _currentIndex;

    return AnimatedBuilder(
      animation: _iconAnimations[index],
      builder: (context, child) {
        return GestureDetector(
          onTap: () => _onNavTap(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration:
                isSelected
                    ? BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    )
                    : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: _iconAnimations[index].value,
                  child: Icon(
                    _icons[index],
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: AppConstants.shortAnimation,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 11,
                  ),
                  child: Text(_labels[index]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

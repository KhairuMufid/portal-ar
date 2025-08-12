import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class MagicalFloatingElements extends StatefulWidget {
  const MagicalFloatingElements({super.key});

  @override
  State<MagicalFloatingElements> createState() =>
      _MagicalFloatingElementsState();
}

class _MagicalFloatingElementsState extends State<MagicalFloatingElements>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Animation<Offset>> _offsetAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(6, (index) {
      return AnimationController(
        duration: Duration(seconds: 3 + (index % 3)),
        vsync: this,
      )..repeat(reverse: true);
    });

    _animations =
        _controllers.map((controller) {
          return Tween<double>(begin: 0.3, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
        }).toList();

    _offsetAnimations =
        _controllers.map((controller) {
          return Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0, -20),
          ).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
        }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Floating stars
        for (int i = 0; i < 3; i++)
          AnimatedBuilder(
            animation: _animations[i],
            builder: (context, child) {
              return Positioned(
                top: 80 + (i * 150),
                right: 20 + (i * 30),
                child: Transform.translate(
                  offset: _offsetAnimations[i].value,
                  child: Opacity(
                    opacity: _animations[i].value * 0.6,
                    child: Icon(
                      Icons.star,
                      size: 16 + (i * 4),
                      color: _getStarColor(i),
                    ),
                  ),
                ),
              );
            },
          ),

        // Floating shapes - left side
        for (int i = 3; i < 6; i++)
          AnimatedBuilder(
            animation: _animations[i],
            builder: (context, child) {
              return Positioned(
                top: 120 + ((i - 3) * 180),
                left: 15 + ((i - 3) * 25),
                child: Transform.translate(
                  offset: _offsetAnimations[i].value,
                  child: Opacity(
                    opacity: _animations[i].value * 0.5,
                    child: _buildFloatingShape(i - 3),
                  ),
                ),
              );
            },
          ),

        // Magical sparkles in the center
        AnimatedBuilder(
          animation: _animations[0],
          builder: (context, child) {
            return Positioned(
              top: screenSize.height * 0.4,
              left: screenSize.width * 0.5 - 25,
              child: Transform.translate(
                offset: Offset(
                  _offsetAnimations[0].value.dx * 2,
                  _offsetAnimations[0].value.dy * 0.5,
                ),
                child: Opacity(
                  opacity: _animations[0].value * 0.3,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // More floating elements for richness
        AnimatedBuilder(
          animation: _animations[1],
          builder: (context, child) {
            return Positioned(
              top: screenSize.height * 0.7,
              right: 40,
              child: Transform.translate(
                offset: _offsetAnimations[1].value,
                child: Opacity(
                  opacity: _animations[1].value * 0.4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.skyBlue.withOpacity(0.6),
                          AppColors.leafGreen.withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getStarColor(int index) {
    switch (index % 3) {
      case 0:
        return AppColors.lightYellow;
      case 1:
        return AppColors.softPink;
      default:
        return AppColors.skyBlue;
    }
  }

  Widget _buildFloatingShape(int index) {
    switch (index % 3) {
      case 0:
        return Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: AppColors.softPink,
            shape: BoxShape.circle,
          ),
        );
      case 1:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.leafGreen,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      default:
        return Container(
          width: 10,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.skyBlue,
            borderRadius: BorderRadius.circular(8),
          ),
        );
    }
  }
}

// Widget untuk hiasan pada header/section tertentu
class SectionDecorator extends StatefulWidget {
  final Widget child;
  final bool showSparkles;
  final Color? primaryColor;

  const SectionDecorator({
    super.key,
    required this.child,
    this.showSparkles = true,
    this.primaryColor,
  });

  @override
  State<SectionDecorator> createState() => _SectionDecoratorState();
}

class _SectionDecoratorState extends State<SectionDecorator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _sparkleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,

        if (widget.showSparkles) ...[
          // Top-right sparkle
          Positioned(
            top: -5,
            right: -5,
            child: AnimatedBuilder(
              animation: _sparkleAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _sparkleAnimation.value * 0.8,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 12,
                    color: widget.primaryColor ?? AppColors.primary,
                  ),
                );
              },
            ),
          ),

          // Bottom-left sparkle
          Positioned(
            bottom: -5,
            left: -5,
            child: AnimatedBuilder(
              animation: _sparkleAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: (1 - _sparkleAnimation.value) * 0.6,
                  child: Icon(
                    Icons.star,
                    size: 8,
                    color: widget.primaryColor ?? AppColors.lightYellow,
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

// Widget untuk background pattern yang lembut
class MagicalBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;

  const MagicalBackground({
    super.key,
    required this.child,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ?? AppColors.backgroundGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Subtle pattern overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(painter: _DotPatternPainter()),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill;

    const dotSize = 2.0;
    const spacing = 30.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        if ((x / spacing + y / spacing) % 2 == 0) {
          canvas.drawCircle(Offset(x, y), dotSize, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

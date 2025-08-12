import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/constants.dart';
import '../../core/constants/colors.dart';

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final List<Color>? gradientColors;
  final double elevation;
  final bool use3DEffect;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.gradientColors,
    this.elevation = 8.0,
    this.use3DEffect = true,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _pressController;
  late AnimationController _scaleController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: AppConstants.shortAnimation,
      vsync: this,
    );

    // Animation untuk efek 3D elevation
    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));

    // Animation untuk scale effect
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));

    // Animation untuk offset effect (tombol tenggelam)
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 4),
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _isPressed = true;
      });
      _pressController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _isPressed = false;
      });
      _pressController.reverse();
      widget.onPressed?.call();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
      setState(() {
        _isPressed = false;
      });
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.use3DEffect) {
      // Fallback ke style lama untuk komponen tertentu
      return AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: widget.onPressed != null ? _onTapDown : null,
              onTapUp: widget.onPressed != null ? _onTapUp : null,
              onTapCancel: widget.onPressed != null ? _onTapCancel : null,
              child: Container(
                width: widget.width,
                height: widget.height,
                margin: widget.margin,
                padding: widget.padding ?? const EdgeInsets.all(16),
                decoration:
                    widget.gradientColors != null
                        ? AppTheme.gradientDecoration(
                          colors: widget.gradientColors!,
                          borderRadius: widget.borderRadius ?? 16,
                        )
                        : AppTheme.neumorphismDecoration(
                          color: widget.color,
                          borderRadius: widget.borderRadius ?? 16,
                          isPressed: _isPressed,
                        ),
                child: widget.child,
              ),
            ),
          );
        },
      );
    }

    // Efek 3D baru untuk tombol interaktif
    return AnimatedBuilder(
      animation: Listenable.merge([_pressController, _scaleController]),
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: widget.onPressed != null ? _onTapDown : null,
              onTapUp: widget.onPressed != null ? _onTapUp : null,
              onTapCancel: widget.onPressed != null ? _onTapCancel : null,
              child: Stack(
                children: [
                  // Shadow/base layer (efek bayangan bawah)
                  if (!_isPressed)
                    Container(
                      width: widget.width,
                      height: widget.height,
                      margin:
                          widget.margin?.add(const EdgeInsets.only(top: 4)) ??
                          const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? 16,
                        ),
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ),

                  // Main button container
                  Container(
                    width: widget.width,
                    height: widget.height,
                    margin: widget.margin,
                    padding: widget.padding ?? const EdgeInsets.all(16),
                    decoration: _build3DDecoration(),
                    child: widget.child,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _build3DDecoration() {
    if (widget.gradientColors != null) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
        gradient: LinearGradient(
          colors: widget.gradientColors!,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border:
            _isPressed
                ? null
                : Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow:
            _isPressed
                ? [
                  // Pressed state - minimal shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
                : [
                  // Normal state - elevated shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                  ),
                  // Inner highlight effect
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
      );
    }

    // Default decoration with neumorphism enhancement
    return BoxDecoration(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
      color: widget.color ?? AppColors.backgroundLight,
      border:
          _isPressed
              ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1)
              : Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      boxShadow:
          _isPressed
              ? [
                // Pressed state - simulated inset shadow effect
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
              : [
                // Normal state - 3D elevated effect
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: _elevationAnimation.value,
                  offset: Offset(0, _elevationAnimation.value / 2),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 6,
                  offset: const Offset(-2, -2),
                ),
                // Additional highlight for 3D effect
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 2,
                  offset: const Offset(0, -1),
                ),
              ],
    );
  }
}

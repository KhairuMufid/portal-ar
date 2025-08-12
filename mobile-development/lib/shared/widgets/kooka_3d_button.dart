import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/colors.dart';

/// Widget tombol 3D kustom yang mengimplementasikan DNA visual "Aksi Cepat"
/// dengan efek tekan fisik yang memuaskan
class Kooka3DButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double borderRadius;
  final bool isPrimary;
  final bool isEnabled;

  const Kooka3DButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius = 16.0,
    this.isPrimary = false,
    this.isEnabled = true,
  });

  @override
  State<Kooka3DButton> createState() => _Kooka3DButtonState();
}

class _Kooka3DButtonState extends State<Kooka3DButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _pressController;
  late AnimationController _hapticController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _shadowOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Controller untuk animasi tekan
    _pressController = AnimationController(
      duration: const Duration(
        milliseconds: 80,
      ), // Lebih cepat untuk responsivitas
      vsync: this,
    );

    // Controller untuk haptic feedback timing
    _hapticController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    // Animasi untuk perubahan elevasi (tinggi tombol)
    _elevationAnimation = Tween<double>(
      begin: 8.0, // Tinggi normal
      end: 2.0, // Tinggi saat ditekan
    ).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );

    // Animasi untuk scale effect halus
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );

    // Animasi untuk offset (tombol "tenggelam")
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 6), // Tenggelam ke bawah
    ).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );

    // Animasi untuk opacity shadow
    _shadowOpacityAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _hapticController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isEnabled && widget.onPressed != null) {
      setState(() {
        _isPressed = true;
      });
      _pressController.forward();

      // Haptic feedback saat tombol ditekan
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isEnabled && widget.onPressed != null) {
      // Pastikan animasi press minimal terlihat untuk 80ms
      const minPressDuration = Duration(milliseconds: 80);

      Future.delayed(minPressDuration, () {
        if (mounted) {
          _releaseButton();
        }
      });

      // Haptic feedback saat tombol dilepas
      HapticFeedback.selectionClick();

      // Panggil callback
      widget.onPressed?.call();
    }
  }

  void _onTapCancel() {
    if (widget.isEnabled && widget.onPressed != null) {
      _releaseButton();
    }
  }

  void _releaseButton() {
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pressController,
        _elevationAnimation,
        _scaleAnimation,
        _offsetAnimation,
        _shadowOpacityAnimation,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Stack(
                children: [
                  // Base shadow layer (bayangan bawah untuk efek ketinggian)
                  if (!_isPressed && widget.isEnabled)
                    Container(
                      width: widget.width,
                      height: widget.height,
                      margin:
                          widget.margin?.add(
                            EdgeInsets.only(
                              top: _elevationAnimation.value,
                              left: _elevationAnimation.value / 2,
                            ),
                          ) ??
                          EdgeInsets.only(
                            top: _elevationAnimation.value,
                            left: _elevationAnimation.value / 2,
                          ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                        // Gunakan warna bayangan yang sesuai dengan warna button
                        color: _getBaseShadowColor().withOpacity(
                          0.2 * _shadowOpacityAnimation.value,
                        ),
                      ),
                    ),

                  // Main button container dengan DNA "Aksi Cepat"
                  Container(
                    width: widget.width,
                    height: widget.height,
                    margin: widget.margin,
                    padding:
                        widget.padding ??
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                    decoration: _buildKookaDNADecoration(),
                    child: AnimatedOpacity(
                      opacity: widget.isEnabled ? 1.0 : 0.6,
                      duration: const Duration(milliseconds: 200),
                      child: widget.child,
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

  /// Membangun dekorasi dengan DNA visual "Aksi Cepat"
  BoxDecoration _buildKookaDNADecoration() {
    final baseColor =
        widget.color ??
        (widget.isPrimary ? AppColors.primary : AppColors.backgroundLight);

    // Buat gradient 3D dengan warna atas lebih terang dan bawah lebih gelap
    final lightColor = _lightenColor(baseColor, 0.15);
    final darkColor = _darkenColor(baseColor, 0.1);

    return BoxDecoration(
      borderRadius: BorderRadius.circular(widget.borderRadius),

      // Gunakan gradient untuk efek 3D yang lebih natural
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors:
            _isPressed
                ? [darkColor, baseColor]
                : [lightColor, baseColor, darkColor],
        stops: _isPressed ? [0.0, 1.0] : [0.0, 0.5, 1.0],
      ),

      // DNA "Aksi Cepat": Kombinasi inner dan outer shadow yang khas
      boxShadow: _isPressed ? _buildPressedShadows() : _buildNormalShadows(),

      // Border halus untuk definisi yang lebih jelas
      border: Border.all(
        color:
            widget.isPrimary
                ? Colors.white.withOpacity(0.2)
                : AppColors.primary.withOpacity(0.1),
        width: 0.5,
      ),
    );
  }

  /// Shadow untuk state normal (menonjol)
  List<BoxShadow> _buildNormalShadows() {
    // Dapatkan warna dasar untuk bayangan yang sesuai
    final baseColor =
        widget.color ??
        (widget.isPrimary ? AppColors.primary : AppColors.backgroundLight);

    // Buat versi warna yang lebih terang untuk bayangan (tidak terlalu gelap)
    final shadowColor = _darkenColor(baseColor, 0.2);

    return [
      // Outer shadow bawah-kanan (efek ketinggian) - menggunakan warna yang sesuai
      BoxShadow(
        color: shadowColor.withOpacity(0.4),
        offset: Offset(
          _elevationAnimation.value / 2,
          _elevationAnimation.value,
        ),
        blurRadius: _elevationAnimation.value * 2,
        spreadRadius: 0,
      ),

      // Inner highlight atas-kiri (efek cahaya)
      BoxShadow(
        color: Colors.white.withOpacity(widget.isPrimary ? 0.3 : 0.8),
        offset: const Offset(-2, -2),
        blurRadius: 4,
        spreadRadius: 0,
      ),

      // Ambient shadow untuk depth - warna yang lebih lembut
      BoxShadow(
        color: shadowColor.withOpacity(0.12),
        offset: const Offset(0, 2),
        blurRadius: 8,
        spreadRadius: -2,
      ),
    ];
  }

  /// Shadow untuk state ditekan (tenggelam)
  List<BoxShadow> _buildPressedShadows() {
    // Dapatkan warna dasar untuk bayangan yang sesuai saat ditekan
    final baseColor =
        widget.color ??
        (widget.isPrimary ? AppColors.primary : AppColors.backgroundLight);

    // Buat warna yang lebih terang untuk pressed state juga
    final shadowColor = _darkenColor(baseColor, 0.25);

    return [
      // Inner shadow untuk efek tenggelam - gunakan warna yang sesuai
      BoxShadow(
        color: shadowColor.withOpacity(0.3),
        offset: const Offset(2, 2),
        blurRadius: 4,
        spreadRadius: -1,
      ),

      // Highlight berkurang
      BoxShadow(
        color: Colors.white.withOpacity(0.1),
        offset: const Offset(-1, -1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
    ];
  }

  /// Helper method untuk membuat warna lebih gelap
  Color _darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );

    return darkened.toColor();
  }

  /// Helper method untuk membuat warna lebih terang
  Color _lightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );

    return lightened.toColor();
  }

  /// Helper method untuk mendapatkan warna bayangan yang sesuai dengan button
  Color _getBaseShadowColor() {
    final baseColor =
        widget.color ??
        (widget.isPrimary ? AppColors.primary : AppColors.backgroundLight);

    // Buat warna bayangan yang lebih terang (tidak terlalu gelap)
    return _darkenColor(baseColor, 0.15);
  }
}

/// Tombol primary dengan warna utama aplikasi
class Kooka3DPrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const Kooka3DPrimaryButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Kooka3DButton(
      onPressed: onPressed,
      width: width,
      height: height,
      isPrimary: true,
      color: AppColors.primary,
      isEnabled: onPressed != null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.textLight, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol secondary dengan warna background
class Kooka3DSecondaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const Kooka3DSecondaryButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Kooka3DButton(
      onPressed: onPressed,
      width: width,
      height: height,
      isPrimary: false,
      color: AppColors.backgroundLight,
      isEnabled: onPressed != null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

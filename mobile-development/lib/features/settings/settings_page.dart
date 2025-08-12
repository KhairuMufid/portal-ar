import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/settings_provider.dart';
import '../../shared/widgets/neumorphic_button.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/theme/app_theme.dart';
import 'dart:math';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengaturan',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Atur preferensi aplikasi',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
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
                        Icons.settings,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Audio Settings Section
                Text(
                  'Audio 🎵',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Music Setting
                Consumer<SettingsProvider>(
                  builder: (context, settings, child) {
                    return _SettingTile(
                      icon: Icons.music_note,
                      title: 'Musik Latar',
                      subtitle: 'Putar musik di background',
                      value: settings.musicEnabled,
                      onChanged: () => settings.toggleMusic(),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Sound Setting
                Consumer<SettingsProvider>(
                  builder: (context, settings, child) {
                    return _SettingTile(
                      icon: Icons.volume_up,
                      title: 'Efek Suara',
                      subtitle: 'Putar suara tombol dan efek',
                      value: settings.soundEnabled,
                      onChanged: () => settings.toggleSound(),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Parent Zone Section
                Text(
                  'Area Orang Tua 👨‍👩‍👧‍👦',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Buy Books Button
                NeumorphicButton(
                  onPressed: () => _showParentGate(context),
                  padding: const EdgeInsets.all(20),
                  gradientColors: [AppColors.primary, AppColors.primaryLight],
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.textLight.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: AppColors.textLight,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Beli Buku AR',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Temukan buku AR terbaru untuk dimainkan',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: AppColors.textLight.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textLight,
                        size: 16,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // App Info
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: AppTheme.neumorphismDecoration(
                          borderRadius: 40,
                        ),
                        child: const Icon(
                          Icons.stars,
                          color: AppColors.primary,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppConstants.appName,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Versi ${AppConstants.appVersion}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Portal Mainan Ajaib untuk Anak-Anak',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showParentGate(BuildContext context) {
    final random = Random();
    final questionData =
        AppConstants.parentGateQuestions[random.nextInt(
          AppConstants.parentGateQuestions.length,
        )];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _ParentGateDialog(
          question: questionData['question'] as String,
          correctAnswer: questionData['answer'] as int,
          onSuccess: () {
            Navigator.pop(context);
            _showBuyBooksPage(context);
          },
        );
      },
    );
  }

  void _showBuyBooksPage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.neumorphismDecoration(borderRadius: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.book, size: 60, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'Halaman Pembelian',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Fitur ini akan tersedia segera!\nTerima kasih atas minatnya.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                NeumorphicButton(
                  onPressed: () => Navigator.pop(context),
                  gradientColors: AppColors.primaryGradient,
                  child: Text(
                    'Tutup',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final VoidCallback onChanged;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.neumorphismDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: value ? AppColors.primary : AppColors.textSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.textLight, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onChanged,
            child: AnimatedContainer(
              duration: AppConstants.shortAnimation,
              width: 60,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color:
                    value
                        ? AppColors.primary
                        : AppColors.textSecondary.withOpacity(0.3),
              ),
              child: AnimatedAlign(
                duration: AppConstants.shortAnimation,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.textLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParentGateDialog extends StatefulWidget {
  final String question;
  final int correctAnswer;
  final VoidCallback onSuccess;

  const _ParentGateDialog({
    required this.question,
    required this.correctAnswer,
    required this.onSuccess,
  });

  @override
  State<_ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<_ParentGateDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_controller.text);
    if (userAnswer == widget.correctAnswer) {
      widget.onSuccess();
    } else {
      setState(() {
        _showError = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showError = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.neumorphismDecoration(borderRadius: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, size: 48, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'Verifikasi Orang Tua',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Untuk melindungi anak-anak, silakan jawab pertanyaan berikut:',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              widget.question,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: AppTheme.neumorphismDecoration(borderRadius: 12),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Jawaban',
                ),
              ),
            ),
            if (_showError) ...[
              const SizedBox(height: 12),
              Text(
                'Jawaban salah, coba lagi!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: NeumorphicButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Batal',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeumorphicButton(
                    onPressed: _checkAnswer,
                    gradientColors: AppColors.primaryGradient,
                    child: Text(
                      'Jawab',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
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

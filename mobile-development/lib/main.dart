import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/font_helper.dart';
import 'core/constants/constants.dart';
import 'shared/providers/ar_content_provider.dart';
import 'shared/providers/settings_provider.dart';
import 'shared/widgets/main_screen.dart';
import 'features/ar_viewer/ar_viewer_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FontHelper.preloadFont();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(const KookaApp());
}

class KookaApp extends StatelessWidget {
  const KookaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ARContentProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: DefaultTextStyle(
              style: FontHelper.bodyMedium,
              child: child!,
            ),
          );
        },
        home: const MainScreen(),
        routes: {
          AppConstants.homeRoute: (context) => const MainScreen(),
          AppConstants.arViewerRoute: (context) {
            final contentId =
                ModalRoute.of(context)!.settings.arguments as String;
            return ARViewerPage(contentId: contentId);
          },
        },
      ),
    );
  }
}

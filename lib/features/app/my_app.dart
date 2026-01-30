import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/services/background/background_service.dart';
import 'package:todoon/core/services/sync/app_sync_sevice.dart';
import 'package:todoon/features/app/main_page.dart';
import 'package:todoon/features/auth/pages/auth_page.dart';
import 'package:todoon/features/auth/providers/auth_providers.dart';
import 'package:todoon/service_locator.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;
  bool _didSyncAfterLogin = false;

  final BackgroundService _backgroundService = BackgroundService();

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _backgroundService.initBackgroundService();
  }

  Future<void> _loadTheme() async {
    final mode = await context.savedTheme;
    setState(() {
      themeMode = mode;
      context.setSystemBarsFromTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviders>(
      builder: (context, auth, _) {
        auth.addListener(() {
          _handleAuthChanged(auth);
        });

        return MaterialApp(
          title: 'ToDoon',
          debugShowCheckedModeBanner: false,
          theme: context.lightTheme,
          darkTheme: context.darkTheme,
          highContrastTheme: context.lightHighContrast,
          highContrastDarkTheme: context.darkHighContrast,
          themeMode: themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: _buildHome(auth),
        );
      },
    );
  }

  void _handleAuthChanged(AuthProviders auth) {
    if (auth.user != null && !_didSyncAfterLogin) {
      _didSyncAfterLogin = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final syncService = sl.get<AppSyncService>();
        await syncService.pullAll();
        // start background push
        await _backgroundService.startBackgroundService();
      });
    }

    if (auth.user == null) {
      _didSyncAfterLogin = false;
    }
  }

  Widget _buildHome(AuthProviders auth) {
    if (auth.user != null) {
      return const MainPage();
    }

    return const AuthPage();
  }
}

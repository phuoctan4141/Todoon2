import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoon/core/resources/locales_manager.dart';

import 'package:todoon/core/services/firebase/firebase_options.dart';
import 'package:todoon/features/app/app.dart';
import 'package:todoon/features/app/app_bloc_providers.dart';
import 'package:todoon/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  initAppModule();
  initAuthModule();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.locales,
      path: AppLocales.assetsPath,
      fallbackLocale: AppLocales.fallbackLocale,
      startLocale: AppLocales.fallbackLocale,
      child: AppBlocProviders(child: MyApp()),
    ),
  );
}

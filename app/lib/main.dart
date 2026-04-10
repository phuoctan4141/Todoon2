import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:todoon/core/services/firebase/firebase_options.dart';
import 'package:todoon/features/app/presentation/app.dart';
import 'package:todoon/features/app/presentation/app_bloc_providers.dart';
import 'package:todoon/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initAppModule();
  initAuthModule();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: AppBlocProviders(child: MyApp()),
    ),
  );
}

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:todoon/core/services/firebase/firebase_options.dart';
import 'package:todoon/features/app/my_app.dart';
import 'package:todoon/routes/app_exports.dart';
import 'package:todoon/routes/provider_exports.dart';
import 'package:todoon/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await configureDependencies();
  await sl.get<AppBootstrapService>().run();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProviders(sl.get<AuthRepository>()),
          ),
          ChangeNotifierProvider(
            create: (_) => PlanContentProvider(
              planBlockRepo: sl.get<PlanBlockRepository>(),
              noteRepo: sl.get<NoteRepository>(),
              todoListRepo: sl.get<TodoListRepository>(),
              todoRepo: sl.get<TodoRepository>(),
              tagRepo: sl.get<TagRepository>(),
              noteTagRepo: sl.get<NoteTagRepository>(),
              todoTagRepo: sl.get<TodoListTagRepository>(),
              pendingAction: sl.get<PendingActionSyncService>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

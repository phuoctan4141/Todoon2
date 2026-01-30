import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:todoon/core/services/firebase/firebase_options.dart';
import 'package:todoon/core/services/sync/app_sync_sevice.dart';
import 'package:todoon/service_locator.dart';

@pragma('vm:entry-point')
void backgroundSync(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  configureDependencies();

  final syncService = await sl.getAsync<AppSyncService>();

  Timer.periodic(const Duration(seconds: 60), (timer) async {
    try {
      await syncService.pushAll();
    } catch (_) {}
  });
}

class BackgroundService {
  Future<void> initBackgroundService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundSync,
        autoStart: false,
        isForegroundMode: true,
        foregroundServiceTypes: [AndroidForegroundType.dataSync],
      ),
      iosConfiguration: IosConfiguration(
        onForeground: backgroundSync,
        onBackground: (_) async => true,
      ),
    );
  }

  Future<void> startBackgroundService() async {
    final service = FlutterBackgroundService();
    await service.startService();
  }

  Future<void> stopBackgroundService() async {
    final service = FlutterBackgroundService();
    service.invoke("stop");
  }
}

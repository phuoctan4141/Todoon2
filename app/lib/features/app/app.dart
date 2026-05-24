import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/strings_manager.dart';
import 'package:todoon/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:todoon/routes/app_router.dart';
import 'package:todoon/routes/route_names.dart';
import 'package:todoon/service_locator.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
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
    return MaterialApp(
      navigatorKey: navigator.key,
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: context.lightTheme,
      darkTheme: context.darkTheme,
      highContrastTheme: context.lightHighContrast,
      highContrastDarkTheme: context.darkHighContrast,
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.generateRoutes,
      builder: (context, child) => BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) => (previous != current),
        listener: (context, state) {
          switch (state) {
            case Unauthenticated():
              {
                navigator.clearStackAndPush(RouteNames.auth);
                break;
              }
            case Authenticated():
              {
                navigator.clearStackAndPush(RouteNames.home);
                break;
              }
            case Unknown():
              break;
          }
        },
        child: child,
      ),
    );
  }
}

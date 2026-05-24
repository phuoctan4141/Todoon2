import 'package:flutter/material.dart';

import 'package:todoon/features/auth/presentation/pages/auth_page.dart';
import 'package:todoon/common/app_state/state_widgets.dart';
import 'package:todoon/features/home/presentation/pages/home_page.dart';
import 'package:todoon/features/settings/presentation/pages/settings_page.dart';
import 'package:todoon/features/splash/presentation/pages/splash_page.dart';
import 'package:todoon/features/termsaprivacy/presentation/pages/termsaprivacy_page.dart';

import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return _fadeRoute(const SplashPage());

      case RouteNames.auth:
        return _slideRoute(const AuthPage());

      case RouteNames.home:
        return _slideRoute(const HomePage());

      case RouteNames.settings:
        return _slideRoute(const SettingsPage());

      case RouteNames.termsAndPrivacy:
        return _slideRoute(const TermsAndPrivacyPage());

      default:
        return MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: Center(child: StateWidgets.noRoute(context))),
        );
    }
  }

  /// Fade animation
  static PageRouteBuilder _fadeRoute(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: Durations.extralong1,
      reverseTransitionDuration: Durations.long3,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Slide animation
  static PageRouteBuilder _slideRoute(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: Durations.extralong1,
      reverseTransitionDuration: Durations.long3,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        const begin = Offset(0, 0.1);
        const end = Offset.zero;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}

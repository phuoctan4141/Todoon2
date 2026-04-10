import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService instance = NavigationService._internal();

  factory NavigationService() => instance;

  NavigationService._internal({GlobalKey<NavigatorState>? navigatorKey})
    : _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> _navigatorKey;

  GlobalKey<NavigatorState> get key => _navigatorKey;

  NavigatorState? get currentState => _navigatorKey.currentState;

  BuildContext? get currentContext => _navigatorKey.currentContext;

  void pop<T extends Object?>([T? result]) {
    final state = currentState;
    if (state != null && state.canPop()) {
      state.pop(result);
    }
  }

  Future<bool> maybePop<T extends Object?>([T? result]) {
    final state = currentState;
    return state?.maybePop(result) ?? Future.value(false);
  }

  void popUntilRoot() {
    currentState?.popUntil((route) => route.isFirst);
  }

  void popUntil(RoutePredicate predicate) {
    currentState?.popUntil(predicate);
  }

  void popUntilRouteName(String routeName) {
    currentState?.popUntil(ModalRoute.withName(routeName));
  }

  void popRootNavigator() {
    final context = currentContext;
    if (context != null) {
      final rootNavigator = Navigator.of(context, rootNavigator: true);
      if (rootNavigator.canPop()) {
        rootNavigator.pop();
      }
    }
  }

  Future<T?> push<T extends Object?>(Widget page) {
    final state = currentState;
    return state?.push<T>(MaterialPageRoute(builder: (_) => page)) ??
        Future.value(null);
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    final state = currentState;
    return state?.pushNamed<T>(routeName, arguments: arguments) ??
        Future.value(null);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Widget page,
    RoutePredicate predicate,
  ) {
    final state = currentState;
    return state?.pushAndRemoveUntil<T>(
          MaterialPageRoute(builder: (_) => page),
          predicate,
        ) ??
        Future.value(null);
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    final state = currentState;
    return state?.pushNamedAndRemoveUntil<T>(
          routeName,
          predicate,
          arguments: arguments,
        ) ??
        Future.value(null);
  }

  Future<T?> clearStackAndPush<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Widget page, {
    TO? result,
  }) {
    final state = currentState;
    return state?.pushReplacement<T, TO>(
          MaterialPageRoute(builder: (_) => page),
          result: result,
        ) ??
        Future.value(null);
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    final state = currentState;
    return state?.pushReplacementNamed<T, TO>(
          routeName,
          result: result,
          arguments: arguments,
        ) ??
        Future.value(null);
  }

  Future<T?> replace<T extends Object?, TO extends Object?>(
    Widget page, {
    TO? result,
  }) {
    final state = currentState;
    return state?.pushReplacement<T, TO>(
          MaterialPageRoute(builder: (_) => page),
          result: result,
        ) ??
        Future.value(null);
  }

  Future<T?> replaceNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  void removeRoute(Route route) {
    currentState?.removeRoute(route);
  }

  bool canPop() {
    return currentState?.canPop() ?? false;
  }

  bool canPopRootNavigator() {
    final context = currentContext;
    if (context != null) {
      return Navigator.of(context, rootNavigator: true).canPop();
    }
    return false;
  }
}

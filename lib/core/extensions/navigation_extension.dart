import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  /// Pop hiện tại
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Push màn hình mới
  Future<T?> push<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// Push named route
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Pop đến root
  void popUntilRoot() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  /// Replace current screen
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Widget page, {
    TO? result,
  }) {
    return Navigator.of(
      this,
    ).pushReplacement(MaterialPageRoute(builder: (_) => page), result: result);
  }

  /// Kiểm tra có thể pop không
  bool get canPop => Navigator.of(this).canPop();
}

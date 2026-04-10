import 'package:flutter/material.dart';
import 'package:todoon/core/resources/values_manager.dart';

class AppStyles {
  AppStyles._();

  static TextStyle _base({
    required FontWeight fontWeight,
    Color? color,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize ?? AppFontSize.s14,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle light({
    Color? color,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) {
    return _base(
      fontWeight: AppFontWeight.light,
      color: color,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle regular({
    Color? color,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) {
    return _base(
      fontWeight: AppFontWeight.regular,
      color: color,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle medium({
    Color? color,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) {
    return _base(
      fontWeight: AppFontWeight.medium,
      color: color,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle semiBold({
    Color? color,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) {
    return _base(
      fontWeight: AppFontWeight.semiBold,
      color: color,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle bold({
    Color? color,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) {
    return _base(
      fontWeight: AppFontWeight.bold,
      color: color,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

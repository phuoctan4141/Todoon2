// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/consts.dart';
import 'package:todoon/core/resources/values_manager.dart';

class GlassContainer extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry borderRadius;
  final BoxConstraints? constraints;
  final Widget child;
  const GlassContainer({
    super.key,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.r16)),
    this.constraints,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.theme.brightness == Brightness.dark;

    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          padding: padding,
          constraints: constraints,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.colors.surfaceContainer.withValues(
              alpha: AppColorValue.v30,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                context.colors.primaryContainer,
                context.colors.secondaryContainer,
                context.colors.tertiaryContainer,
              ],
            ),
            borderRadius: borderRadius,
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                width: d1,
              ),
              left: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                width: d1,
              ),
              right: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                width: d0d65,
              ),
              bottom: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                width: d0d65,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

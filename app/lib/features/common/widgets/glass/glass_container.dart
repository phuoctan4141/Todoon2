import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/values_manager.dart';

class GlassContainer extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final BorderRadius borderRadius;
  final BoxConstraints? constraints;
  final double blurSigma;
  final Widget child;

  const GlassContainer({
    super.key,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.r16)),
    this.constraints,
    this.blurSigma = 32.0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = context.colors;
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    final border = Border(
      top: BorderSide(color: borderColor, width: AppSize.s1),
      left: BorderSide(color: borderColor, width: AppSize.s1),
      right: BorderSide(color: borderColor, width: AppSize.s0d65),
      bottom: BorderSide(color: borderColor, width: AppSize.s0d65),
    );

    final decoration = BoxDecoration(
      color: colors.surfaceContainer.withValues(
        alpha: isDark ? AppColorValue.v70 : AppColorValue.v50,
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: [
          colors.primaryContainer,
          colors.secondaryContainer,
          colors.tertiaryContainer,
        ],
      ),
      borderRadius: borderRadius,
      border: border,
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: decoration,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: constraints ?? const BoxConstraints(),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

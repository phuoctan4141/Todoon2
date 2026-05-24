import 'dart:ui';
import 'package:easy_localization/easy_localization.dart' as tooltip;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';

class GlassActionButton extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;
  final IconData icon;
  final String? tooltip;

  const GlassActionButton({
    super.key,
    required this.expanded,
    required this.onTap,
    required this.icon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.theme.brightness == Brightness.dark;
    final double size = expanded ? 44.0 : 56.0;
    final double blurValue = 12.0;
    final BorderRadius radius = BorderRadius.circular(AppRadius.r16);
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    final border = Border(
      top: BorderSide(color: borderColor, width: AppSize.s1),
      left: BorderSide(color: borderColor, width: AppSize.s1),
      right: BorderSide(color: borderColor, width: AppSize.s0d65),
      bottom: BorderSide(color: borderColor, width: AppSize.s0d65),
    );

    final shadow = BoxShadow(
      color: isDark
          ? Colors.black.withValues(alpha: AppColorValue.v10)
          : Colors.white.withValues(alpha: AppColorValue.v10),
      blurRadius: 10,
      offset: const Offset(0, 4),
    );

    final boxDecoration = BoxDecoration(
      color: isDark
          ? Colors.black.withValues(alpha: AppColorValue.v10)
          : Colors.white.withValues(alpha: AppColorValue.v20),
      borderRadius: radius,
      border: border,
      boxShadow: [shadow],
    );

    final tooltipText = tooltip.orEmpty();

    return SizedBox.square(
      dimension: size,
      child: AnimatedSwitcher(
        duration: Durations.medium3,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: Material(
          key: ValueKey(expanded),
          color: Colors.transparent,
          child: Tooltip(
            message: tooltipText.isEmpty ? null : tooltipText.tr(),
            child: InkWell(
              borderRadius: radius,
              onTap: onTap,
              splashColor: (isDark ? Colors.white : Colors.black).withValues(
                alpha: AppColorValue.v30,
              ),
              highlightColor: (isDark ? Colors.white : Colors.black).withValues(
                alpha: AppColorValue.v30,
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurValue,
                    sigmaY: blurValue,
                  ),
                  child: Container(
                    width: size,
                    height: size,
                    alignment: Alignment.center,
                    decoration: boxDecoration,
                    child: Icon(
                      icon,
                      size: expanded ? AppSize.s24 : AppSize.s28,
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// === GlassMiniActionButton ===
class GlassMiniActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String? tooltip;

  const GlassMiniActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = context.colors;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final double blurValue = 12.0;
    final String titleText = tooltip.orEmpty();

    final border = Border(
      top: BorderSide(color: borderColor, width: AppSize.s1),
      left: BorderSide(color: borderColor, width: AppSize.s1),
      right: BorderSide(color: borderColor, width: AppSize.s0d65),
      bottom: BorderSide(color: borderColor, width: AppSize.s0d65),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.s28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
        child: Container(
          decoration: BoxDecoration(
            color: colors.tertiary.withValues(alpha: AppColorValue.v30),
            borderRadius: BorderRadius.circular(AppSize.s28),
            border: border,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s28),
              ),
              splashColor: (isDark ? Colors.white : Colors.black).withValues(
                alpha: AppColorValue.v30,
              ),
              highlightColor: (isDark ? Colors.white : Colors.black).withValues(
                alpha: AppColorValue.v30,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.s20,
                  vertical: AppSize.s14,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (titleText.isNotEmpty) ...[
                      Text(
                        titleText,
                        style: AppStyles.bold(color: colors.tertiary),
                      ),
                      const Gap(AppSize.s8),
                    ],
                    Icon(icon, size: AppSize.s28, color: colors.onTertiary),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

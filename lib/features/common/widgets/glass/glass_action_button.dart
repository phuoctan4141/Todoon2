import 'dart:ui';
import 'package:easy_localization/easy_localization.dart' as tooltip;
import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/consts.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double size = expanded ? 44 : 56;
    final double blurValue = 12.0;
    final BorderRadius radius = BorderRadius.circular(16);

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
            message: (tooltip ?? '').tr(),
            child: InkWell(
              borderRadius: radius,
              onTap: onTap,
              splashColor: (isDark ? Colors.white : Colors.black).withValues(
                alpha: AppColorValue.v10,
              ),
              highlightColor: Colors.transparent,
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
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: AppColorValue.v10)
                          : Colors.white.withValues(alpha: AppColorValue.v20),
                      borderRadius: radius,
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
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(
                                  alpha: AppColorValue.v10,
                                )
                              : Colors.white.withValues(
                                  alpha: AppColorValue.v10,
                                ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: expanded ? AppSize.s24 : AppSize.s28,
                      color: Theme.of(context).colorScheme.primary,
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
    final bool isDark = context.theme.brightness == Brightness.dark;
    final double blurValue = 12.0;

    return SizedBox.square(
      dimension: AppSize.s56,
      child: Material(
        color: context.colors.tertiary.withValues(alpha: AppColorValue.v30),
        shape: const CircleBorder(),
        child: Tooltip(
          message: (tooltip ?? '').tr(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            splashColor: Theme.of(context).colorScheme.surface,
            child: ClipOval(
              clipBehavior: Clip.antiAlias,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
                child: Container(
                  width: AppSize.s56,
                  height: AppSize.s56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.colors.tertiary.withValues(
                      alpha: AppColorValue.v30,
                    ),
                    shape: BoxShape.circle,
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
                  child: Icon(
                    icon,
                    size: AppSize.s28,
                    color: context.colors.onTertiary,
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

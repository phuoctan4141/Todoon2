import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';

class ChooseTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final Color iconColor;
  final Color? titleColor;
  final Color? subtitleColor;

  const ChooseTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.borderRadius,
    required this.iconColor,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = titleColor ?? context.colors.onSurface;
    final subTextColor = subtitleColor ?? context.colors.onPrimaryContainer;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        splashColor: textColor.withValues(alpha: AppColorValue.v20),
        highlightColor: textColor.withValues(alpha: AppColorValue.v10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p14,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppPadding.p8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: AppColorValue.v10),
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const Gap(AppSize.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        title,
                        style: AppStyles.medium(color: textColor),
                      ),
                    ),
                    if (subtitle != null)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          subtitle!,
                          style: AppStyles.regular(color: subTextColor),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

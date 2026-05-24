import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/icons_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/service_locator.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.tertiaryContainer.withValues(
        alpha: AppColorValue.v30,
      ),
      shape: CircleBorder(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: onTap ?? () => navigator.pop(),
        customBorder: CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p4),
          child: Icon(
            AppIcons.close,
            color: context.colors.onTertiaryContainer,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/assets_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';

class BgrImage extends StatelessWidget {
  final Widget child;

  const BgrImage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bgrImage = AssetImage(
      context.theme.brightness == .light
          ? ImageAssets.background_light
          : ImageAssets.background_dark,
    );
    final colorFilter = ColorFilter.mode(
      context.theme.brightness == .light
          ? Colors.white.withValues(alpha: AppColorValue.v50)
          : Colors.black.withValues(alpha: AppColorValue.v30),
      BlendMode.srcOver,
    );

    return Container(
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: bgrImage,
          fit: .cover,
          colorFilter: colorFilter,
        ),
      ),
      child: child,
    );
  }
}

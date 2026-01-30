import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/assets_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';

class BackgroundImageWidget extends StatelessWidget {
  final Widget child;
  const BackgroundImageWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            context.bgColor == Colors.white
                ? ImageAssets.bgr_light
                : ImageAssets.bgr_dark,
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            context.bgColor == Colors.white
                ? Colors.white.withValues(
                    alpha: AppColorValue.v60,
                  ) // nền sáng → phủ trắng
                : Colors.black.withValues(
                    alpha: AppColorValue.v50,
                  ), // nền tối → phủ đen
            BlendMode.srcOver,
          ),
        ),
      ),
      child: child,
    );
  }
}

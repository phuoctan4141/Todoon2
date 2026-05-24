import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/app_state/state_widgets.dart';
import 'package:todoon/generated/locale_keys.g.dart';
import 'package:todoon/service_locator.dart';

class CustomDialog {
  CustomDialog._();

  /// Show a custom dialog with a title, message, and actions.
  static Future<T?> show<T>({
    required BuildContext context,
    required Offset tapPosition,
    String? title,
    String? message,
    required List<Widget> actions,
    Duration duration = Durations.medium3,
    Curve curve = Curves.easeOutCubic,
    Color? barrierColor,
    Color? backgroundColor,
    double blurSigma = 32.0,
    bool showBackdropFilter = true,
    BorderRadius? borderRadius,
    double? elevation,
    MainAxisAlignment actionsAlignment = .center,
  }) {
    final defaultTitlePadding = const EdgeInsets.symmetric(
      horizontal: AppSize.s16,
      vertical: AppSize.s12,
    );

    final defaultContentPadding = const EdgeInsets.symmetric(
      horizontal: AppSize.s16,
      vertical: AppSize.s12,
    );
    final defaultActionsPadding = const EdgeInsets.symmetric(
      horizontal: AppSize.s16,
      vertical: AppSize.s12,
    );
    final defaultBorderRadius = BorderRadius.circular(AppRadius.r16);

    final isDark = context.theme.brightness == Brightness.dark;
    final defaultBackgroundColor = isDark
        ? Colors.black.withValues(alpha: AppColorValue.v50)
        : Colors.white.withValues(alpha: AppColorValue.v30);
    final defaultBarrierColor = isDark
        ? Colors.black.withValues(alpha: AppColorValue.v50)
        : Colors.white.withValues(alpha: AppColorValue.v30);

    Widget dialogChild = Column(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        if (title != null)
          Padding(
            padding: defaultTitlePadding,
            child: Text(
              title.tr(),
              textAlign: .center,
              style: const TextStyle(
                fontSize: AppFontSize.s18,
                fontWeight: AppFontWeight.bold,
              ),
            ),
          ),
        if (message != null)
          Padding(
            padding: defaultContentPadding,
            child: Text(message.tr(), textAlign: .center),
          ),
        Padding(
          padding: defaultActionsPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: actionsAlignment,
            children: actions,
          ),
        ),
      ],
    );

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "CustomDialog",
      barrierColor: barrierColor ?? defaultBarrierColor,
      transitionDuration: duration,
      pageBuilder: (_, _, _) {
        return SafeArea(
          child: Center(
            child: _BackgroundBuilder(
              color: backgroundColor ?? defaultBackgroundColor,
              blurSigma: blurSigma,
              showBackdropFilter: showBackdropFilter,
              borderRadius: borderRadius ?? defaultBorderRadius,
              child: Material(
                type: MaterialType.transparency,
                elevation: elevation ?? AppElevation.e6,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? defaultBorderRadius,
                ),
                child: dialogChild,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim, secondaryAnim, child) {
        final screenSize = MediaQuery.of(context).size;
        final targetCenter = Offset(
          screenSize.width / AppSize.s2,
          screenSize.height / AppSize.s2,
        );
        final offset = tapPosition - targetCenter;

        final scaleAnim = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim, curve: curve));
        final slideAnim = Tween<Offset>(
          begin: offset,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: curve));

        return AnimatedBuilder(
          animation: anim,
          builder: (context, child) {
            return Transform.translate(
              offset: slideAnim.value,
              child: Transform.scale(scale: scaleAnim.value, child: child),
            );
          },
          child: child,
        );
      },
    );
  }

  /// Confirmation Dialog
  static Future<T?> confirmationDialog<T>({
    required BuildContext context,
    Icon? icon,
    required String title,
    required String subTitle,
    required String confirmText,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StateWidgets.popUpDialog(
          children: [
            const Gap(AppSize.s8),
            Row(
              mainAxisAlignment: .center,
              children: [
                if (icon != null) ...[icon, const Gap(AppSize.s8)],
                Text(title.tr(), style: AppStyles.medium(), textAlign: .center),
              ],
            ),
            const Gap(AppSize.s8),
            Text(subTitle.tr(), style: AppStyles.regular(), textAlign: .center),
            const Gap(AppSize.s16),
            Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => navigator.pop(true),
                  child: Text(confirmText.tr()),
                ),
                OutlinedButton(
                  onPressed: () => navigator.pop(false),
                  child: Text(LocaleKeys.action_cancel.tr()),
                ),
              ],
            ),
            const Gap(AppSize.s8),
          ],
        );
      },
    );
  }
}

// ==== _BackgroundBuilder ===
class _BackgroundBuilder extends StatelessWidget {
  final Color color;
  final double blurSigma;
  final bool showBackdropFilter;
  final BorderRadius borderRadius;
  final Widget child;

  const _BackgroundBuilder({
    required this.color,
    required this.child,
    this.blurSigma = 32.0,
    this.showBackdropFilter = true,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    final border = Border(
      top: BorderSide(color: borderColor, width: AppSize.s1),
      left: BorderSide(color: borderColor, width: AppSize.s1),
      right: BorderSide(color: borderColor, width: AppSize.s0d65),
      bottom: BorderSide(color: borderColor, width: AppSize.s0d65),
    );

    final decoration = BoxDecoration(
      color: color.withValues(
        alpha: isDark ? AppColorValue.v50 : AppColorValue.v30,
      ),
      borderRadius: borderRadius,
      border: border,
    );

    Widget background = DecoratedBox(
      decoration: decoration,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(child: child),
      ),
    );

    if (showBackdropFilter) {
      background = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: background,
        ),
      );
    }

    return background;
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:todoon/core/resources/assets_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/generated/locale_keys.g.dart';

/// [StateWidgets] provides a centralized collection of reusable UI components
/// for different application flow states.
///
/// It includes predefined widgets for:
/// * [loading]: A standard progress indicator for data fetching.
/// * [processing]: A state for background tasks or active computations.
/// * [success]: A visual confirmation of a completed action.
/// * [empty]: A placeholder view when no data is available to display.
/// * [error]: A dedicated error view, supporting custom messages and retry actions.
///
/// The [popUpDialog] method serves as the base container for displaying these
/// states within a modal overlay.
class StateWidgets {
  /// Loading State
  static Widget loading(
    BuildContext context, {
    String? lottieName,
    double? lottieHeight,
    double? lottieWidth,
    String? message,
  }) {
    return _getItemsInColumn([
      _getLottieImage(
        lottieName ?? LottieAssets.cat_loading,
        height: lottieHeight,
        width: lottieWidth,
      ),
      if (message != null && message.isNotEmpty) _getMessage(context, message),
    ]);
  }

  /// Processing State
  static Widget processing(
    BuildContext context, {
    String? lottieName,
    double? lottieHeight,
    double? lottieWidth,
    String? message,
  }) {
    return _getItemsInColumn([
      _getLottieImage(
        lottieName ?? LottieAssets.cat_typing,
        height: lottieHeight,
        width: lottieWidth,
      ),
      if (message != null && message.isNotEmpty) _getMessage(context, message),
    ]);
  }

  /// Success State
  static Widget success(
    BuildContext context, {
    String? lottieName,
    double? lottieHeight,
    double? lottieWidth,
    String? message,
    Widget? actions,
  }) {
    return _getItemsInColumn([
      _getLottieImage(
        lottieName ?? LottieAssets.cat_idle,
        height: lottieHeight,
        width: lottieWidth,
      ),
      if (message != null && message.isNotEmpty) _getMessage(context, message),
      if (actions != null) _getActionsWidget(actions),
    ]);
  }

  /// Empty State
  static Widget empty(
    BuildContext context, {
    String? lottieName,
    double? lottieHeight,
    double? lottieWidth,
    String? message,
  }) {
    return _getItemsInColumn([
      _getLottieImage(
        lottieName ?? LottieAssets.cat_empty,
        height: lottieHeight,
        width: lottieWidth,
      ),
      if (message != null && message.isNotEmpty) _getMessage(context, message),
    ]);
  }

  /// Error State
  static Widget error(
    BuildContext context, {
    String? lottieName,
    double? lottieHeight,
    double? lottieWidth,
    String? message,
    Widget? actions,
  }) {
    return _getItemsInColumn([
      _getLottieImage(
        lottieName ?? LottieAssets.cat_error,
        height: lottieHeight,
        width: lottieWidth,
      ),
      if (message != null && message.isNotEmpty) _getMessage(context, message),
      if (actions != null) _getActionsWidget(actions),
    ]);
  }

  static Widget noRoute(BuildContext context) {
    return _getItemsInColumn([
      _getLottieImage(LottieAssets.cat_error),
      _getMessage(context, LocaleKeys.state_noRoute),
    ]);
  }

  /// PopUp Dialog
  static Widget popUpDialog({required List<Widget> children}) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r16),
          ),
          elevation: AppElevation.e3,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: theme.canvasColor,
              borderRadius: BorderRadius.circular(AppRadius.r16),
              boxShadow: [
                BoxShadow(
                  color: theme.popupMenuTheme.color ?? theme.primaryColor,
                  blurRadius: AppRadius.r16,
                  offset: const Offset(AppSize.s1, AppSize.s8),
                ),
              ],
            ),
            child: _getDialogContent(context, children),
          ),
        );
      },
    );
  }

  /// Dialog Content
  static Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: children,
    );
  }

  /// Items In Column
  static Widget _getItemsInColumn(List<Widget> children) {
    return Container(
      alignment: .center,
      constraints: BoxConstraints(minHeight: AppSize.s128),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  /// Message
  static Widget _getMessage(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppPadding.p18,
          bottom: AppPadding.p18,
          right: AppPadding.p16,
          left: AppPadding.p16,
        ),
        child: Text(
          message.tr(),
          style: AppStyles.regular(fontSize: AppFontSize.s12),
        ),
      ),
    );
  }

  /// Actions Widget
  static Widget _getActionsWidget(Widget actions) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: AppPadding.p12,
          right: AppPadding.p18,
          left: AppPadding.p18,
        ),
        child: actions,
      ),
    );
  }

  /// Lottie Image
  static Widget _getLottieImage(String name, {double? height, double? width}) {
    return SizedBox(
      height: height ?? AppSize.s100,
      width: width ?? AppSize.s100,
      child: Lottie.asset(name),
    );
  }
}

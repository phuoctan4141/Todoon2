// ignore_for_file: constant_identifier_names, must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';

import 'package:todoon/core/extensions/navigation_extension.dart';
import 'package:todoon/core/resources/assets_manager.dart';
import 'package:todoon/core/resources/consts.dart';
import 'package:todoon/core/resources/values_manager.dart';

enum StateRendererType {
  // POPUP STATES
  POPUP_LOADING_STATE,
  POPUP_ERROR_STATE,
  POPUP_SUCCESS,
  // FULL SCREEN STATES
  FULL_SCREEN_LOADING_STATE,
  FULL_SCREEN_ERROR_STATE,
  CONTENT_SCREEN_STATE, // THE UI OF THE SCREEN
  EMPTY_SCREEN_STATE, // EMPTY VIEW WHEN WE RECEIVE NO DATA FROM API SIDE FOR LIST SCREEN
}

class StateRenderer extends StatelessWidget {
  StateRendererType stateRendererType;
  String message;
  String title;
  Function? retryActionFunction;

  StateRenderer({
    super.key,
    required this.stateRendererType,
    String? message,
    String? title,
    required this.retryActionFunction,
  }) : message = message ?? 'state.loading',
       title = title ?? '';

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.POPUP_LOADING_STATE:
        return _getPopUpDialog(context, [
          _getAnimatedImage(LottieAssets.cat_loading),
        ]);
      case StateRendererType.POPUP_ERROR_STATE:
        return _getPopUpDialog(context, [
          _getAnimatedImage(LottieAssets.cat_error),
          _getMessage(context, message),
          _getRetryButton('state.ok', context),
        ]);
      case StateRendererType.POPUP_SUCCESS:
        return _getPopUpDialog(context, [
          _getAnimatedImage(LottieAssets.cat_typing),
          _getMessage(context, title),
          _getMessage(context, message),
          _getRetryButton('state.ok', context),
        ]);
      case StateRendererType.FULL_SCREEN_LOADING_STATE:
        return _getItemsInColumn([
          _getAnimatedImage(LottieAssets.cat_loading),
          _getMessage(context, message),
        ]);
      case StateRendererType.FULL_SCREEN_ERROR_STATE:
        return _getItemsInColumn([
          _getAnimatedImage(LottieAssets.cat_error),
          _getMessage(context, message),
          _getRetryButton('state.retryAgain', context),
        ]);
      case StateRendererType.CONTENT_SCREEN_STATE:
        return const SizedBox.shrink();
      case StateRendererType.EMPTY_SCREEN_STATE:
        return _getItemsInColumn([
          _getAnimatedImage(LottieAssets.cat_empty),
          _getMessage(context, message),
        ]);
    }
  }

  Widget _getPopUpDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      elevation: AppElevation.e3,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColorDark,
              blurRadius: AppRadius.r16,
              offset: const Offset(d0, AppSize.s12),
            ),
          ],
        ),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationName),
    );
  }

  Widget _getMessage(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: Text(message, style: context.text.bodyMedium).tr(),
      ),
    );
  }

  Widget _getRetryButton(String buttonTitle, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
          width: AppSize.s180,
          child: ElevatedButton(
            onPressed: () {
              if (stateRendererType ==
                  StateRendererType.FULL_SCREEN_ERROR_STATE) {
                retryActionFunction
                    ?.call(); // to call the API function again to retry
              } else {
                retryActionFunction?.call();
                context
                    .pop(); // popup state error so we need to dismiss the dialog
              }
            },
            child: Text(buttonTitle).tr(),
          ),
        ),
      ),
    );
  }

  Widget _getItemsInColumn(List<Widget> children) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

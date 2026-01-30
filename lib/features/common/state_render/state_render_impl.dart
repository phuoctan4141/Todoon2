import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:todoon/features/common/state_render/state_renderer.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();

  String getMessage();
}

// Loading State (POPUP, FULL SCREEN)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState({required this.stateRendererType, String? message})
    : message = message ?? 'state.loading';

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// error state (POPUP, FULL LOADING)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// CONTENT STATE

class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => '';

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.CONTENT_SCREEN_STATE;
}

// EMPTY STATE

class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.EMPTY_SCREEN_STATE;
}

// success state
class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => StateRendererType.POPUP_SUCCESS;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(
    BuildContext context,
    Widget contentScreenWidget,
    Function retryActionFunction,
  ) {
    // check state
    if (this is LoadingState) {
      if (getStateRendererType() == StateRendererType.POPUP_LOADING_STATE) {
        // showing popup dialog
        showPopUp(
          context,
          getStateRendererType(),
          getMessage(),
          retryActionFunction: retryActionFunction,
        );
        // return the content ui of the screen
        return contentScreenWidget;
      } else {
        // StateRendererType.FULL_SCREEN_LOADING_STATE
        return StateRenderer(
          stateRendererType: getStateRendererType(),
          message: getMessage(),
          retryActionFunction: retryActionFunction,
        );
      }
    } else if (this is ErrorState) {
      dismissDialog(context);
      if (getStateRendererType() == StateRendererType.POPUP_ERROR_STATE) {
        // showing popup dialog
        showPopUp(
          context,
          getStateRendererType(),
          getMessage(),
          retryActionFunction: retryActionFunction,
        );
        // return the content ui of the screen
        return contentScreenWidget;
      } else {
        // StateRendererType.FULL_SCREEN_ERROR_STATE
        return StateRenderer(
          stateRendererType: getStateRendererType(),
          message: getMessage(),
          retryActionFunction: retryActionFunction,
        );
      }
    } else if (this is ContentState) {
      dismissDialog(context);
      return contentScreenWidget;
    } else if (this is EmptyState) {
      return StateRenderer(
        stateRendererType: getStateRendererType(),
        message: getMessage(),
        retryActionFunction: retryActionFunction,
      );
    } else if (this is SuccessState) {
      // i should check if we are showing loading popup
      // to remove it before showing success popup
      dismissDialog(context);

      // show popup
      showPopUp(
        context,
        StateRendererType.POPUP_SUCCESS,
        getMessage(),
        title: 'state.success',
        retryActionFunction: retryActionFunction,
      );
      // return content ui of the screen
      return contentScreenWidget;
    }

    return contentScreenWidget;
  }

  void dismissDialog(BuildContext context) {
    if (_isThereCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  bool _isThereCurrentDialogShowing(BuildContext context) =>
      Navigator.of(context, rootNavigator: true).canPop();

  void showPopUp(
    BuildContext context,
    StateRendererType stateRendererType,
    String message, {
    String title = '',
    Function? retryActionFunction,
  }) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (BuildContext context) => StateRenderer(
          stateRendererType: stateRendererType,
          message: message.tr(),
          title: title.tr(),
          retryActionFunction: retryActionFunction,
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/generated/locale_keys.g.dart';
import 'package:todoon/service_locator.dart';

import 'app_state.dart';
import 'state_widgets.dart';

/// [AppStateBuilder] is a specialized [BlocConsumer] wrapper designed to handle
/// global and local UI flow states (Loading, Error, Success, etc.) automatically.
///
/// It supports two primary display modes:
/// * **PopUp Mode**: Displays state changes (like a loading spinner or error message)
///   in a non-blocking or blocking dialog over the current UI.
/// * **FullScreen Mode**: Replaces the entire body of the widget with a state-specific
///   view (e.g., a full-screen error page with a retry button).
///
/// You can customize the behavior using the `automatic...Dialog` flags or by
/// providing custom builder functions for specific states.
class AppStateBuilder<B extends StateStreamable<S>, S extends AppState>
    extends StatelessWidget {
  /// Flags for automatic PopUp
  final bool automaticLoadingDialog;
  final bool automaticProcessingDialog;
  final bool automaticEmptyDialog;
  final bool automaticErrorDialog;
  final bool automaticSuccessDialog;

  /// Custom State Widgets
  // PopUp
  final Widget Function(BuildContext context, S state)? onPopUpLoading;
  final Widget Function(BuildContext context, S state)? onPopUpProcessing;
  final Widget Function(BuildContext context, S state)? onPopUpEmpty;
  final Widget Function(BuildContext context, S state)? onPopUpError;
  final Widget Function(BuildContext context, S state)? onPopUpSuccess;
  // FullScreen
  final Widget Function(BuildContext context, S state)? onFullScreenLoading;
  final Widget Function(BuildContext context, S state)? onFullScreenProcessing;
  final Widget Function(BuildContext context, S state)? onFullScreenEmpty;
  final Widget Function(BuildContext context, S state)? onFullScreenError;
  final Widget Function(BuildContext context, S state)? onFullScreenSuccess;

  /// Callback functions
  final void Function(BuildContext context, S state)? onCancelFunction;
  final Function(BuildContext, S)? onRetryFunction;

  /// BlocConsumer params
  final bool Function(S, S)? listenWhen;
  final Function(BuildContext, S)? listener;
  final bool Function(S, S)? buildWhen;
  final Widget Function(BuildContext, S) builder;

  const AppStateBuilder({
    super.key,
    this.automaticLoadingDialog = true,
    this.automaticProcessingDialog = true,
    this.automaticEmptyDialog = true,
    this.automaticErrorDialog = true,
    this.automaticSuccessDialog = true,
    this.onPopUpLoading,
    this.onPopUpProcessing,
    this.onPopUpEmpty,
    this.onPopUpError,
    this.onPopUpSuccess,
    this.onFullScreenLoading,
    this.onFullScreenProcessing,
    this.onFullScreenEmpty,
    this.onFullScreenError,
    this.onFullScreenSuccess,
    this.onCancelFunction,
    this.onRetryFunction,
    this.listenWhen,
    this.listener,
    this.buildWhen,
    required this.builder,
  });

  /// Ensures only one dialog is open at a time
  static bool _isDialogOpen = false;

  /// Dismisses the active dialog
  void _dismissDialog(BuildContext context) {
    if (_isDialogOpen) {
      navigator.popRootNavigator();
      _isDialogOpen = false;
    }
  }

  /// Displays a PopUp dialog
  void _showPopUp(BuildContext context, Widget dialogChild) {
    _dismissDialog(context);
    _isDialogOpen = true;
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => StateWidgets.popUpDialog(children: [dialogChild]),
    );
  }

  /// Logic for handling state transitions in the Listener
  void _handleListener(BuildContext context, S state) {
    // Invoke external listener if provided
    listener?.call(context, state);

    // isFullScreen -> dismiss any existing PopUps and stop
    if (state.isFullScreen) {
      _dismissDialog(context);
      return;
    }

    switch (state.flow) {
      case .loading:
        if (!automaticLoadingDialog) return;
        final child =
            onPopUpLoading?.call(context, state) ??
            StateWidgets.loading(context, message: state.message);
        _showPopUp(context, child);

      case .processing:
        if (!automaticProcessingDialog) return;
        final child =
            onPopUpProcessing?.call(context, state) ??
            StateWidgets.processing(context, message: state.message);
        _showPopUp(context, child);

      case .empty:
        if (!automaticEmptyDialog) return;
        final child =
            onPopUpEmpty?.call(context, state) ??
            StateWidgets.empty(context, message: state.message);
        _showPopUp(context, child);

      case .error:
        if (!automaticErrorDialog) return;
        _dismissDialog(context);
        final child =
            onPopUpError?.call(context, state) ??
            StateWidgets.error(
              context,
              message: state.failure?.message ?? state.message,
              actions: onRetryFunction != null
                  ? _retryActions(context, state)
                  : _okAction(context),
            );
        _showPopUp(context, child);

      case .success:
        if (!automaticSuccessDialog) return;
        _dismissDialog(context);
        final child =
            onPopUpSuccess?.call(context, state) ??
            StateWidgets.success(
              context,
              message: state.message,
              actions: _okAction(context),
            );
        _showPopUp(context, child);

      case .content:
        // content = dismisses all open dialogs
        _dismissDialog(context);
    }
  }

  ///  Logic for handling state transitions in the Builder
  Widget _handleBuilder(BuildContext context, S state) {
    if (!state.isFullScreen) {
      // isNotFullScreen → return the primary builder
      return builder(context, state);
    }

    // FullScreen mode
    switch (state.flow) {
      case .loading:
        return onFullScreenLoading?.call(context, state) ??
            StateWidgets.loading(context, message: state.message);

      case .processing:
        return onFullScreenProcessing?.call(context, state) ??
            StateWidgets.processing(context, message: state.message);

      case .empty:
        return onFullScreenEmpty?.call(context, state) ??
            StateWidgets.empty(context, message: state.message);

      case .error:
        return onFullScreenError?.call(context, state) ??
            StateWidgets.error(
              context,
              message: state.failure?.message ?? state.message,
              actions: onRetryFunction != null
                  ? _retryActions(context, state)
                  : null,
            );

      case .success:
        return onFullScreenSuccess?.call(context, state) ??
            StateWidgets.success(context, message: state.message);

      case .content:
        return builder(context, state);
    }
  }

  /// retry Actions
  Widget _retryActions(BuildContext context, S state) {
    return Row(
      mainAxisAlignment: .center,
      mainAxisSize: .min,
      children: [
        OutlinedButton(
          onPressed: () {
            _dismissDialog(context);
            onCancelFunction?.call(context, state);
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).colorScheme.surface),
            backgroundColor: Colors.transparent,
          ),
          child: const Text(LocaleKeys.action_cancel).tr(),
        ),
        const SizedBox(width: AppSize.s8),
        ElevatedButton(
          onPressed: () => onRetryFunction!(context, state),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Text(LocaleKeys.state_retryAgain).tr(),
        ),
      ],
    );
  }

  /// ok Action
  Widget _okAction(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _dismissDialog(context),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.surface),
        backgroundColor: Colors.transparent,
      ),
      child: const Text(LocaleKeys.state_ok).tr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      // listenWhen
      listenWhen: listenWhen,
      // listener
      listener: _handleListener,
      // buildWhen
      buildWhen: buildWhen,
      // builder
      builder: _handleBuilder,
    );
  }
}

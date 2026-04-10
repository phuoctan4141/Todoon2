import 'package:equatable/equatable.dart';

import 'package:todoon/core/utils/failure.dart';

enum FlowState { loading, processing, empty, content, success, error }

class AppState extends Equatable {
  final FlowState flow;
  final bool isFullScreen;
  final Failure? failure;
  final String? message;

  const AppState({
    required this.flow,
    this.isFullScreen = false,
    this.failure,
    this.message,
  });

  AppState copyWith({
    FlowState? flow,
    bool? isFullScreen,
    Failure? failure,
    String? message,
  }) {
    return AppState(
      flow: flow ?? this.flow,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      failure: failure ?? this.failure,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [flow, isFullScreen, failure, message];
}

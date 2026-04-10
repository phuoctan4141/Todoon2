part of 'profile_cubit.dart';

class ProfileState extends AppState {
  final String displayName;
  final String email;

  const ProfileState({
    this.displayName = EMPTY,
    this.email = EMPTY,
    super.flow = .loading,
    super.isFullScreen = false,
    super.failure,
    super.message,
  });

  @override
  List<Object?> get props => [displayName, email, ...super.props];

  @override
  ProfileState copyWith({
    String? displayName,
    String? email,
    FlowState? flow,
    bool? isFullScreen,
    Failure? failure,
    String? message,
  }) {
    return ProfileState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      flow: flow ?? this.flow,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      failure: failure ?? this.failure,
      message: message ?? this.message,
    );
  }

  ProfileState loading({bool isFullScreen = true}) =>
      copyWith(flow: .loading, isFullScreen: isFullScreen);

  ProfileState processing({String? message, bool isFullScreen = false}) =>
      copyWith(flow: .processing, isFullScreen: isFullScreen, message: message);

  ProfileState content({required String displayName, required String email}) =>
      ProfileState(displayName: displayName, email: email, flow: .content);

  ProfileState error({required Failure failure, bool isFullScreen = false}) =>
      copyWith(
        flow: .error,
        isFullScreen: isFullScreen,
        failure: failure,
        message: failure.message,
      );
}

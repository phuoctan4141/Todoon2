part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  unauthenticated,
  authenticated,
  signingIn,
  signingUp,
  signingOut,
  resettingPassword,
  resetedPassword,
  changingPass,
  changedPass,
  updatingProfile,
  updatedProfile,
  error,
}

enum AuthViewMode { login, signUp, forgotPassword }

class AuthState extends AppState {
  final AuthStatus status;
  final AuthViewMode viewMode;

  const AuthState({
    super.flow = .loading,
    this.status = .unknown,
    this.viewMode = .login,
    super.isFullScreen = false,
    super.failure,
    super.message,
  });

  @override
  List<Object?> get props => [
    flow,
    status,
    viewMode,
    isFullScreen,
    failure,
    message,
  ];

  @override
  AuthState copyWith({
    FlowState? flow,
    AuthStatus? status,
    AuthViewMode? viewMode,
    bool? isFullScreen,
    Failure? failure,
    String? message,
  }) {
    return AuthState(
      flow: flow ?? this.flow,
      status: status ?? this.status,
      viewMode: viewMode ?? this.viewMode,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      failure: failure ?? this.failure,
      message: message ?? this.message,
    );
  }

  AuthState loading({bool isFullScreen = true}) => AuthState(
    flow: .loading,
    status: .unknown,
    viewMode: viewMode,
    isFullScreen: isFullScreen,
  );

  AuthState processing({
    required AuthStatus status,
    String? message,
    bool isFullScreen = false,
  }) => AuthState(
    flow: .processing,
    status: status,
    viewMode: viewMode,
    isFullScreen: isFullScreen,
    message: message ?? LocaleKeys.state_processing,
  );

  AuthState success({
    required AuthStatus status,
    String? message,
    bool isFullScreen = false,
  }) => AuthState(
    flow: .success,
    status: status,
    viewMode: viewMode,
    isFullScreen: isFullScreen,
    message: message,
  );

  AuthState content({AuthStatus? status}) => AuthState(
    flow: .content,
    status: status ?? this.status,
    viewMode: viewMode,
  );

  AuthState error({required Failure failure, bool isFullScreen = false}) =>
      AuthState(
        flow: .error,
        status: .error,
        viewMode: viewMode,
        isFullScreen: isFullScreen,
        failure: failure,
        message: failure.message,
      );

  AuthState showLogin() => copyWith(flow: .content, viewMode: .login);

  AuthState showSignUp() => copyWith(flow: .content, viewMode: .signUp);

  AuthState showForgot() => copyWith(flow: .content, viewMode: .forgotPassword);
}

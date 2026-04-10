import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/common/app_state/app_state.dart';
import 'package:todoon/generated/locale_keys.g.dart';

// import '../../../domain/usecases/change_pass_usecase.dart';
import '../../../domain/usecases/get_current_user_usecase.dart';
import '../../../domain/usecases/reset_pass_usecase.dart';
import '../../../domain/usecases/sign_in_usecase.dart';
import '../../../domain/usecases/sign_out_usecase.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
// import '../../../domain/usecases/update_profile_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final ResetPassUseCase _resetPassUseCase;
  // final ChangePassUseCase _changePassUseCase;
  // final UpdateProfileUseCase _updateProfileUseCase;

  AuthBloc({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required ResetPassUseCase resetPassUseCase,
    // required ChangePassUseCase changePassUseCase,
    // required UpdateProfileUseCase updateProfileUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _signOutUseCase = signOutUseCase,
       _resetPassUseCase = resetPassUseCase,
       //  _changePassUseCase = changePassUseCase,
       //  _updateProfileUseCase = updateProfileUseCase,
       super(AuthState()) {
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthResetPassEvent>(_onResetPass);
    // on<AuthChangePassEvent>(_onChangePass);
    // on<AuthUpdateProfileEvent>(_onUpdateProfile);
    on<AuthRefreshEvent>(_onRefresh);
    on<AuthNavigateToSignUpEvent>(_onNavigateToSignUp);
    on<AuthNavigateToForgotEvent>(_onNavigateToForgot);
    on<AuthNavigateToLoginEvent>(_onNavigateToLogin);
  }

  /// === _onCheckStatus ===
  FutureOr<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.loading(isFullScreen: true));
    final user = await _getCurrentUserUseCase.call();

    if (user != null) {
      emit(state.content(status: .authenticated));
    } else {
      emit(state.content(status: .unauthenticated));
    }
  }

  /// === _onSignIn ===
  FutureOr<void> _onSignIn(
    AuthSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.processing(status: .signingIn));

    final result = await _signInUseCase.execute(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (f) => emit(state.error(failure: f)),
      (_) => emit(
        state.success(status: .authenticated, message: LocaleKeys.auth_logS),
      ),
    );
  }

  /// === _onSignUp ===
  FutureOr<void> _onSignUp(
    AuthSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.processing(status: .signingUp));

    final result = await _signUpUseCase.execute(
      SignUpParams(email: event.email, password: event.password),
    );

    result.fold(
      (f) => emit(state.error(failure: f)),
      (_) => emit(
        state.success(status: .authenticated, message: LocaleKeys.auth_upS),
      ),
    );
  }

  /// === _onSignOut ===
  FutureOr<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.processing(status: .signingOut));
    unawaited(_signOutUseCase.execute());
    emit(state.content(status: .unauthenticated));
  }

  /// === _onResetPass ===
  FutureOr<void> _onResetPass(
    AuthResetPassEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.processing(status: .resettingPassword));

    final result = await _resetPassUseCase.execute(
      ResetPassParams(email: event.email),
    );

    result.fold(
      (f) => emit(state.error(failure: f)),
      (_) => emit(
        state.success(status: .resetedPassword, message: LocaleKeys.auth_sendS),
      ),
    );
  }

  // /// === _onChangePass ===
  // FutureOr<void> _onChangePass(
  //   AuthChangePassEvent event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(state.processing(status: .changingPass));

  //   final result = await _changePassUseCase.execute(
  //     ChangePassParams(
  //       oldPassword: event.oldPassword,
  //       newPassword: event.newPassword,
  //     ),
  //   );

  //   result.fold(
  //     (f) => emit(state.error(failure: f)),
  //     (_) => emit(
  //       state.success(status: .changedPass, message: LocaleKeys.auth_upS),
  //     ),
  //   );
  // }

  // /// === _onUpdateProfile ===
  // FutureOr<void> _onUpdateProfile(
  //   AuthUpdateProfileEvent event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(state.processing(status: .updatingProfile));

  //   final result = await _updateProfileUseCase.execute(
  //     UpdateProfileParams(displayName: event.displayName),
  //   );

  //   result.fold(
  //     (f) => emit(state.error(failure: f)),
  //     (_) => emit(
  //       state.success(status: .updatedProfile, message: LocaleKeys.auth_upS),
  //     ),
  //   );
  // }

  /// === _onRefresh ===
  FutureOr<void> _onRefresh(
    AuthRefreshEvent event,
    Emitter<AuthState> emit,
  ) async {
    await Future<void>.delayed(kRefreshDelay);
    emit(state.content());
  }

  /// === _onNavigateToSignUp ===
  FutureOr<void> _onNavigateToSignUp(
    AuthNavigateToSignUpEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.showSignUp());
  }

  /// === _onNavigateToForgot ===
  FutureOr<void> _onNavigateToForgot(
    AuthNavigateToForgotEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.showForgot());
  }

  /// === _onNavigateToLogin ===
  FutureOr<void> _onNavigateToLogin(
    AuthNavigateToLoginEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.showLogin());
  }
}

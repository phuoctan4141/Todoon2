import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoon/core/services/background/background_service.dart';

import 'package:todoon/features/auth/repositories/auth_repository.dart';
import 'package:todoon/features/common/state_render/state_render_impl.dart';
import 'package:todoon/features/common/state_render/state_renderer.dart';

class AuthProviders extends ChangeNotifier {
  final AuthRepository _repository;
  final BackgroundService _backgroundService = BackgroundService();
  late final StreamSubscription _UserSub;

  AuthProviders(this._repository) {
    _listenAuthState();
  }

  FlowState _state = ContentState();
  FlowState get state => _state;

  AuthViewType _viewType = AuthViewType.login;
  AuthViewType get viewType => _viewType;

  User? _user;
  User? get user => _user;

  void _listenAuthState() {
    _UserSub = _repository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign In func
  Future<void> login(String email, String password) async {
    _state = LoadingState(
      stateRendererType: StateRendererType.POPUP_LOADING_STATE,
    );
    notifyListeners();

    // login func
    final result = await _repository.handleSignIn(
      email: email,
      password: password,
    );
    result.fold(
      (failure) {
        _state = ErrorState(
          StateRendererType.POPUP_ERROR_STATE,
          failure.message,
        );
      },
      (_) {
        _state = SuccessState('auth.logS');
      },
    );
    notifyListeners();
  }

  // Sign out func
  void logout() async {
    _repository.handleSignOut();
    _backgroundService.stopBackgroundService();
    _state = SuccessState('auth.outS');
    notifyListeners();
  }

  // Sign Up func
  Future<void> signUp({required String email, required String password}) async {
    _state = LoadingState(
      stateRendererType: StateRendererType.POPUP_LOADING_STATE,
    );
    notifyListeners();

    // signup func
    final result = await _repository.handleSignUp(
      email: email,
      password: password,
    );
    result.fold(
      (failure) {
        _state = ErrorState(
          StateRendererType.POPUP_ERROR_STATE,
          failure.message,
        );
      },
      (_) {
        _state = SuccessState('auth.upS');
      },
    );
    notifyListeners();
  }

  // ForgotPass func
  Future<void> sendPasswordResetEmail(String email) async {
    _state = LoadingState(
      stateRendererType: StateRendererType.POPUP_LOADING_STATE,
    );
    notifyListeners();

    // send func
    final result = await _repository.handleResetPassword(email);
    result.fold(
      (failure) {
        _state = ErrorState(
          StateRendererType.POPUP_ERROR_STATE,
          failure.message,
        );
      },
      (_) {
        _state = SuccessState('auth.sendS');
        _viewType = AuthViewType.login;
      },
    );
    notifyListeners();
  }

  void showLogin() {
    _viewType = AuthViewType.login;
    notifyListeners();
  }

  void showSignUp() {
    _viewType = AuthViewType.signup;
    notifyListeners();
  }

  void showForgotPassword() {
    _viewType = AuthViewType.forgetPassword;
    notifyListeners();
  }

  bool handleBack() {
    if (_viewType != AuthViewType.login) {
      _viewType = AuthViewType.login;
      notifyListeners();
      return false;
    }
    return true;
  }

  void resetState() {
    if (_state.getStateRendererType() !=
        StateRendererType.CONTENT_SCREEN_STATE) {
      _state = ContentState();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _UserSub.cancel();
    super.dispose();
  }
}

enum AuthViewType { login, signup, forgetPassword }

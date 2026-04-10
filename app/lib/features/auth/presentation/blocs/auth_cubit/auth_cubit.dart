import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/features/auth/domain/usecases/auth_state_changes_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthStateChangesUseCase _authStateChanges;
  StreamSubscription<User?>? _sub;

  AuthCubit({required AuthStateChangesUseCase authStateChanges})
    : _authStateChanges = authStateChanges,
      super(Unknown()) {
    _listenAuth();
  }

  bool _isFirstEmission = true;

  void _listenAuth() {
    _sub = _authStateChanges().listen((user) async {
      if (_isFirstEmission) {
        _isFirstEmission = false;
        await Future.delayed(kSplashDelay);
      }

      if (user == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated());
      }
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

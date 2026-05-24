import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:todoon/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:todoon/common/app_state/app_state.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserUseCase _getUserUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit({
    required GetUserUseCase getUserUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  }) : _getUserUseCase = getUserUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       super(const ProfileState()) {
    _userSubscription = _getUserUseCase.call().listen((user) {
      if (user == null) {
        emit(state.error(failure: DataSource.UNAUTHORIZED.getFailure()));
      } else {
        emit(
          state.content(
            displayName: user.displayName.orEmpty(),
            email: user.email.orEmpty(),
          ),
        );
      }
    });
  }

  late final StreamSubscription<User?> _userSubscription;

  /// === updateProfile ===
  FutureOr<void> updateProfile(String displayName) async {
    if (displayName == state.displayName) {
      return;
    }

    emit(state.processing(message: EMPTY));
    final result = await _updateProfileUseCase.execute(
      UpdateProfileParams(displayName: displayName),
    );
    result.fold(
      (failure) => emit(state.error(failure: failure)),
      (_) => emit(state.content(displayName: displayName, email: state.email)),
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

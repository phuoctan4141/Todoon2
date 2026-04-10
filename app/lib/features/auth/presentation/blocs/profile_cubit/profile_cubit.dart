import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:todoon/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:todoon/features/common/app_state/app_state.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       super(const ProfileState());

  /// === getCurrentUser ===
  FutureOr<void> getCurrentUser() async {
    emit(state.loading());
    final user = await _getCurrentUserUseCase.call();
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
  }

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
}

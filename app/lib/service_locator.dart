import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:todoon/core/services/firebase/firebase_auth_service.dart';
import 'package:todoon/core/services/navigation/navigation_service.dart';
import 'package:todoon/core/services/network/network_info.dart';
import 'package:todoon/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:todoon/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:todoon/features/auth/domain/repositories/auth_repository.dart';
import 'package:todoon/features/auth/domain/usecases/auth_state_changes_usecase.dart';
import 'package:todoon/features/auth/domain/usecases/change_pass_usecase.dart';
import 'package:todoon/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:todoon/features/auth/domain/usecases/reset_pass_usecase.dart';
import 'package:todoon/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:todoon/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:todoon/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:todoon/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:todoon/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:todoon/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:todoon/features/auth/presentation/blocs/profile_cubit/profile_cubit.dart';

final sl = GetIt.instance;
final NavigationService navigator = NavigationService.instance;

Future<void> initAppModule() async {
  /// === Core ===
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnectionChecker.instance),
  );

  /// === Firebase ===
  sl.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthService()..initEmulator(emulatorHost: '192.168.1.3'),
  );

  /// == LocalDatasource ===

  /// === RemoteDatasource ===
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(authService: sl.get()),
  );

  /// === Repositories ===
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl.get(), networkInfo: sl.get()),
  );
}

void initAuthModule() {
  /// === UseCases ===
  sl.registerFactory<AuthStateChangesUseCase>(
    () => AuthStateChangesUseCase(repository: sl.get()),
  );
  sl.registerFactory<ChangePassUseCase>(
    () => ChangePassUseCase(repository: sl.get()),
  );
  sl.registerFactory<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(repository: sl.get()),
  );
  sl.registerFactory<ResetPassUseCase>(
    () => ResetPassUseCase(repository: sl.get()),
  );
  sl.registerFactory<SignInUseCase>(() => SignInUseCase(repository: sl.get()));
  sl.registerFactory<SignOutUseCase>(
    () => SignOutUseCase(repository: sl.get()),
  );
  sl.registerFactory<SignUpUseCase>(() => SignUpUseCase(repository: sl.get()));
  sl.registerFactory<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(repository: sl.get()),
  );

  /// === Blocs ===
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      getCurrentUserUseCase: sl.get(),
      signInUseCase: sl.get(),
      signUpUseCase: sl.get(),
      signOutUseCase: sl.get(),
      resetPassUseCase: sl.get(),
      // changePassUseCase: sl.get(),
      // updateProfileUseCase: sl.get(),
    ),
  );

  sl.registerFactory<AuthCubit>(() => AuthCubit(authStateChanges: sl.get()));

  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getCurrentUserUseCase: sl.get(),
      updateProfileUseCase: sl.get(),
    ),
  );
}

void resetModule() {
  sl.reset(dispose: false);
  initAuthModule();
}

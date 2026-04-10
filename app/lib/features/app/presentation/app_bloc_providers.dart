import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoon/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:todoon/service_locator.dart';

class AppBlocProviders extends StatelessWidget {
  final Widget child;
  const AppBlocProviders({super.key, required this.child});

  @override
  Widget build(_) {
    return MultiBlocProvider(
      providers: [BlocProvider(lazy: true, create: (_) => sl.get<AuthCubit>())],
      child: child,
    );
  }
}

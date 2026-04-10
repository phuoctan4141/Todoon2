import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoon/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:todoon/routes/route_names.dart';
import 'package:todoon/service_locator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                navigator.pushNamed(RouteNames.profile);
              },
              child: const Text('Profile'),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(AuthSignOutEvent());
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}

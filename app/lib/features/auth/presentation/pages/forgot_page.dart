import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:todoon/features/common/app_state/app_state_builder.dart';
import 'package:todoon/features/common/widgets/bgr_image.dart';
import 'package:todoon/service_locator.dart';

import '../views/forgot_view.dart';

class ForgotPage extends StatelessWidget {
  const ForgotPage({super.key});

  /// === _handleForgot ==
  void _handleForgot(BuildContext context, String email) async {
    BlocProvider.of<AuthBloc>(context).add(AuthResetPassEvent(email: email));
  }

  /// === _navigateToBack ===
  void _navigateToBack() {
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: BgrImage(
        child: BlocProvider(
          lazy: false,
          create: (_) => sl.get<AuthBloc>()..add(AuthNavigateToForgotEvent()),
          child: AppStateBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) =>
                previous.viewMode != current.viewMode,
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: Durations.medium3,
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: switch (state.viewMode) {
                  .forgotPassword => ForgotView(
                    key: ValueKey('forgot'),
                    onforgot: (email) =>
                        _handleForgot(context, email.orEmpty()),
                    onBack: _navigateToBack,
                  ),
                  _ => const SizedBox.shrink(key: ValueKey('empty')),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

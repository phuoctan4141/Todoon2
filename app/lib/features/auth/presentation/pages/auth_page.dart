import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/strings_manager.dart';
import 'package:todoon/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:todoon/common/app_state/app_state_builder.dart';
import 'package:todoon/common/widgets/bgr_image.dart';
import 'package:todoon/routes/route_names.dart';
import 'package:todoon/service_locator.dart';

import '../views/forgot_view.dart';
import '../views/login_view.dart';
import '../views/signup_view.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  /// === _handleLogin ===
  void _handleLogin(BuildContext context, String email, String password) async {
    BlocProvider.of<AuthBloc>(
      context,
    ).add(AuthSignInEvent(email: email, password: password));
  }

  /// === _handleSignUp ===
  void _handleSignUp(BuildContext context, String email, String password) {
    BlocProvider.of<AuthBloc>(
      context,
    ).add(AuthSignUpEvent(email: email, password: password));
  }

  /// === _handleForgot ==
  void _handleForgot(BuildContext context, String email) async {
    BlocProvider.of<AuthBloc>(context).add(AuthResetPassEvent(email: email));
  }

  /// === _navigateToLogin ===
  void _navigateToLogin(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthNavigateToLoginEvent());
  }

  /// === _navigateToSignUp ===
  void _navigateToSignUp(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthNavigateToSignUpEvent());
  }

  /// === _navigateToForget ===
  void _navigateToForget(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthNavigateToForgotEvent());
  }

  /// === _navigateToTermsAndPrivacy ===
  void _navigateToTermsAndPrivacy(BuildContext context) {
    navigator.pushNamed(RouteNames.termsAndPrivacy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: BgrImage(
        isFill: true,
        child: BlocProvider(
          lazy: false,
          create: (context) => sl.get<AuthBloc>()..add(AuthCheckStatus()),
          child: AppStateBuilder<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                previous.status != current.status ||
                previous.flow != current.flow,
            listener: (context, state) {
              debugPrint(
                AppStrings.info(
                  tag: 'AuthPage',
                  message: 'AuthPage listener: ${state.flow} ${state.status}',
                ),
              );

              if (state.flow == .error) {
                debugPrint(
                  AppStrings.error(
                    tag: 'AuthPage',
                    message:
                        'AuthPage listener: ${state.error} ${state.message}',
                  ),
                );
              }

              if (state.flow == .success || state.flow == .error) {
                BlocProvider.of<AuthBloc>(context).add(AuthRefreshEvent());
              }
            },
            buildWhen: (previous, current) =>
                previous.flow != current.flow ||
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
                  .login => LoginView(
                    key: ValueKey('login'),
                    onSignIn: (email, password) => _handleLogin(
                      context,
                      email.orEmpty(),
                      password.orEmpty(),
                    ),
                    onForget: () => _navigateToForget(context),
                    onSignUp: () => _navigateToSignUp(context),
                  ),
                  .signUp => SignUpView(
                    key: ValueKey('signup'),
                    onSignUp: (String? email, String? password) =>
                        _handleSignUp(
                          context,
                          email.orEmpty(),
                          password.orEmpty(),
                        ),
                    onSignIn: () => _navigateToLogin(context),
                    onTermsAndPrivacy: () =>
                        _navigateToTermsAndPrivacy(context),
                  ),
                  .forgotPassword => ForgotView(
                    key: ValueKey('forgot'),
                    onforgot: (email) =>
                        _handleForgot(context, email.orEmpty()),
                    onSignIn: () => _navigateToLogin(context),
                  ),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

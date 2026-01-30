import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todoon/features/auth/providers/auth_providers.dart';
import 'package:todoon/features/auth/pages/components/login_view.dart';
import 'package:todoon/features/auth/pages/components/signup_view.dart';
import 'package:todoon/features/auth/pages/components/forgot_view.dart';
import 'package:todoon/features/common/state_render/state_render_impl.dart';
import 'package:todoon/features/common/widgets/background_image_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviders>(
      builder: (context, authProvider, _) {
        return RepaintBoundary(
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              final shouldPop = authProvider.handleBack();
              shouldPop ? authProvider.showLogin() : null;
            },
            child: BackgroundImageWidget(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: authProvider.state.getScreenWidget(
                  context,
                  _buildBody(context, authProvider),
                  () {
                    authProvider.resetState();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AuthProviders authProvider) {
    return AnimatedSwitcher(
      duration: Durations.medium3,
      child: switch (authProvider.viewType) {
        AuthViewType.login => const LoginView(key: ValueKey('login')),

        AuthViewType.signup => const SignUpView(key: ValueKey('signup')),

        AuthViewType.forgetPassword => ForgotView(
          key: ValueKey('forgetPassword'),
        ),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:todoon/core/resources/consts.dart';

import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/auth/providers/auth_providers.dart';
import 'package:todoon/features/auth/widgets/login_form.dart';
import 'package:todoon/features/common/widgets/glass/glass_container.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void __handleLogin(BuildContext context) async {
    final authProvider = context.read<AuthProviders>();
    await authProvider.login(
      _emailController.text.trim(),
      _passController.text,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildTopWidget(context), _buildForm(context)]);
  }

  Widget _buildTopWidget(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Positioned(
      left: d0,
      right: d0,
      top: height / d9,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: AppPadding.p36),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Text(
                'auth.welcome',
                style: TextStyle(
                  fontSize: AppFontSize.s27,
                  fontWeight: FontWeight.w500,
                ),
              ).tr(),
              Text(
                'ToDoon',
                style: TextStyle(
                  fontSize: AppFontSize.s39,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Positioned(
      left: d0,
      right: d0,
      bottom: d0,
      child: SafeArea(
        child: GlassContainer(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.r24),
            topRight: Radius.circular(AppRadius.r24),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * d0d65,
          ),
          child: LoginForm(
            emailController: _emailController,
            passController: _passController,
            onSignIn: () => __handleLogin(context),
            onForget: () => context.read<AuthProviders>().showForgotPassword(),
            onSignUp: () => context.read<AuthProviders>().showSignUp(),
          ),
        ),
      ),
    );
  }
}

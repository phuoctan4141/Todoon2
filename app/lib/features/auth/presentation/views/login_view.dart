import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/strings_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/common/widgets/glass/glass_container.dart';
import 'package:todoon/generated/locale_keys.g.dart';

import '../widgets/login_form.dart';

class LoginView extends StatefulWidget {
  final Function(String? email, String? password) onSignIn;
  final VoidCallback onForget;
  final VoidCallback onSignUp;
  const LoginView({
    super.key,
    required this.onSignIn,
    required this.onForget,
    required this.onSignUp,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // /// === _handleLogin ===
  // void _handleLogin(BuildContext context) async {
  //   BlocProvider.of<AuthBloc>(context).add(
  //     AuthSignInEvent(
  //       email: _emailController.text.trim(),
  //       password: _passController.text,
  //     ),
  //   );
  // }

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
      left: dZERO,
      right: dZERO,
      top: height / AppSize.s9,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: AppPadding.p36),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Text(
                LocaleKeys.auth_welcome.tr(),
                style: AppStyles.medium(fontSize: AppFontSize.s28),
              ),
              Text(
                AppStrings.appName,
                style: AppStyles.bold(fontSize: AppFontSize.s36),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Positioned(
      left: dZERO,
      right: dZERO,
      bottom: dZERO,
      child: SafeArea(
        child: GlassContainer(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.r24),
            topRight: Radius.circular(AppRadius.r24),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * AppSize.s0d65,
          ),
          child: LoginForm(
            emailController: _emailController,
            passController: _passController,
            onSignIn: () => widget.onSignIn.call(
              _emailController.text.trim(),
              _passController.text,
            ),
            onForget: widget.onForget,
            onSignUp: widget.onSignUp,
          ),
        ),
      ),
    );
  }
}

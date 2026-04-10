import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/strings_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/auth/presentation/widgets/signup_form.dart';
import 'package:todoon/features/common/widgets/glass/glass_container.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class SignUpView extends StatefulWidget {
  final Function(String? email, String? password) onSignUp;
  final VoidCallback onSignIn;
  const SignUpView({super.key, required this.onSignUp, required this.onSignIn});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _conPassController = TextEditingController();

  // /// === _handleSignUp ===
  // void _handleSignUp(BuildContext context) {
  //   BlocProvider.of<AuthBloc>(context).add(
  //     AuthSignUpEvent(
  //       email: _emailController.text.trim(),
  //       password: _passController.text,
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _conPassController.dispose();
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
                LocaleKeys.auth_signUp.tr(),
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
          child: SignUpForm(
            emailController: _emailController,
            passController: _passController,
            conPassController: _conPassController,
            onSignUp: () => widget.onSignUp.call(
              _emailController.text.trim(),
              _passController.text,
            ),
            onSignIn: widget.onSignIn,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/auth/presentation/widgets/signup_form.dart';
import 'package:todoon/common/widgets/glass/glass_container.dart';

class SignUpView extends StatefulWidget {
  final Function(String? email, String? password) onSignUp;
  final VoidCallback onSignIn;
  final VoidCallback onTermsAndPrivacy;
  const SignUpView({
    super.key,
    required this.onSignUp,
    required this.onSignIn,
    required this.onTermsAndPrivacy,
  });

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _conPassController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _conPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildForm(context)]);
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
          child: SignUpForm(
            emailController: _emailController,
            passController: _passController,
            conPassController: _conPassController,
            onSignUp: () => widget.onSignUp.call(
              _emailController.text.trim(),
              _passController.text,
            ),
            onSignIn: widget.onSignIn,
            onTermsAndPrivacy: widget.onTermsAndPrivacy,
          ),
        ),
      ),
    );
  }
}

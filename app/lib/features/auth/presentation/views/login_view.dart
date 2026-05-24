import 'package:flutter/material.dart';

import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/widgets/glass/glass_container.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
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

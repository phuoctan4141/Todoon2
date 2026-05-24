import 'package:flutter/material.dart';

import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/widgets/glass/glass_container.dart';

import '../widgets/forgot_form.dart';

class ForgotView extends StatefulWidget {
  final Function(String? email) onforgot;
  final VoidCallback onSignIn;

  const ForgotView({super.key, required this.onforgot, required this.onSignIn});

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
      child: GlassContainer(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r24),
          topRight: Radius.circular(AppRadius.r24),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
        child: SafeArea(
          child: ForgotForm(
            emailController: _emailController,
            onSubmit: () => widget.onforgot.call(_emailController.text.trim()),
            onSignIn: widget.onSignIn,
          ),
        ),
      ),
    );
  }
}

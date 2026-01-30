import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/extensions/navigation_extension.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/auth/providers/auth_providers.dart';
import 'package:todoon/features/auth/widgets/forgot_form.dart';
import 'package:todoon/features/common/widgets/glass/glass_container.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({super.key});

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  final TextEditingController _emailController = TextEditingController();

  void __handleSubmit(BuildContext context) async {
    final authProvider = context.read<AuthProviders>();
    await authProvider.sendPasswordResetEmail(_emailController.text.trim());
  }

  void _handleBack(BuildContext context) {
    final canPop = context.read<AuthProviders>().handleBack();
    if (canPop) context.pop();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(children: [_buildTopWidget(context), _buildForm(context)]),
    );
  }

  Widget _buildTopWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppPadding.p36, bottom: AppPadding.p24),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Align(
            alignment: .centerLeft,
            child: IconButton(
              onPressed: () => _handleBack(context),
              iconSize: AppSize.s32,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: context.colors.onTertiaryContainer,
              ),
            ),
          ),
          Text(
            'auth.back',
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
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: GlassContainer(
        child: ForgotForm(
          emailController: _emailController,
          onSubmit: () => __handleSubmit(context),
        ),
      ),
    );
  }
}

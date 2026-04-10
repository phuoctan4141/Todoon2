import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/icons_manager.dart';
import 'package:todoon/core/resources/strings_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/common/widgets/glass/glass_container.dart';
import 'package:todoon/generated/locale_keys.g.dart';

import '../widgets/forgot_form.dart';

class ForgotView extends StatefulWidget {
  final Function(String? email) onforgot;
  final VoidCallback onBack;

  const ForgotView({super.key, required this.onforgot, required this.onBack});

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  final TextEditingController _emailController = TextEditingController();

  // /// === _handleSubmit ==
  // void _handleSubmit(BuildContext context) async {
  //   BlocProvider.of<AuthBloc>(
  //     context,
  //   ).add(AuthResetPassEvent(email: _emailController.text.trim()));
  // }

  // /// === _handleBack ===
  // void _handleBack(BuildContext context) {
  //   final authB = BlocProvider.of<AuthBloc>(context);

  //   if (authB.state.status == .authenticated) {
  //     navigator.pop();
  //   }

  //   BlocProvider.of<AuthBloc>(context).add(AuthNavigateToLoginEvent());
  // }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [_buildTopWidget(context), _buildForm(context)],
        ),
      ),
    );
  }

  Widget _buildTopWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppPadding.p36, bottom: AppPadding.p24),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(
            LocaleKeys.auth_back.tr(),
            style: AppStyles.medium(fontSize: AppFontSize.s28),
          ),
          Text(
            AppStrings.appName,
            style: AppStyles.bold(fontSize: AppFontSize.s36),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: GlassContainer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: AppPadding.p8),
              alignment: .center,
              child: IconButton(
                onPressed: widget.onBack,
                iconSize: AppSize.s32,
                icon: Icon(
                  AppIcons.back,
                  color: context.colors.onTertiaryContainer,
                ),
              ),
            ),
            ForgotForm(
              emailController: _emailController,
              onSubmit: () =>
                  widget.onforgot.call(_emailController.text.trim()),
            ),
          ],
        ),
      ),
    );
  }
}

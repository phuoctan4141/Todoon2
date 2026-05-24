import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/widgets/custom_text_form_field.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passController;
  final VoidCallback onSignIn;
  final VoidCallback onForget;
  final VoidCallback onSignUp;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passController,
    required this.onSignIn,
    required this.onForget,
    required this.onSignUp,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  late final ObscureController _obscureController = ObscureController();

  @override
  void initState() {
    super.initState();
    _passFocus.addListener(_handlePassFocus);
  }

  void _handlePassFocus() {
    if (_passFocus.hasFocus) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Durations.short1,
        curve: Curves.easeOut,
      );
    });
  }

  void _handleSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      _obscureController.hide();
      Focus.maybeOf(context)?.unfocus();
      widget.onSignIn.call();
    }
  }

  void _handleDone() {
    FocusScope.of(context).unfocus();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _passFocus.removeListener(_handlePassFocus);
    _emailFocus.dispose();
    _passFocus.dispose();
    _scrollController.dispose();
    _obscureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(AppSize.s16),

                /// Title
                Text(
                  LocaleKeys.auth_signIn.tr(),
                  style: AppStyles.medium(fontSize: AppFontSize.s28),
                ),

                const Gap(AppSize.s32),

                /// Email
                EmailTextFormField(
                  controller: widget.emailController,
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passFocus),
                ),

                const Gap(AppSize.s32),

                /// Password
                PasswordTextFormField(
                  controller: widget.passController,
                  focusNode: _passFocus,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleDone(),
                  obscureController: _obscureController,
                ),

                const Gap(AppSize.s12),

                /// Forget password
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: widget.onForget,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.s8,
                      ),
                      child: Text(
                        LocaleKeys.auth_forget.tr(),
                        style: AppStyles.bold(
                          color: colorScheme.onSecondaryContainer,
                          fontSize: AppFontSize.s14,
                        ),
                      ),
                    ),
                  ),
                ),

                const Gap(AppSize.s32),

                /// Sign in button
                SizedBox(
                  width: double.infinity,
                  height: AppSize.s64,
                  child: ElevatedButton(
                    onPressed: _handleSignIn,
                    child: Text(
                      LocaleKeys.auth_signIn.tr(),
                      style: AppStyles.medium(fontSize: AppFontSize.s18),
                    ),
                  ),
                ),

                const Gap(AppSize.s16),

                /// Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.auth_DntAcc.tr(),
                      style: AppStyles.medium(fontSize: AppFontSize.s14),
                    ),
                    const Gap(AppSize.s4),
                    InkWell(
                      onTap: widget.onSignUp,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      child: Text(
                        LocaleKeys.auth_signUp.tr(),
                        style: AppStyles.bold(
                          color: colorScheme.onSecondaryContainer,
                          fontSize: AppFontSize.s16,
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(AppSize.s16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

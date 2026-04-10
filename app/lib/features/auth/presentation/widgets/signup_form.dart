import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/common/widgets/custom_text_form_field.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passController;
  final TextEditingController conPassController;
  final VoidCallback onSignUp;
  final VoidCallback onSignIn;

  const SignUpForm({
    super.key,
    required this.emailController,
    required this.passController,
    required this.conPassController,
    required this.onSignUp,
    required this.onSignIn,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _conPassFocus = FocusNode();

  late final ObscureController _passObscureController = ObscureController();

  late final ObscureController _conPassObscureController = ObscureController();

  @override
  void initState() {
    super.initState();
    _conPassFocus.addListener(_handleConfirmFocus);
  }

  void _handleConfirmFocus() {
    if (_conPassFocus.hasFocus) {
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

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      Focus.maybeOf(context)?.unfocus();
      widget.onSignUp.call();
    }
  }

  void _handleDone() {
    FocusScope.of(context).unfocus();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _conPassFocus.removeListener(_handleConfirmFocus);

    _emailFocus.dispose();
    _passFocus.dispose();
    _conPassFocus.dispose();
    _scrollController.dispose();

    _passObscureController.dispose();
    _conPassObscureController.dispose();

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
                  LocaleKeys.auth_signUp.tr(),
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
                  textInputAction: TextInputAction.next,
                  obscureController: _passObscureController,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_conPassFocus),
                ),

                const Gap(AppSize.s32),

                /// Confirm Password
                ConfirmPasswordTextFormField(
                  controller: widget.conPassController,
                  passwordController: widget.passController,
                  focusNode: _conPassFocus,
                  textInputAction: TextInputAction.done,
                  obscureController: _conPassObscureController,
                  onFieldSubmitted: (_) => _handleDone(),
                ),

                const Gap(AppSize.s32),

                /// Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: AppSize.s64,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    child: Text(
                      LocaleKeys.auth_signUp.tr(),
                      style: AppStyles.medium(fontSize: AppFontSize.s18),
                    ),
                  ),
                ),

                const Gap(AppSize.s16),

                /// Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.auth_haveAcc.tr(),
                      style: AppStyles.medium(fontSize: AppFontSize.s14),
                    ),
                    const Gap(AppSize.s4),
                    InkWell(
                      onTap: widget.onSignIn,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      child: Text(
                        LocaleKeys.auth_signIn.tr(),
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

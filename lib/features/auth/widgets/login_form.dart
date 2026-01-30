import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/common/widgets/custom_text_form_field.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passController;
  final void Function() onSignIn;
  final void Function() onForget;
  final void Function() onSignUp;

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

  @override
  void initState() {
    super.initState();

    _passFocus.addListener(() {
      if (_passFocus.hasFocus) {
        Future.delayed(Durations.short1, () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Durations.short1,
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: .center,
            mainAxisSize: .max,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppPadding.p16),
                child: Text(
                  'auth.signIn',
                  style: TextStyle(
                    fontSize: AppFontSize.s27,
                    fontWeight: FontWeight.w500,
                  ),
                ).tr(),
              ),
              const Gap(AppSize.s32),

              // Email Field
              EmailTextFormField(
                controller: widget.emailController,
                focusNode: _emailFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passFocus),
              ),
              const Gap(AppSize.s32),

              // Password Field
              PasswordTextFormField(
                controller: widget.passController,
                focusNode: _passFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();

                  Future.delayed(Durations.short1, () {
                    if (_scrollController.hasClients && mounted) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Durations.short1,
                        curve: Curves.easeOut,
                      );
                    }
                  });
                },
              ),
              const Gap(AppSize.s12),
              // Forget Password?
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {
                      widget.onForget();
                    },
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: Text(
                      'auth.forget'.tr(),
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                        fontSize: AppFontSize.s13,
                        fontWeight: FontWeight.w700,
                      ),
                    ).tr(),
                  ),
                  Gap(AppSize.s8),
                ],
              ),
              const Gap(AppSize.s32),

              // SignIn Button
              SizedBox(
                width: AppSize.s352,
                height: AppSize.s64,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSignIn.call();
                    }
                  },
                  child: Text(
                    'auth.signIn',
                    style: TextStyle(
                      fontSize: AppFontSize.s18,
                      fontWeight: FontWeight.w500,
                    ),
                  ).tr(),
                ),
              ),
              const Gap(AppSize.s16),
              // SignUP Row
              Row(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    'auth.DntAcc'.tr(),
                    style: TextStyle(
                      fontSize: AppFontSize.s13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSize.s4),
                  InkWell(
                    onTap: () {
                      widget.onSignUp.call();
                    },
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: Text(
                      'auth.signUp',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                        fontSize: AppFontSize.s15,
                        fontWeight: FontWeight.w700,
                      ),
                    ).tr(),
                  ),
                ],
              ),
              const Gap(AppSize.s16),
            ],
          ),
        ),
      ),
    );
  }
}

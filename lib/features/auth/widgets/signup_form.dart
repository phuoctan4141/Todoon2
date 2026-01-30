import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/common/widgets/custom_text_form_field.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passController;
  final TextEditingController conPassController;
  final void Function() onSignUp;
  final void Function() onSignIn;

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

  @override
  void initState() {
    super.initState();

    _conPassFocus.addListener(() {
      if (_conPassFocus.hasFocus) {
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
    _conPassFocus.dispose();
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
            mainAxisSize: .min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppPadding.p16),
                child: Text(
                  'auth.signUp',
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
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_conPassFocus),
              ),
              const Gap(AppSize.s32),

              // Confirm Password Field
              ConfirmPasswordTextFormField(
                passwordcontroller: widget.passController,
                controller: widget.conPassController,
                focusNode: _conPassFocus,
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
              const Gap(AppSize.s32),

              // SignUp Button
              SizedBox(
                width: AppSize.s352,
                height: AppSize.s64,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSignUp.call();
                    }
                  },
                  child: Text(
                    'auth.signUp',
                    style: TextStyle(
                      fontSize: AppFontSize.s18,
                      fontWeight: FontWeight.w500,
                    ),
                  ).tr(),
                ),
              ),
              const Gap(AppSize.s16),

              // SignIn Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'auth.haveAcc'.tr(),
                    style: TextStyle(
                      fontSize: AppFontSize.s13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSize.s4),
                  InkWell(
                    onTap: () {
                      widget.onSignIn.call();
                    },
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: Text(
                      'auth.signIn',
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

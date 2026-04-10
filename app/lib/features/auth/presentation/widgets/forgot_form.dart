import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/resources/styles_manager.dart';

import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/common/widgets/custom_text_form_field.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class ForgotForm extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onSubmit;

  const ForgotForm({
    super.key,
    required this.emailController,
    required this.onSubmit,
  });

  static final _formKey = GlobalKey<FormState>();

  static final _emailFocus = FocusNode();

  void handleSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      Focus.maybeOf(context)?.unfocus();
      onSubmit.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Title
                Text(
                  LocaleKeys.auth_forgot.tr(),
                  style: AppStyles.medium(fontSize: AppFontSize.s28),
                ),

                const Gap(AppSize.s32),

                /// Email
                EmailTextFormField(
                  controller: emailController,
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => handleSubmit(context),
                ),

                const Gap(AppSize.s32),

                /// Submit Button
                SizedBox(
                  width: double.infinity,
                  height: AppSize.s64,
                  child: ElevatedButton(
                    onPressed: () => handleSubmit(context),
                    child: Text(
                      LocaleKeys.auth_submuit.tr(),
                      style: AppStyles.medium(fontSize: AppFontSize.s18),
                    ),
                  ),
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/common/widgets/custom_text_form_field.dart';

class ForgotForm extends StatefulWidget {
  final TextEditingController emailController;
  final void Function() onSubmit;

  const ForgotForm({
    super.key,
    required this.emailController,
    required this.onSubmit,
  });

  @override
  State<ForgotForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppPadding.p16),
              child: Text(
                'auth.forgot',
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
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
            const Gap(AppSize.s32),

            // SignIn Button
            SizedBox(
              width: AppSize.s352,
              height: AppSize.s64,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit.call();
                  }
                },
                child: Text(
                  'auth.submuit',
                  style: TextStyle(
                    fontSize: AppFontSize.s18,
                    fontWeight: FontWeight.w500,
                  ),
                ).tr(),
              ),
            ),
            const Gap(AppSize.s16),
          ],
        ),
      ),
    );
  }
}

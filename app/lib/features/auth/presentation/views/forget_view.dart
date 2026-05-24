import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/widgets/custom_close_button.dart';
import 'package:todoon/common/widgets/custom_text_form_field.dart';
import 'package:todoon/common/widgets/glass/glass_container.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class ForgetView extends StatefulWidget {
  final Function(String email) onSubmit;
  const ForgetView({super.key, required this.onSubmit});

  @override
  State<ForgetView> createState() => _ForgetViewState();
}

class _ForgetViewState extends State<ForgetView> {
  late final TextEditingController _emailController;
  late final FocusNode _focusNode;

  static final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void handleSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      Focus.maybeOf(context)?.unfocus();
      widget.onSubmit.call(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppRadius.r24),
        topRight: Radius.circular(AppRadius.r24),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      ),
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: .min,
          children: [
            Row(
              mainAxisAlignment: .center,
              children: [
                Text(
                  LocaleKeys.auth_forget.tr(),
                  style: AppStyles.medium(fontSize: AppFontSize.s18),
                ),
                const Spacer(),
                const CustomCloseButton(),
              ],
            ),
            const Gap(AppSize.s24),
            // email
            EmailTextFormField(
              controller: _emailController,
              focusNode: _focusNode,
              textInputAction: .done,
            ),
            const Gap(AppSize.s16),
            // submit button
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
          ],
        ),
      ),
    );
  }
}

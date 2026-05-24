import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/widgets/custom_text_form_field.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class ChangePassForm extends StatefulWidget {
  final TextEditingController oldPassController;
  final TextEditingController newPassController;
  final TextEditingController newConPassController;

  final VoidCallback onSubmit;

  const ChangePassForm({
    super.key,
    required this.oldPassController,
    required this.newPassController,
    required this.newConPassController,
    required this.onSubmit,
  });

  @override
  State<ChangePassForm> createState() => _ChangePassFormState();
}

class _ChangePassFormState extends State<ChangePassForm> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _oldPassFocus = FocusNode();
  final _newPassFocus = FocusNode();
  final _newConPassFocus = FocusNode();

  late final ObscureController _oldPassObscureController = ObscureController();
  late final ObscureController _newPassObscureController = ObscureController();
  late final ObscureController _newConPassObscureController =
      ObscureController();

  @override
  void initState() {
    super.initState();
    _newConPassObscureController.addListener(_handleConfirmFocus);
  }

  @override
  void dispose() {
    _newConPassObscureController.removeListener(_handleConfirmFocus);

    _oldPassFocus.dispose();
    _newPassFocus.dispose();
    _newConPassFocus.dispose();
    _scrollController.dispose();

    _oldPassObscureController.dispose();
    _newPassObscureController.dispose();
    _newConPassObscureController.dispose();

    super.dispose();
  }

  void _handleConfirmFocus() {
    if (_newConPassFocus.hasFocus) {
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
      _oldPassObscureController.hide();
      _newPassObscureController.hide();
      _newConPassObscureController.hide();
      Focus.maybeOf(context)?.unfocus();
      widget.onSubmit.call();
    }
  }

  void _handleDone() {
    FocusScope.of(context).unfocus();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Old Password
          PasswordTextFormField(
            controller: widget.oldPassController,
            focusNode: _oldPassFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_newPassFocus),
            obscureController: _oldPassObscureController,
            label: LocaleKeys.auth_oldPass.tr(),
          ),

          const Gap(AppSize.s32),

          // New Password
          PasswordTextFormField(
            controller: widget.newPassController,
            focusNode: _newPassFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_newConPassFocus),
            obscureController: _newPassObscureController,
            label: LocaleKeys.auth_newPass.tr(),
          ),

          const Gap(AppSize.s32),

          // New Confirm Password
          ConfirmPasswordTextFormField(
            controller: widget.newConPassController,
            passwordController: widget.newPassController,
            focusNode: _newConPassFocus,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleDone(),
            obscureController: _newConPassObscureController,
            label: LocaleKeys.auth_conNewPass.tr(),
          ),

          const Gap(AppSize.s32),

          /// Submit Button
          SizedBox(
            width: double.infinity,
            height: AppSize.s64,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              child: Text(
                LocaleKeys.auth_submuit.tr(),
                style: AppStyles.medium(fontSize: AppFontSize.s18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';

import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/core/utils/validators.dart';

// == EmailTextFormField ==
class EmailTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  TextInputAction textInputAction;
  void Function(String) onFieldSubmitted;

  EmailTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) {
        final errorKey = Validators.email(value);
        return errorKey?.tr();
      },
      style: const TextStyle(
        fontSize: AppFontSize.s18,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: 'auth.email'.tr(),
        labelStyle: TextStyle(
          color: context.colors.onPrimaryContainer,
          fontSize: AppFontSize.s15,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          Icons.email_rounded,
          color: context.colors.onTertiaryContainer,
        ),
      ),
    );
  }
}

// ==   PasswordTextFormField ==
class PasswordTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  TextInputAction textInputAction;
  void Function(String) onFieldSubmitted;

  PasswordTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.onFieldSubmitted,
  });

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: (value) {
        final errorKey = Validators.password(value);
        return errorKey?.tr();
      },
      obscureText: _obscureText,
      style: const TextStyle(
        fontSize: AppFontSize.s18,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: 'auth.pass'.tr(),
        labelStyle: TextStyle(
          color: context.colors.onPrimaryContainer,
          fontSize: AppFontSize.s15,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          Icons.password_rounded,
          color: context.colors.onTertiaryContainer,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: AppPadding.p4),
          child: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: _obscureText
                  ? context.colors.onTertiaryContainer
                  : context.colors.onSurfaceVariant,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}

// ==   ConfirmPasswordTextFormField ==
class ConfirmPasswordTextFormField extends StatefulWidget {
  final TextEditingController passwordcontroller;
  final TextEditingController controller;
  final FocusNode focusNode;
  TextInputAction textInputAction;
  void Function(String) onFieldSubmitted;

  ConfirmPasswordTextFormField({
    super.key,
    required this.passwordcontroller,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.onFieldSubmitted,
  });

  @override
  State<ConfirmPasswordTextFormField> createState() =>
      _ConfirmPasswordTextFormFieldState();
}

class _ConfirmPasswordTextFormFieldState
    extends State<ConfirmPasswordTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: (value) {
        final errorKey = Validators.confirmPassword(
          value,
          widget.passwordcontroller.text,
        );
        return errorKey?.tr();
      },
      obscureText: _obscureText,
      style: const TextStyle(
        fontSize: AppFontSize.s18,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: 'auth.conPass'.tr(),
        labelStyle: TextStyle(
          color: context.colors.onPrimaryContainer,
          fontSize: AppFontSize.s15,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          Icons.password_rounded,
          color: context.colors.onTertiaryContainer,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: AppPadding.p4),
          child: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: _obscureText
                  ? context.colors.onTertiaryContainer
                  : context.colors.onSurfaceVariant,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}

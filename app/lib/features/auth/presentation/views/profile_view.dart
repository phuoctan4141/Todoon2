import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/resources/icons_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/widgets/custom_close_button.dart';
import 'package:todoon/common/widgets/custom_text_form_field.dart';
import 'package:todoon/common/widgets/glass/glass_container.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class ProfileView extends StatefulWidget {
  final String displayName;
  final String email;
  final Function(String? name) onSave;
  const ProfileView({
    super.key,
    required this.displayName,
    required this.email,
    required this.onSave,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final TextEditingController _displayNameController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.displayName);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.displayName != oldWidget.displayName) {
      _displayNameController.text = widget.displayName;
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _focusNode.dispose();
    super.dispose();
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
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .center,
        children: [
          Row(
            mainAxisAlignment: .center,
            children: [
              Text(
                LocaleKeys.auth_updateProfile.tr(),
                style: AppStyles.medium(fontSize: AppFontSize.s18),
              ),
              const Spacer(),
              const CustomCloseButton(),
            ],
          ),
          const Gap(AppSize.s24),
          // Display Name
          CustomTextFormField(
            controller: _displayNameController,
            focusNode: _focusNode,
            textInputAction: TextInputAction.done,
            label: LocaleKeys.auth_displayName.tr(),
            prefixIcon: Icon(AppIcons.person),
          ),
          const Gap(AppSize.s16),
          // save button
          SizedBox(
            width: double.infinity,
            height: AppSize.s64,
            child: ElevatedButton(
              onPressed: () => widget.onSave.call(_displayNameController.text),
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/widgets/custom_close_button.dart';
import 'package:todoon/common/widgets/glass/glass_container.dart';
import 'package:todoon/generated/locale_keys.g.dart';

import '../widgets/change_pass_form.dart';

class ChangePassView extends StatefulWidget {
  final Function(String oldPass, String newPass) onSubmit;
  const ChangePassView({super.key, required this.onSubmit});

  @override
  State<ChangePassView> createState() => _ChangePassViewState();
}

class _ChangePassViewState extends State<ChangePassView> {
  late final TextEditingController _oldPassController;
  late final TextEditingController _newPassController;
  late final TextEditingController _newConPassController;

  @override
  void initState() {
    super.initState();
    _oldPassController = TextEditingController();
    _newPassController = TextEditingController();
    _newConPassController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _newConPassController.dispose();
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
                LocaleKeys.auth_changePassword.tr(),
                style: AppStyles.medium(fontSize: AppFontSize.s18),
              ),
              const Spacer(),
              const CustomCloseButton(),
            ],
          ),
          const Gap(AppSize.s24),

          ChangePassForm(
            onSubmit: () => widget.onSubmit.call(
              _oldPassController.text,
              _newPassController.text,
            ),
            oldPassController: _oldPassController,
            newPassController: _newPassController,
            newConPassController: _newConPassController,
          ),
        ],
      ),
    );
  }
}

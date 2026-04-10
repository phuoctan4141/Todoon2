import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/auth/presentation/widgets/profile_container.dart';
import 'package:todoon/features/common/widgets/bgr_image.dart';

import '../widgets/theme_selection.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BgrImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: Column(
              mainAxisSize: .min,
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              children: [
                ProfileContainer(
                  displayName: 'displayName',
                  email: 'examplelongemailaddress@gmail.com',
                  onUpdateProfile: () {},
                  onChangePassword: () {},
                  onForgetPassword: () {},
                ),
                const Gap(AppSize.s16),
                const ThemeSelection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

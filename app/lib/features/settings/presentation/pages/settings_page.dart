import 'package:flutter/material.dart';

import 'package:todoon/common/widgets/bgr_image.dart';
import 'package:todoon/features/settings/presentation/views/settings_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BgrImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SafeArea(child: SettingsView()),
      ),
    );
  }
}

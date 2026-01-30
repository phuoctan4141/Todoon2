import 'package:flutter/material.dart';
import 'package:todoon/features/common/widgets/custom_bottom_bar/item_custom_bottom_bar.dart';

class AppTabConfig {
  final TabItem tab;
  final Widget page;
  final List<ActionItem> Function(BuildContext context) actions;

  const AppTabConfig({
    required this.tab,
    required this.page,
    required this.actions,
  });
}

import 'package:flutter/material.dart';

class TabItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const TabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class ActionItem {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  ActionItem({required this.icon, required this.onTap, this.tooltip});
}

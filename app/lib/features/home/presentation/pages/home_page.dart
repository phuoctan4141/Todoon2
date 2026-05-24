import 'package:flutter/material.dart';
import 'package:todoon/common/widgets/bgr_image.dart';
import 'package:todoon/common/widgets/custom_bottom_bar.dart/item_custom_bottom_bar.dart';
import 'package:todoon/common/widgets/custom_page_view.dart';
import 'package:todoon/features/plan/presentation/pages/all_plans_page.dart';
import 'package:todoon/features/settings/presentation/views/settings_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final listPages = <Widget>[
      _buildDailyFocusPage(),
      _buildAllPlansPage(),
      _buildSettingsPage(),
    ];

    final listTabs = <TabItem>[
      const TabItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: 'Dashboard',
      ),
      const TabItem(
        icon: Icons.task_outlined,
        selectedIcon: Icons.task,
        label: 'Tasks',
      ),
      const TabItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
        label: 'Settings',
      ),
    ];

    final listActions = <List<ActionItem>>[
      [
        ActionItem(
          icon: Icons.add_task,
          onTap: () => print('Add task'),
          tooltip: 'Add Task',
        ),
      ],
      [
        ActionItem(
          icon: Icons.add_task,
          onTap: () => print('Add task'),
          tooltip: 'Add Task',
        ),
        ActionItem(
          icon: Icons.note_add,
          onTap: () => print('Add note'),
          tooltip: 'Add Note',
        ),
      ],
      [],
    ];

    //
    return BgrImage(
      child: CustomPageView(
        initialPage: 0,
        pages: listPages,
        tabs: listTabs,
        actions: listActions,
      ),
    );
  }

  Widget _buildDailyFocusPage() => const Center(child: Text('Dashboard'));
  Widget _buildAllPlansPage() => const AllPlansPage();
  Widget _buildSettingsPage() => const SettingsView();
}

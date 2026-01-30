import 'package:flutter/material.dart';
import 'package:todoon/features/app/models/app_tab_config.dart';
import 'package:todoon/features/common/widgets/background_image_widget.dart';
import 'package:todoon/features/common/widgets/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:todoon/features/common/widgets/custom_bottom_bar/item_custom_bottom_bar.dart';
import 'package:todoon/features/home/pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<AppTabConfig> appTabs = [
    AppTabConfig(
      tab: const TabItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: 'Home',
      ),
      page: const HomePage(),
      actions: (context) => [
        ActionItem(
          icon: Icons.add_task_rounded,
          onTap: () => print('check add_task'),
        ),
        ActionItem(
          icon: Icons.note_add_rounded,
          onTap: () => print('check note_add_rounded'),
        ),
      ],
    ),
    AppTabConfig(
      tab: const TabItem(
        icon: Icons.flag_outlined,
        selectedIcon: Icons.flag_rounded,
        label: 'All Plans',
      ),
      page: const HomePage(),
      actions: (context) => [
        ActionItem(
          icon: Icons.add_circle,
          onTap: () => print('check add_circle'),
        ),
      ],
    ),
    AppTabConfig(
      tab: const TabItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
        label: 'Settings',
      ),
      page: const HomePage(),
      actions: (_) => const [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appTabs[_selectedIndex].tab.label),
          centerTitle: true,
          actions: [if (_selectedIndex == 0) ViewModeToggleButton()],
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: appTabs.map((e) => e.page).toList(),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomBottomBar(
                  currentIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                  tabs: appTabs.map((e) => e.tab).toList(),
                  actions: appTabs[_selectedIndex].actions(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

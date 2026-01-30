import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/consts.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/common/widgets/custom_bottom_bar/item_custom_bottom_bar.dart';
import 'package:todoon/features/common/widgets/glass/glass_action_button.dart';
import 'package:todoon/features/common/widgets/glass/glass_container.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<TabItem> tabs;
  final List<ActionItem> actions;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    this.tabs = const [],
    this.actions = const [],
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  final GlobalKey _fabKey = GlobalKey();
  // ExpandedFAB Animation
  late final AnimationController _mainActionController;

  double? _fabCenterX;
  bool _isExpanded = false;
  bool _hasActions = false;
  bool _isSingle = false;

  @override
  void initState() {
    super.initState();

    _hasActions = widget.actions.isNotEmpty;
    _isSingle = widget.actions.length == i1;

    _mainActionController = AnimationController(
      vsync: this,
      duration: Durations.medium3,
    );

    _mainActionController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (!mounted) return;
        setState(() {
          _fabCenterX = null;
        });
      }
    });
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      _hasActions = widget.actions.isNotEmpty;
      _isSingle = widget.actions.length == i1;
    }

    if (oldWidget.currentIndex != widget.currentIndex && _isExpanded) {
      _closeMenu();
    }
  }

  @override
  void dispose() {
    _mainActionController.dispose();
    super.dispose();
  }

  // ======================
  // MENU CONTROL
  // ======================

  void _openMenu() {
    setState(() => _isExpanded = true);
    _mainActionController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final box = _fabKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return;

      final position = box.localToGlobal(Offset.zero);

      setState(() {
        _fabCenterX = position.dx + box.size.width / 2;
      });
    });
  }

  void _closeMenu() {
    _mainActionController.reverse();
    setState(() {
      _isExpanded = false;
    });
  }

  void _toggleMenu() {
    _isExpanded ? _closeMenu() : _openMenu();
  }

  // ======================
  // BUILD
  // ======================

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: RepaintBoundary(
        child: Stack(
          alignment: .bottomCenter,
          clipBehavior: Clip.none,
          children: [
            if (_isExpanded)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeMenu,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      color: Theme.of(context).colorScheme.inversePrimary
                          .withValues(alpha: AppColorValue.v10),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 110,
              child: _buildMainBar(context),
            ),
            if (_hasActions && !_isSingle) _buildMiniActions(context),
          ],
        ),
      ),
    );
  }

  // ======================
  // MAIN BAR
  // ======================

  Widget _buildMainBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: Row(
        mainAxisSize: .max,
        mainAxisAlignment: .center,
        children: [
          // TabItems Container
          Flexible(
            fit: FlexFit.loose,
            child: _buidTabsContainer(context, widget.tabs),
          ),

          if (_hasActions) const SizedBox(width: AppSize.s8),

          // FAB
          if (_hasActions) _buildFAB(context),
        ],
      ),
    );
  }

  // ======================
  // WIDGET PARTS
  // ======================

  Widget _buidTabsContainer(BuildContext context, List<TabItem> tabs) {
    return GlassContainer(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          return _buildTabItem(context, tabs[index], index);
        },
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, TabItem item, int index) {
    final selected = widget.currentIndex == index;
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;

    return InkWell(
      onTap: () => widget.onDestinationSelected(index),
      borderRadius: BorderRadius.circular(AppRadius.r8),
      child: AnimatedContainer(
        duration: Durations.medium3,
        width: 86,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: selected
              ? context.colors.primary.withValues(alpha: AppColorValue.v30)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.r8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? item.selectedIcon : item.icon,
              color: color,
              size: AppSize.s28,
            ),
            const SizedBox(height: AppSize.s4),
            Text(
              item.label,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium?.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return SizedBox.square(
      key: _fabKey,
      dimension: 56,
      child: AnimatedSwitcher(
        key: const ValueKey('main-bar-switch'),
        duration: Durations.medium3,
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, aim) {
          return FadeTransition(
            opacity: aim,
            child: ScaleTransition(scale: aim, child: child),
          );
        },
        child: _isSingle
            ? _buildSingleActionButton(widget.actions.first)
            : _buildMainActionButton(),
      ),
    );
  }

  Widget _buildSingleActionButton(ActionItem item) {
    return GlassActionButton(
      key: const ValueKey('single'),
      expanded: false,
      onTap: () => item.onTap.call(),
      icon: item.icon,
      tooltip: item.tooltip,
    );
  }

  Widget _buildMainActionButton() {
    return AnimatedBuilder(
      key: const ValueKey('main'),
      animation: _mainActionController,
      builder: (context, _) {
        final shouldShowClose = _mainActionController.value > 0.1;

        return Center(
          child: GlassActionButton(
            expanded: shouldShowClose,
            onTap: () => _toggleMenu(),
            icon: shouldShowClose ? Icons.close_rounded : Icons.add_rounded,
            tooltip: shouldShowClose ? 'action.collapse' : 'action.expand',
          ),
        );
      },
    );
  }

  // ======================
  // MINI ACTIONS
  // ======================

  Widget _buildMiniActions(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainActionController,
      builder: (context, _) {
        if (_mainActionController.status == AnimationStatus.dismissed) {
          return const SizedBox.shrink();
        }

        final screenHeight = MediaQuery.of(context).size.height;
        final maxHeight = screenHeight - 200.0;

        if (_fabCenterX == null) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 110,
          left: _fabCenterX! - 28,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Opacity(
              opacity: _mainActionController.value,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(widget.actions.length, (index) {
                    final item =
                        widget.actions[widget.actions.length - i1 - index];
                    final delay = index * 0.1;
                    final adjustedValue = (_mainActionController.value - delay)
                        .clamp(d0, d1);
                    final itemCurve = Curves.easeOutBack.transform(
                      adjustedValue,
                    );

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < widget.actions.length - d1 ? 14.0 : d0,
                      ),
                      child: Transform.scale(
                        scale: itemCurve,
                        child: _buildMiniActionButton(context, item),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniActionButton(BuildContext context, ActionItem item) {
    return GlassMiniActionButton(
      onTap: () {
        item.onTap.call();
        _closeMenu();
      },
      icon: item.icon,
      tooltip: item.tooltip,
    );
  }
}

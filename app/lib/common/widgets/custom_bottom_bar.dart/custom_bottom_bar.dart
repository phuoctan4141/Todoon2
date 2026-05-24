import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/widgets/glass/glass_action_button.dart';
import 'package:todoon/common/widgets/glass/glass_container.dart';

import 'item_custom_bottom_bar.dart';

class CustomBottomBar extends StatefulWidget {
  final TabController tabController;
  final void Function(int) onCurrentPageIndexChanged;
  final List<TabItem> tabs;
  final List<ActionItem> actions;
  final bool visible;

  const CustomBottomBar({
    super.key,
    required this.tabController,
    required this.onCurrentPageIndexChanged,
    this.tabs = const [],
    this.actions = const [],
    this.visible = true,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  GlobalKey? _multiFabKey;
  bool _isExpanded = false;

  late final AnimationController _menuController;
  late final Animation<double> _fadeAnimation;

  static const double _kDelayBetweenActions = 0.1;
  static const double _kFabSize = AppSize.s56;

  bool get _hasActions => widget.actions.isNotEmpty;
  bool get _isSingleAction => widget.actions.length == 1;
  bool get _isMultiAction => widget.actions.length > 1;

  @override
  void initState() {
    super.initState();

    _multiFabKey = _isMultiAction ? _createNewKey() : null;

    _menuController = AnimationController(
      duration: Durations.medium3,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeOut,
    );

    _menuController.addStatusListener(_handleAnimationStatus);
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    final wasMultiAction = oldWidget.actions.length > 1;
    final isNowMultiAction = widget.actions.length > 1;

    if (wasMultiAction != isNowMultiAction) {
      setState(() {
        _multiFabKey = isNowMultiAction ? _createNewKey() : null;
      });
    }

    if ((oldWidget.actions.length != widget.actions.length) && _isExpanded) {
      _closeMenu();
    }
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  /// === _createNewKey ===
  GlobalKey _createNewKey() {
    return GlobalKey(
      debugLabel: 'multi-fab-${DateTime.now().microsecondsSinceEpoch}',
    );
  }

  /// === _handleAnimationStatus ===
  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && mounted) {
      setState(() {
        _isExpanded = false;
      });
    }
  }

  void _handleCurrentPageIndexChanged(int index) {
    if (_isExpanded) {
      _closeMenu();
    }
    widget.onCurrentPageIndexChanged(index);
  }

  /// === _openMenu ===
  void _openMenu() {
    if (!mounted) return;
    setState(() => _isExpanded = true);
    _menuController.forward();
  }

  /// === _closeMenu ===
  void _closeMenu() {
    if (!mounted) return;
    _menuController.reverse();
  }

  /// === _toggleMenu ===
  void _toggleMenu() {
    _isExpanded ? _closeMenu() : _openMenu();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          if (_isExpanded) _buildBackdrop(),
          _buildBottomBar(),
          if (_isMultiAction) _buildMiniActions(),
        ],
      ),
    );
  }

  /// === _buildBackdrop ===
  Widget _buildBackdrop() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _closeMenu,
        behavior: HitTestBehavior.opaque,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: ColoredBox(
            color: context.colors.inversePrimary.withValues(
              alpha: AppColorValue.v10,
            ),
          ),
        ),
      ),
    );
  }

  /// === _buildBottomBar ===
  Widget _buildBottomBar() {
    return Positioned(
      bottom: dZERO,
      left: dZERO,
      right: dZERO,
      height: kBottomBarHeight + MediaQuery.of(context).padding.bottom,
      child: AnimatedSlide(
        duration: Durations.medium1,
        curve: Curves.easeInOut,
        offset: widget.visible ? Offset.zero : const Offset(0, 1),
        child: AnimatedOpacity(
          duration: Durations.medium1,
          opacity: widget.visible ? 1.0 : 0.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p12,
              vertical: AppPadding.p8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(fit: FlexFit.loose, child: _buildTabsContainer()),
                if (_hasActions) const SizedBox(width: AppSize.s8),
                if (_hasActions) _buildFAB(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// === _buildTabsContainer ===
  Widget _buildTabsContainer() {
    return GlassContainer(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) =>
            _buildTabItem(widget.tabs[index], index),
        separatorBuilder: (context, index) => const SizedBox(width: AppSize.s2),
      ),
    );
  }

  /// === _buildTabItem ===
  Widget _buildTabItem(TabItem item, int index) {
    final isSelected = widget.tabController.index == index;
    final color = isSelected
        ? context.colors.primary
        : context.colors.onSurface;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.r8),
      child: InkWell(
        onTap: () => _handleCurrentPageIndexChanged(index),
        borderRadius: BorderRadius.circular(AppRadius.r8),
        child: AnimatedContainer(
          duration: Durations.medium3,
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p12,
            vertical: AppPadding.p8,
          ),
          constraints: BoxConstraints(maxWidth: AppSize.s120),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colors.primary.withValues(alpha: AppColorValue.v30)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.r8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isSelected ? item.selectedIcon : item.icon,
                color: color,
                size: AppSize.s24,
              ),
              if (isSelected) ...[
                const SizedBox(width: AppSize.s4),
                Flexible(
                  child: ClipRect(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        item.label,
                        maxLines: 1,
                        style: AppStyles.bold(
                          color: color,
                          fontSize: AppFontSize.s12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// === _buildFAB ===
  Widget _buildFAB() {
    return SizedBox.square(
      dimension: _kFabSize,
      child: AnimatedSwitcher(
        duration: Durations.medium3,
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeInBack,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: _isSingleAction
            ? _buildSingleActionButton()
            : _buildMultiActionButton(),
      ),
    );
  }

  /// === _buildSingleActionButton ===
  Widget _buildSingleActionButton() {
    final action = widget.actions.first;
    return GlassActionButton(
      key: const ValueKey('single-action'),
      expanded: false,
      onTap: action.onTap,
      icon: action.icon,
      tooltip: action.tooltip,
    );
  }

  /// === _buildMultiActionButton ===
  Widget _buildMultiActionButton() {
    final keyValue = _multiFabKey?.hashCode ?? 0;
    return AnimatedBuilder(
      key: ValueKey('multi-action-$keyValue'),
      animation: _menuController,
      builder: (context, child) {
        final shouldShowClose = _menuController.value > 0.1;
        return GlassActionButton(
          key: _multiFabKey,
          expanded: shouldShowClose,
          onTap: _toggleMenu,
          icon: shouldShowClose ? Icons.close_rounded : Icons.add_rounded,
          tooltip: shouldShowClose ? 'action.collapse' : 'action.expand',
        );
      },
    );
  }

  /// === _buildMiniActions ===
  Widget _buildMiniActions() {
    return AnimatedBuilder(
      animation: _menuController,
      builder: (context, _) {
        if (_menuController.status == AnimationStatus.dismissed) {
          return const SizedBox.shrink();
        }

        final screenHeight = MediaQuery.of(context).size.height;
        final maxHeight = screenHeight - AppSize.s120;

        return Positioned(
          bottom: kBottomBarHeight,
          left: AppSize.s12,
          right: AppSize.s12,
          child: Align(
            alignment: Alignment.bottomRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _buildMiniActionsList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildMiniActionsList() {
    final reversedActions = widget.actions.reversed.toList();

    return List.generate(reversedActions.length, (index) {
      final action = reversedActions[index];
      final delay = index * _kDelayBetweenActions;
      final adjustedValue = (_menuController.value - delay).clamp(0.0, 1.0);
      final scale = Curves.easeOutBack.transform(adjustedValue);

      return Padding(
        padding: EdgeInsets.only(
          bottom: index < reversedActions.length - 1 ? AppPadding.p14 : 0,
        ),
        child: Transform.scale(
          scale: scale,
          child: GlassMiniActionButton(
            onTap: () {
              action.onTap();
              _closeMenu();
            },
            icon: action.icon,
            tooltip: action.tooltip,
          ),
        ),
      );
    });
  }
}

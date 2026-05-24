import 'package:flutter/material.dart';
import 'package:todoon/common/widgets/custom_bottom_bar.dart/custom_bottom_bar.dart';
import 'package:todoon/common/widgets/custom_bottom_bar.dart/item_custom_bottom_bar.dart';

class CustomPageView extends StatefulWidget {
  final List<Widget> pages;
  final List<TabItem> tabs;
  final List<List<ActionItem>> actions;
  final int initialPage;
  final bool keepPageAlive;

  const CustomPageView({
    super.key,
    required this.pages,
    required this.tabs,
    this.actions = const [],
    this.initialPage = 0,
    this.keepPageAlive = true,
  }) : assert(
         pages.length == tabs.length &&
             pages.length == actions.length &&
             tabs.length == actions.length,
         'Pages, tabs, and actions must have the same length',
       );

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    _currentPageIndex = widget.initialPage;

    _pageController = PageController(initialPage: _currentPageIndex);
    _tabController = TabController(
      initialIndex: _currentPageIndex,
      length: widget.pages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onPageChanged(int currentPageIndex) {
    _tabController.animateTo(
      currentPageIndex,
      duration: Durations.short3,
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _onTabChanged(int currentPageIndex) {
    _pageController.animateToPage(
      currentPageIndex,
      duration: Durations.short3,
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // PageView
            PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              itemCount: widget.pages.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                if (widget.keepPageAlive) {
                  return _KeepAlivePage(child: widget.pages[index]);
                }
                return widget.pages[index];
              },
            ),

            // Custom Bottom Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomBar(
                tabController: _tabController,
                onCurrentPageIndexChanged: _onTabChanged,
                tabs: widget.tabs,
                actions: widget.actions.isNotEmpty
                    ? widget.actions[_currentPageIndex]
                    : [],
                visible: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// === _KeepAlivePage ===
class _KeepAlivePage extends StatefulWidget {
  final Widget child;

  const _KeepAlivePage({required this.child});

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

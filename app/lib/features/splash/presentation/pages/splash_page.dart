import 'package:flutter/material.dart';
import 'package:todoon/core/resources/assets_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isFadeCompleted = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Durations.extralong1,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().then((_) {
      setState(() => _isFadeCompleted = true);

      _controller
        ..duration = Durations.extralong4
        ..reset();

      _scaleAnimation = Tween<double>(
        begin: 1.5,
        end: 0.9,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

      _controller.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Opacity(
              opacity: _isFadeCompleted ? 1 : _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Image.asset(
            ImageAssets.todoon_rounded_png,
            width: AppSize.s128,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

class AnimatedCount extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;

  const AnimatedCount({
    super.key,
    required this.value,
    this.style,
    this.duration = Durations.medium1,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, anim) {
        final int oldValue = (child.key as ValueKey<int>).value;
        final bool isIncreasing = value > oldValue;

        return SlideTransition(
          position: Tween<Offset>(
            begin: isIncreasing
                ? const Offset(0, 0.5) // số mới từ dưới lên
                : const Offset(0, -0.5), // số mới từ trên xuống
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutBack)),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: child,
          ),
        );
      },
      child: Text(key: ValueKey<int>(value), value.toString(), style: style),
    );
  }
}

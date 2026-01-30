import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedDeleteIcon extends StatelessWidget {
  final double progress; // 0 → 1
  final double size;
  final Color color;

  const AnimatedDeleteIcon({
    super.key,
    required this.progress,
    this.size = 28,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // chiều dịch lên, giống y: -1.1 trong motion
    final lidOffset = -6.0 * progress;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Thùng
          SvgPicture.asset(
            'assets/icons/delete/delete_body.svg',
            width: size,
            height: size,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          // Nắp
          AnimatedPositioned(
            duration: Durations.extralong1,
            curve: Curves.easeOut,
            top: lidOffset,
            child: SvgPicture.asset(
              'assets/icons/delete/delete_lid.svg',
              width: size,
              height: size,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

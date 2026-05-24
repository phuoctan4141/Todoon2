import 'package:flutter/material.dart';

/// === TapPositionButton ===
class TapPositionButton extends StatelessWidget {
  final IconData icon;
  final ValueChanged<Offset> onTap;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final double elevation;
  final EdgeInsets padding;

  const TapPositionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 32.0,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.elevation = 3.0,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        elevation: elevation,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        color: backgroundColor,
        child: InkWell(
          onTap: () {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final center = box.localToGlobal(box.size.center(Offset.zero));
            onTap(center);
          },
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: Icon(icon, color: iconColor, size: size * 0.55),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:todoon/core/resources/consts.dart';
import 'package:todoon/core/resources/values_manager.dart';

class CustomReorderableList extends StatefulWidget {
  final int itemCount;
  final void Function(int, int) onReorder;
  final Widget Function(BuildContext, int) itemBuilder;
  const CustomReorderableList({
    super.key,
    required this.itemCount,
    required this.onReorder,
    required this.itemBuilder,
  });

  @override
  State<CustomReorderableList> createState() => _CustomReorderableListState();
}

class _CustomReorderableListState extends State<CustomReorderableList> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ReorderableListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.itemCount,
      onReorder: widget.onReorder,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final double animValue = Curves.easeInOut.transform(
              animation.value,
            );
            final double scale = AppSize.s1 + 0.06 * animValue;
            final double elevation =
                AppElevation.e6 + AppElevation.e9 * animValue;
            final double blurValue = 12.0 + 16.0 * animValue;

            return Transform.scale(
              scale: scale,
              child: Material(
                elevation: elevation,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.r16),
                child: AnimatedContainer(
                  duration: Durations.medium1,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(
                            alpha: AppColorValue.v30 * animValue,
                          )
                        : Colors.white.withValues(
                            alpha: AppColorValue.v40 * animValue,
                          ),
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(
                              alpha: AppColorValue.v20 * animValue,
                            )
                          : Colors.grey.shade300.withValues(
                              alpha: AppColorValue.v30 * animValue,
                            ),
                      width: 1.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: blurValue,
                        sigmaY: blurValue,
                      ),
                      child: Opacity(
                        opacity:
                            (isDark ? AppColorValue.v80 : AppColorValue.v70) +
                            AppColorValue.v10 * (d1 - animValue),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: widget.itemBuilder(context, index),
        );
      },
      itemBuilder: (context, index) {
        final item = widget.itemBuilder(context, index);

        return ReorderableDragStartListener(
          key: item.key,
          index: index,
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: item,
          ),
        );
      },
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todoon/core/resources/values_manager.dart';

class CustomReorderableListView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final void Function(int oldIndex, int newIndex) onReorder;
  final ScrollController? scrollController;
  final void Function(int)? onReorderStart;
  final void Function(int)? onReorderEnd;

  const CustomReorderableListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
    this.scrollController,
    this.onReorderStart,
    this.onReorderEnd,
  });

  @override
  State<CustomReorderableListView<T>> createState() =>
      _CustomReorderableListViewState<T>();
}

class _CustomReorderableListViewState<T>
    extends State<CustomReorderableListView<T>> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ReorderableListView.builder(
      scrollController: widget.scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.items.length,
      onReorder: widget.onReorder,
      onReorderStart: widget.onReorderStart,
      onReorderEnd: widget.onReorderEnd,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final double t = animation.value;

            const double scalePeak = 1.06;
            const double scaleEnd = 0.8;
            final double a = 2 * (scaleEnd - 2 * scalePeak + 1);
            final double b = 4 * scalePeak - scaleEnd - 3;
            final double scale = a * t * t + b * t + 1;

            final double elevation = AppElevation.e6 + AppElevation.e9 * t;
            final double blur = 12.0 + 16.0 * t;

            return Transform.scale(
              scale: scale,
              child: Material(
                elevation: elevation,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.r16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: AppColorValue.v30 * t)
                        : Colors.white.withValues(alpha: AppColorValue.v40 * t),
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(
                              alpha: AppColorValue.v20 * t,
                            )
                          : Colors.grey.shade300.withValues(
                              alpha: AppColorValue.v30 * t,
                            ),
                      width: 1.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                      child: Opacity(
                        opacity:
                            (isDark ? AppColorValue.v80 : AppColorValue.v70) +
                            AppColorValue.v10 * (1 - t),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: widget.itemBuilder(widget.items[index], index),
        );
      },
      itemBuilder: (context, index) {
        final item = widget.itemBuilder(widget.items[index], index);

        return Padding(
          key: item.key,
          padding: const EdgeInsets.all(AppPadding.p8),
          child: item,
        );
      },
    );
  }
}

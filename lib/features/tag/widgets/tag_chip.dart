import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/extensions/tag_color_extension.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/tag/models/tag_model.dart';

class TagChip extends StatelessWidget {
  final TagModel tag;
  final VoidCallback onLongPress;
  const TagChip({super.key, required this.tag, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tag.color.value,
      borderRadius: BorderRadius.circular(AppRadius.r8),
      child: InkWell(
        onLongPress: () {},
        borderRadius: BorderRadius.circular(AppRadius.r8),
        child: Padding(
          padding: EdgeInsetsGeometry.all(AppPadding.p4),
          child: Text(
            '#${tag.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: context.bgColor),
          ),
        ),
      ),
    );
  }
}

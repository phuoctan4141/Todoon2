import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/tag/models/tag_model.dart';
import 'package:todoon/features/tag/widgets/tag_chip.dart';

class TagHorizontalList extends StatelessWidget {
  final List<TagModel> tags;
  const TagHorizontalList({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'title.Tags',
              style: context.text.titleSmall?.copyWith(
                color: context.colors.onPrimaryContainer,
              ),
            ).tr(),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add, color: context.colors.onTertiaryContainer),
            ),
          ],
        ),
        const Gap(AppSize.s4),
        Wrap(
          spacing: AppSize.s4,
          runSpacing: AppSize.s4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: tags
              .map((tag) => TagChip(tag: tag, onLongPress: () {}))
              .toList(),
        ),
      ],
    );
  }
}

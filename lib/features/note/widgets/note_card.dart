import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/consts.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/note/models/note_model.dart';
import 'package:todoon/features/tag/models/tag_model.dart';
import 'package:todoon/features/tag/widgets/tag_horizontal_list.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final List<TagModel> tags;
  const NoteCard({super.key, required this.note, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(context),
            const Gap(AppSize.s8),
            _ContentArea(context),
            const Gap(AppSize.s8),
            TagHorizontalList(tags: tags),
          ],
        ),
      ),
    );
  }

  Widget _Header(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.drag_handle_rounded,
          color: context.colors.onPrimaryContainer,
        ),
        const Gap(AppSize.s8),
        Text(
          'NOTE',
          style: context.text.titleMedium?.copyWith(
            color: context.colors.onPrimaryContainer,
          ),
        ).tr(),
        const Spacer(),
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: context.colors.onTertiaryContainer,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _ContentArea(BuildContext context) {
    return Material(
      color: context.colors.primaryContainer,
      borderRadius: BorderRadius.circular(AppRadius.r8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppRadius.r8),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: AppSize.s80,
            maxHeight: AppSize.s120,
          ),
          padding: const EdgeInsets.all(AppPadding.p8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r8),
          ),
          child: Text(
            note.content,
            maxLines: i4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colors.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}

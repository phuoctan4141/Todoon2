import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/assets_manager.dart';
import 'package:todoon/core/resources/icons_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/widgets/choose_tile.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class ProfileContainer extends StatefulWidget {
  final String displayName;
  final String email;
  final VoidCallback onUpdateProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onForgetPassword;

  const ProfileContainer({
    super.key,
    required this.displayName,
    required this.email,
    required this.onUpdateProfile,
    required this.onChangePassword,
    required this.onForgetPassword,
  });

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  static const _duration = Durations.medium3;
  static const _blurLight = 16.0;
  static const _blurDark = 32.0;

  bool _isExpanded = false;

  void _toggleExpanded() => setState(() => _isExpanded = !_isExpanded);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r24),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: AppElevation.e3,
      color: _getContainerColor(context),
      shadowColor: _getContainerColor(context),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: _getBlurValue(context),
          sigmaY: _getBlurValue(context),
        ),
        child: AnimatedContainer(
          duration: _duration,
          curve: Curves.easeOut,
          padding: _isExpanded
              ? const EdgeInsets.all(AppPadding.p8)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r24),
            color: _isExpanded
                ? _getContainerColor(context)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildHeader(context), _buildExpandedContent(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: _isExpanded ? AppElevation.e3 : 0,
      color: context.theme.colorScheme.primaryContainer,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Row(
          children: [
            _buildAvatar(context),
            const Gap(AppSize.s16),
            _buildUserInfo(),
            _buildExpandButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final isLight = context.theme.brightness == Brightness.light;
    final avatar = isLight
        ? ImageAssets.background_dark
        : ImageAssets.background_light;

    return CircleAvatar(
      radius: AppRadius.r48,
      backgroundImage: AssetImage(avatar),
    );
  }

  Widget _buildUserInfo() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.displayName,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.medium(fontSize: AppFontSize.s18),
          ),
          Text(
            widget.email,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.regular(fontSize: AppFontSize.s14),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandButton() {
    return AnimatedRotation(
      turns: _isExpanded ? 0.5 : 0,
      duration: _duration,
      curve: Curves.easeOut,
      child: IconButton(
        onPressed: _toggleExpanded,
        icon: Icon(AppIcons.drop_down),
        iconSize: AppSize.s28,
        tooltip: _isExpanded
            ? LocaleKeys.action_collapse.tr()
            : LocaleKeys.action_expand.tr(),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    final tileBorderRadius = BorderRadius.circular(AppRadius.r8);
    final tileIconColor = context.theme.colorScheme.onTertiaryContainer;

    return ClipRect(
      child: AnimatedAlign(
        duration: _duration,
        alignment: Alignment.topCenter,
        heightFactor: _isExpanded ? 1 : 0,
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChooseTile(
                icon: AppIcons.person,
                title: LocaleKeys.auth_updateProfile.tr(),
                subtitle: LocaleKeys.auth_updateProfileSub.tr(),
                onTap: widget.onUpdateProfile,
                borderRadius: tileBorderRadius,
                iconColor: tileIconColor,
              ),
              const Gap(AppSize.s4),
              ChooseTile(
                icon: AppIcons.password,
                title: LocaleKeys.auth_changePassword.tr(),
                subtitle: LocaleKeys.auth_changePasswordSub.tr(),
                onTap: widget.onChangePassword,
                borderRadius: tileBorderRadius,
                iconColor: tileIconColor,
              ),
              const Gap(AppSize.s4),
              ChooseTile(
                icon: AppIcons.forget,
                title: LocaleKeys.auth_forget.tr(),
                subtitle: LocaleKeys.auth_forgetSub.tr(),
                onTap: widget.onForgetPassword,
                borderRadius: tileBorderRadius,
                iconColor: tileIconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getContainerColor(BuildContext context) {
    final isLight = context.theme.brightness == Brightness.light;
    final alpha = isLight ? AppColorValue.v30 : AppColorValue.v50;
    return context.theme.colorScheme.primaryContainer.withValues(alpha: alpha);
  }

  double _getBlurValue(BuildContext context) {
    return context.theme.brightness == Brightness.light
        ? _blurLight
        : _blurDark;
  }
}

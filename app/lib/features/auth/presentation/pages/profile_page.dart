import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/assets_manager.dart';
import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/auth/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:todoon/features/common/app_state/app_state_builder.dart';
import 'package:todoon/service_locator.dart';

import '../views/profile_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  /// === _handleSave ===
  void _handleSave(BuildContext context, String displayName) {
    BlocProvider.of<ProfileCubit>(context).updateProfile(displayName);
  }

  @override
  Widget build(BuildContext context) {
    final bgrImage = AssetImage(
      context.bgColor == Colors.white
          ? ImageAssets.background_light
          : ImageAssets.background_dark,
    );
    final colorFilter = ColorFilter.mode(
      context.bgColor == Colors.white
          ? Colors.white.withValues(alpha: AppColorValue.v50)
          : Colors.black.withValues(alpha: AppColorValue.v30),
      BlendMode.srcOver,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: .bottomCenter,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: bgrImage,
            fit: .cover,
            colorFilter: colorFilter,
          ),
        ),
        child: SafeArea(
          child: BlocProvider(
            lazy: false,
            create: (_) => sl.get<ProfileCubit>()..getCurrentUser(),
            child: AppStateBuilder<ProfileCubit, ProfileState>(
              buildWhen: (previous, current) => previous.flow != current.flow,
              builder: (context, state) {
                return ProfileView(
                  key: ValueKey('profile'),
                  displayName: state.displayName,
                  email: state.email,
                  onSave: (displayName) =>
                      _handleSave(context, displayName.orEmpty()),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

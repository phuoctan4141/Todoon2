import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:todoon/core/resources/consts_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:todoon/features/auth/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:todoon/features/auth/presentation/views/change_pass_view.dart';
import 'package:todoon/features/auth/presentation/views/forget_view.dart';
import 'package:todoon/features/auth/presentation/views/profile_view.dart';
import 'package:todoon/features/auth/presentation/widgets/profile_container.dart';
import 'package:todoon/common/app_state/app_state_builder.dart';
import 'package:todoon/common/app_state/state_widgets.dart';
import 'package:todoon/generated/locale_keys.g.dart';
import 'package:todoon/routes/route_names.dart';
import 'package:todoon/service_locator.dart';

import '../widgets/language_selection.dart';
import '../widgets/theme_selection.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  /// === _onUpdateProfile ===
  void _onUpdateProfile(
    BuildContext context,
    String displayName,
    String email,
  ) {
    final bloc = sl.get<AuthBloc>();
    StateWidgets.showBottomSheet(
      context,
      ProfileView(
        displayName: displayName,
        email: email,
        onSave: (String? name) {
          bloc.add(AuthUpdateProfileEvent(displayName: name.orEmpty()));
          Navigator.pop(context);
        },
      ),
    );
  }

  /// === _onChangePassword ===
  void _onChangePassword(BuildContext context) {
    final bloc = sl.get<AuthBloc>();
    StateWidgets.showBottomSheet(
      context,
      BlocProvider.value(
        value: bloc,
        child: AppStateBuilder<AuthBloc, AuthState>(
          builder: (context, state) => ChangePassView(
            onSubmit: (String oldPass, String newPass) {
              bloc.add(
                AuthChangePassEvent(oldPassword: oldPass, newPassword: newPass),
              );
            },
          ),
        ),
      ),
    );
  }

  /// === _onForgetPassword ===
  void _onForgetPassword(BuildContext context) {
    final bloc = sl.get<AuthBloc>();
    StateWidgets.showBottomSheet(
      context,
      BlocProvider.value(
        value: bloc,
        child: AppStateBuilder<AuthBloc, AuthState>(
          builder: (context, state) => ForgetView(
            onSubmit: (String email) {
              bloc.add(AuthResetPassEvent(email: email));
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Column(
          mainAxisSize: .min,
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
            _buildProfileContainer(context),
            const Gap(AppSize.s16),
            const ThemeSelection(),
            const Gap(AppSize.s16),
            const LanguageSelection(),
            const Gap(AppSize.s16),
            _buildSignOutButton(context),
            const Gap(kBottomBarHeight),
          ],
        ),
      ),
    );
  }

  /// === ProfileContainer ===
  Widget _buildProfileContainer(BuildContext context) {
    return BlocProvider.value(
      value: sl.get<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {},
        buildWhen: (previous, current) =>
            previous.displayName != current.displayName,
        builder: (context, state) => ProfileContainer(
          displayName: state.displayName,
          email: state.email,
          onUpdateProfile: () =>
              _onUpdateProfile(context, state.displayName, state.email),
          onChangePassword: () => _onChangePassword(context),
          onForgetPassword: () => _onForgetPassword(context),
        ),
      ),
    );
  }

  /// === SignOutButton ==
  Widget _buildSignOutButton(BuildContext context) {
    final bloc = sl.get<AuthBloc>();
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            navigator.clearStackAndPush(RouteNames.auth);
          }
        },
        builder: (context, state) => ElevatedButton(
          onPressed: () => bloc.add(AuthSignOutEvent()),
          child: Text(LocaleKeys.auth_signOut.tr()),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/common/app_state/app_state_builder.dart';
import 'package:todoon/features/termsaprivacy/presentation/cubit/termsaprivacy_cubit.dart';
import 'package:todoon/generated/locale_keys.g.dart';
import 'package:todoon/service_locator.dart';

class TermsAndPrivacyPage extends StatefulWidget {
  const TermsAndPrivacyPage({super.key});

  @override
  State<TermsAndPrivacyPage> createState() => _TermsAndPrivacyPageState();
}

class _TermsAndPrivacyPageState extends State<TermsAndPrivacyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(LocaleKeys.auth_termsAndPrivacy.tr()),
        ),
        bottom: TabBar(
          controller: _tabController,
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          splashBorderRadius: BorderRadius.circular(AppRadius.r48),
          tabs: [
            Tab(text: LocaleKeys.auth_terms.tr()),
            Tab(text: LocaleKeys.auth_privacy.tr()),
          ],
        ),
      ),
      body: BlocProvider.value(
        value: sl.get<TermsAndPrivacyCubit>()..loadData(),
        child: AppStateBuilder<TermsAndPrivacyCubit, TermsAndPrivacyState>(
          builder: (context, state) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildMarkdownTab(state.termsContent!),
                _buildMarkdownTab(state.privacyContent!),
              ],
            );
          },
        ),
      ),
    );
  }

  /// === MarkdownTab ===
  Widget _buildMarkdownTab(String content) {
    return SafeArea(
      child: Markdown(
        data: content,
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(
            fontSize: AppFontSize.s20,
            fontWeight: FontWeight.bold,
          ),
          h2: const TextStyle(
            fontSize: AppFontSize.s18,
            fontWeight: FontWeight.w600,
          ),
          p: const TextStyle(fontSize: AppFontSize.s16),
        ),
      ),
    );
  }
}

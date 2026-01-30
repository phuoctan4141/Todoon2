import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todoon/features/plan/pages/components/plan_content_view.dart';
import 'package:todoon/features/plan/providers/plan_content_provider.dart';
import 'package:todoon/features/plan/widgets/plan_view_mode.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlanContentProvider>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: .topCenter,
      child: Consumer<PlanContentProvider>(
        builder: (context, provider, _) {
          return PlanContentView(provider: provider);
        },
      ),
    );
  }
}

class ViewModeToggleButton extends StatelessWidget {
  const ViewModeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlanContentProvider>();
    final tooltip = provider.viewMode == PlanViewMode.list
        ? 'action.switchGrid'
        : 'action.switchList';

    return IconButton(
      icon: Icon(
        provider.viewMode == PlanViewMode.list
            ? Icons.grid_view_rounded
            : Icons.view_agenda_rounded,
      ),
      onPressed: () => provider.changeViewMode(),
      tooltip: tooltip.tr(),
    );
  }
}

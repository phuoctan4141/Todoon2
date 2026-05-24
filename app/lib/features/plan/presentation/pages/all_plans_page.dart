import 'package:flutter/material.dart';
import 'package:todoon/features/plan/domain/entities/plan_entity.dart';
import 'package:todoon/features/plan/presentation/widgets/plan_tile.dart';

class AllPlansPage extends StatefulWidget {
  const AllPlansPage({super.key});

  @override
  State<AllPlansPage> createState() => _AllPlansPageState();
}

class _AllPlansPageState extends State<AllPlansPage> {
  late List<PlanEntity> _plans;

  @override
  void initState() {
    super.initState();
    // Sample data for testing PlanTile
    _plans = [
      PlanEntity.create(title: 'Morning Workout', position: 0),
      PlanEntity.create(title: 'Buy Groceries', position: 1),
      PlanEntity.create(title: 'Read a Book', position: 2),
      PlanEntity.create(title: 'Write Flutter Code', position: 3),
    ];
  }

  void _handleDelete(String planId) {
    setState(() {
      _plans.removeWhere((plan) => plan.id == planId);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Plan deleted: $planId')));
  }

  void _handleTap(String planId) {
    final plan = _plans.firstWhere((p) => p.id == planId);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tapped: ${plan.title}')));
    // Optionally navigate to plan details page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Plans'), centerTitle: true),
      body: _plans.isEmpty
          ? const Center(child: Text('No plans yet'))
          : ListView.builder(
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
                return PlanTile(
                  plan: plan,
                  onDismissed: _handleDelete,
                  onTapped: _handleTap,
                );
              },
            ),
    );
  }
}

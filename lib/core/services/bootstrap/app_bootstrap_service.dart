import 'package:todoon/features/plan/datasources/plan_local_datasource.dart';
import 'package:todoon/features/plan/models/plan_model.dart';

class AppBootstrapService {
  final PlanLocalDataSource _planLocal;

  AppBootstrapService(this._planLocal);

  Future<void> run() async {
    await _ensureHomePlan();
  }

  Future<void> _ensureHomePlan() async {
    final exists = await _planLocal.exists(PlanModel.home().uid);
    if (!exists) {
      await _planLocal.put(PlanModel.home());
    }
  }
}

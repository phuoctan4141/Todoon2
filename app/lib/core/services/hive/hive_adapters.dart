import 'package:hive_ce/hive_ce.dart';
import 'package:todoon/features/plan/data/models/plan_model.dart';
import 'package:todoon/features/todo_list/data/models/todo_list_model.dart';

// To generate adapters, run this command in the terminal:
// dart run build_runner build --delete-conflicting-outputs
@GenerateAdapters([AdapterSpec<PlanModel>(), AdapterSpec<TodoListModel>()])
part 'hive_adapters.g.dart';
// end
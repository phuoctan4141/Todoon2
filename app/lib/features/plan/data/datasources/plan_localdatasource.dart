import 'package:dartz/dartz.dart';
import 'package:todoon/core/services/hive/hive_box_names.dart';
import 'package:todoon/core/services/hive/hive_service.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/common/base/base_datasource.dart';

import '../models/plan_model.dart';

abstract class PlanLocalDataSource extends BaseLocalDataSource<PlanModel> {
  @override
  Future<Either<Failure, List<PlanModel>>> getAll();
  @override
  Future<Either<Failure, PlanModel?>> getById(String id);
  @override
  Future<Either<Failure, Unit>> add(PlanModel data);
  @override
  Future<Either<Failure, Unit>> update(PlanModel data);
  @override
  Future<Either<Failure, Unit>> delete(String id);
  @override
  Future<Either<Failure, Unit>> softDelete(PlanModel data);
}

class PlanLocalDataSourceImpl implements PlanLocalDataSource {
  final HiveService _hiveService;

  PlanLocalDataSourceImpl({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<Either<Failure, List<PlanModel>>> getAll() async {
    return await _hiveService.getAllData<PlanModel>(HiveBoxNames.plans);
  }

  @override
  Future<Either<Failure, PlanModel?>> getById(String id) async {
    final result = await _hiveService.getData<PlanModel>(
      HiveBoxNames.plans,
      id,
    );

    return result.fold((failure) => Left(failure), (value) => Right(value));
  }

  @override
  Future<Either<Failure, Unit>> add(PlanModel data) async {
    return await _hiveService.putData<PlanModel>(
      boxName: HiveBoxNames.plans,
      key: data.id,
      value: data,
    );
  }

  @override
  Future<Either<Failure, Unit>> update(PlanModel data) async {
    return await _hiveService.updateData<PlanModel>(
      HiveBoxNames.plans,
      data.id,
      data,
    );
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    return await _hiveService.deleteData<PlanModel>(HiveBoxNames.plans, id);
  }

  @override
  Future<Either<Failure, Unit>> softDelete(PlanModel data) async {
    return await update(data);
  }
}

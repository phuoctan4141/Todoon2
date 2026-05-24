import 'package:dartz/dartz.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:todoon/core/resources/strings_manager.dart';
import 'package:todoon/core/utils/error_handler.dart';
import 'package:todoon/core/utils/failure.dart';
import 'package:todoon/features/plan/data/models/plan_model.dart';
import 'package:todoon/features/todo_list/data/models/todo_list_model.dart';

import 'hive_box_names.dart';
import 'hive_registrar.g.dart';

class HiveService {
  final HiveInterface _hive = Hive;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _hive.init(dir.path);
    _hive.registerAdapters();
  }

  Future<void> openAllBoxes() async {
    await _hive.openBox<PlanModel>(HiveBoxNames.plans);
    await _hive.openBox<TodoListModel>(HiveBoxNames.todoLists);
  }

  Future<void> closeAllBoxes() async {
    await _hive.close();
  }

  /// === CREATE DATA ===
  Future<Either<Failure, Unit>> putData<T>({
    required String boxName,
    required String key,
    required T value,
  }) async {
    try {
      if (!_hive.isBoxOpen(boxName)) {
        await _hive.openBox<T>(boxName);
      }
      // create value by key in the box
      final box = _hive.box<T>(boxName);
      await box.put(key, value);
      AppStrings.info(
        tag: "HiveService.putData",
        message: "Data put successfully in box $boxName",
      );
      return const Right(unit);
    } on HiveError catch (e) {
      AppStrings.error(
        tag: "HiveService.putData",
        message: "Hive error: ${e.message}",
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      AppStrings.error(
        tag: "HiveService.putData",
        message: "Error put data: ${e.toString()}",
      );
      return Left(UnknownFailure());
    }
  }

  /// === READ DATA ===
  Future<Either<Failure, T?>> getData<T>(String boxName, String key) async {
    try {
      if (!_hive.isBoxOpen(boxName)) {
        await _hive.openBox<T>(boxName);
      }
      // read data by key from the box
      final box = _hive.box<T>(boxName);
      final data = box.get(key);
      AppStrings.info(
        tag: "HiveService.getData",
        message: "Data got successfully from box $boxName",
      );
      return Right(data);
    } on HiveError catch (e) {
      AppStrings.error(
        tag: "HiveService.getData",
        message: "Hive error: ${e.message}",
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      AppStrings.error(
        tag: "HiveService.getData",
        message: "Error get data: ${e.toString()}",
      );
      return Left(UnknownFailure());
    }
  }

  /// === READ ALL ===
  Future<Either<Failure, List<T>>> getAllData<T>(String boxName) async {
    try {
      if (!_hive.isBoxOpen(boxName)) {
        await _hive.openBox<T>(boxName);
      }
      // read all data from the box
      final box = _hive.box<T>(boxName);
      final data = box.values.toList().cast<T>();
      AppStrings.info(
        tag: "HiveService.getAllData",
        message: "All data got successfully from box $boxName",
      );
      return Right(data);
    } on HiveError catch (e) {
      AppStrings.error(
        tag: "HiveService.getAllData",
        message: "Hive error: ${e.message}",
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      AppStrings.error(
        tag: "HiveService.getAllData",
        message: "Error get all data: ${e.toString()}",
      );
      return Left(UnknownFailure());
    }
  }

  /// === UPDATE DATA ===
  Future<Either<Failure, Unit>> updateData<T>(
    String boxName,
    String key,
    T value,
  ) async {
    try {
      if (!_hive.isBoxOpen(boxName)) {
        await _hive.openBox<T>(boxName);
      }
      // update data by key in the box
      final box = _hive.box<T>(boxName);
      await box.put(key, value);
      AppStrings.info(
        tag: "HiveService.updateData",
        message: "Data updated successfully in box $boxName",
      );
      return const Right(unit);
    } on HiveError catch (e) {
      AppStrings.error(
        tag: "HiveService.updateData",
        message: "Hive error: ${e.message}",
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      AppStrings.error(
        tag: "HiveService.updateData",
        message: "Error update data: ${e.toString()}",
      );
      return Left(UnknownFailure());
    }
  }

  /// === DELETE DATA ===
  Future<Either<Failure, Unit>> deleteData<T>(
    String boxName,
    String key,
  ) async {
    try {
      if (!_hive.isBoxOpen(boxName)) {
        await _hive.openBox<T>(boxName);
      }
      // delete data by key in the box
      final box = _hive.box<T>(boxName);
      await box.delete(key);
      AppStrings.info(
        tag: "HiveService.deleteData",
        message: "Data deleted successfully from box $boxName",
      );
      return const Right(unit);
    } on HiveError catch (e) {
      AppStrings.error(
        tag: "HiveService.deleteData",
        message: "Hive error: ${e.message}",
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      AppStrings.error(
        tag: "HiveService.deleteData",
        message: "Error delete data: ${e.toString()}",
      );
      return Left(UnknownFailure());
    }
  }

  /// === DELETE ALL DATA ===
  Future<Either<Failure, Unit>> deleteAllData<T>(String boxName) async {
    try {
      if (!_hive.isBoxOpen(boxName)) {
        await _hive.openBox<T>(boxName);
      }
      // delete all data in the box
      final box = _hive.box<T>(boxName);
      await box.deleteAll(box.keys);
      AppStrings.info(
        tag: "HiveService.deleteAllData",
        message: "All data deleted successfully from box $boxName",
      );
      return const Right(unit);
    } on HiveError catch (e) {
      AppStrings.error(
        tag: "HiveService.deleteAllData",
        message: "Hive error: ${e.message}",
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      AppStrings.error(
        tag: "HiveService.deleteAllData",
        message: "Error delete all data: ${e.toString()}",
      );
      return Left(UnknownFailure());
    }
  }

  /// === CLEAR BOX ===
  Future<Either<Failure, Unit>> clearBox<T>(String boxName) async {
    try {
      if (!_hive.isBoxOpen(boxName)) {
        await _hive.openBox<T>(boxName);
      }
      // clear all data in the box
      final box = _hive.box<T>(boxName);
      await box.clear();
      AppStrings.info(
        tag: "HiveService.clearBox",
        message: "Box cleared successfully",
      );
      return const Right(unit);
    } on HiveError catch (e) {
      AppStrings.error(
        tag: "HiveService.clearBox",
        message: "Hive error: ${e.message}",
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      AppStrings.error(
        tag: "HiveService.clearBox",
        message: "Error clear box: ${e.toString()}",
      );
      return Left(UnknownFailure());
    }
  }
}

/// Isolated HiveService
class IsolatedHiveService {
  final IsolatedHiveInterface _hive = IsolatedHive;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await _hive.init(dir.path);
    _hive.registerAdapters();
  }

  Future<Either<Failure, Unit>> putData<T>(
    String boxName,
    String key,
    T value,
  ) async {
    try {
      if (!_hive.isBoxOpen(boxName)) {
        await _hive.openBox<T>(boxName);
      }
      final box = _hive.box<T>(boxName);
      await box.put(key, value);
      AppStrings.info(
        tag: "IsolatedHiveService.putData",
        message: "Data put successfully in box $boxName",
      );
      box.close();
      return const Right(unit);
    } on HiveError catch (e) {
      AppStrings.error(
        tag: "IsolatedHiveService.putData",
        message: "Hive error: ${e.message}",
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      AppStrings.error(
        tag: "IsolatedHiveService.putData",
        message: "Error put data: ${e.toString()}",
      );
      return Left(UnknownFailure());
    }
  }
}

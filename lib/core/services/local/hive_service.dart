// == HiveService ==
import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoon/core/services/local/hive_box_names.dart';
import 'package:todoon/core/utils/error_handler.dart';

import 'package:todoon/core/utils/result_type.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  final HiveInterface _hive = Hive;
  static final List<String> _boxNames = HiveBoxNames.all;

  // == Init ==
  static Future<HiveService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await _instance._hive.initFlutter(dir.path);
    for (final name in _boxNames) {
      await _instance._hive.openBox(name);
    }
    return _instance;
  }

  // == Read ==
  Either<Failure, T?> get<T>(String boxName, String key) {
    try {
      final box = _hive.box(boxName);
      final value = box.get(key);
      return Right(value as T?);
    } catch (e) {
      return Left(DataSource.CACHE_ERROR.getFailure());
    }
  }

  // == Write ==
  Future<Either<Failure, Unit>> put<T>(
    String boxName,
    String key,
    T value,
  ) async {
    try {
      final box = _hive.box(boxName);
      await box.put(key, value);
      return const Right(unit);
    } catch (e) {
      return Left(LocalStorageFailure(e.toString()));
    }
  }

  // == Delete ===
  Future<Either<Failure, Unit>> delete(String boxName, String key) async {
    try {
      final box = _hive.box(boxName);
      await box.delete(key);
      return const Right(unit);
    } catch (e) {
      return Left(LocalStorageFailure(e.toString()));
    }
  }

  // == Clear ===
  Future<Either<Failure, Unit>> clear(String boxName) async {
    try {
      final box = _hive.box(boxName);
      await box.clear();
      return const Right(unit);
    } catch (e) {
      return Left(LocalStorageFailure(e.toString()));
    }
  }

  // == Close ==
  Future<Either<Failure, Unit>> close() async {
    try {
      await _hive.close();
      return const Right(unit);
    } catch (e) {
      return Left(LocalStorageFailure(e.toString()));
    }
  }

  // == Get All ==
  Either<Failure, List<T>> getAll<T>(String boxName) {
    try {
      final box = _hive.box(boxName);
      return Right(box.values.cast<T>().toList());
    } catch (e) {
      return Left(LocalStorageFailure(e.toString()));
    }
  }
}

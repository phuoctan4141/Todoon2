import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/failure.dart';

abstract class BaseLocalDataSource<T> {
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, T?>> getById(String id);
  Future<Either<Failure, Unit>> add(T data);
  Future<Either<Failure, Unit>> update(T data);
  Future<Either<Failure, Unit>> delete(String id);
  Future<Either<Failure, Unit>> softDelete(T data);
}

abstract class BaseRemoteDataSource<T> {
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, T?>> getById(String id);
  Future<Either<Failure, Unit>> add(T data);
  Future<Either<Failure, Unit>> update(T data);
  Future<Either<Failure, Unit>> delete(String id);
  Future<Either<Failure, Unit>> softDelete(T data);
}

import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/failure.dart';

abstract class UseCase<Params, T> {
  Future<Either<Failure, T>> execute(Params params);
}

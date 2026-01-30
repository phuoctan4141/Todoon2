import 'package:dartz/dartz.dart';
import 'package:todoon/core/utils/error_handler.dart';

class Failure {
  final int code;
  final String message;

  Failure(this.code, this.message);
}

class DefaultFailure extends Failure {
  DefaultFailure() : super(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
}

// Network Failure
class NoInternetFailure extends Failure {
  NoInternetFailure()
    : super(
        ResponseCode.NO_INTERNET_CONNECTION,
        ResponseMessage.NO_INTERNET_CONNECTION,
      );
}

class TimeoutFailure extends Failure {
  TimeoutFailure()
    : super(ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT);
}

class PermissionDeniedFailure extends Failure {
  PermissionDeniedFailure()
    : super(ResponseCode.PERMISSION_DENIED, ResponseMessage.PERMISSION_DENIED);
}

class LocalStorageFailure extends Failure {
  LocalStorageFailure(String message)
    : super(ResponseCode.CACHE_ERROR, message);
}

Failure? firstFailureOf(List<Either<Failure, Object>> list) {
  for (final e in list) {
    final left = e.fold<Failure?>((f) => f, (_) => null);
    if (left != null) return left;
  }
  return null;
}

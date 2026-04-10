import 'error_handler.dart';

class Failure {
  final int code;
  final String message;

  Failure(this.code, this.message);
}

class LocalDataFailure extends Failure {
  LocalDataFailure({String? message})
    : super(
        ResponseCode.LOCAL_DATA_ERROR,
        message ?? ResponseMessage.LOCAL_DATA_ERROR,
      );
}

class NoInternetFailure extends Failure {
  NoInternetFailure()
    : super(
        ResponseCode.NO_INTERNET_CONNECTION,
        ResponseMessage.NO_INTERNET_CONNECTION,
      );
}

class PermissionDeniedFailure extends Failure {
  PermissionDeniedFailure()
    : super(ResponseCode.PERMISSION_DENIED, ResponseMessage.PERMISSION_DENIED);
}

class TimeoutFailure extends Failure {
  TimeoutFailure()
    : super(ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT);
}

class UnknownFailure extends Failure {
  UnknownFailure({String? message})
    : super(ResponseCode.UNKNOWN, message ?? ResponseMessage.UNKNOWN);
}

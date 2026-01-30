import 'package:firebase_auth/firebase_auth.dart';

import 'result_type.dart';

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTHORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  BAD_CERTIFICATE,
  CONNECTION_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECEIVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is FirebaseException) {
      failure = _handleFirebaseError(error);
    } else {
      failure = DataSource.DEFAULT.getFailure();
    }
  }

  Failure _handleFirebaseError(FirebaseException error) {
    switch (error.code) {
      /// ===== AUTH =====
      case 'invalid-email':
        return Failure(
          ResponseCode.BAD_REQUEST,
          ResponseMessage.AUTH_INVALID_EMAIL,
        );
      case 'user-disabled':
        return Failure(
          ResponseCode.UNAUTHORISED,
          ResponseMessage.AUTH_USER_DISABLED,
        );
      case 'user-not-found':
        return Failure(
          ResponseCode.NOT_FOUND,
          ResponseMessage.AUTH_USER_NOT_FOUND,
        );
      case 'wrong-password':
        return Failure(
          ResponseCode.UNAUTHORISED,
          ResponseMessage.AUTH_WRONG_PASSWORD,
        );
      case 'email-already-in-use':
        return Failure(
          ResponseCode.BAD_REQUEST,
          ResponseMessage.AUTH_EMAIL_ALREADY_IN_USE,
        );
      case 'operation-not-allowed':
        return Failure(
          ResponseCode.FORBIDDEN,
          ResponseMessage.AUTH_OPERATION_NOT_ALLOWED,
        );
      case 'weak-password':
        return Failure(
          ResponseCode.BAD_REQUEST,
          ResponseMessage.AUTH_WEAK_PASSWORD,
        );
      case 'invalid-credential':
        return Failure(
          ResponseCode.UNAUTHORISED,
          ResponseMessage.AUTH_INVALID_CREDENTIAL,
        );
      case 'too-many-requests':
        return Failure(
          ResponseCode.CONNECTION_ERROR,
          ResponseMessage.AUTH_TOO_MANY_REQUESTS,
        );
      case 'network-request-failed':
        return Failure(
          ResponseCode.NO_INTERNET_CONNECTION,
          ResponseMessage.AUTH_NETWORK_REQUEST_FAILED,
        );

      /// ===== FIRESTORE =====
      case 'cancelled':
        return Failure(ResponseCode.CANCEL, ResponseMessage.FS_CANCELLED);
      case 'unknown':
        return Failure(ResponseCode.DEFAULT, ResponseMessage.FS_UNKNOWN);
      case 'invalid-argument':
        return Failure(
          ResponseCode.BAD_REQUEST,
          ResponseMessage.FS_INVALID_ARGUMENT,
        );
      case 'deadline-exceeded':
        return Failure(
          ResponseCode.CONNECT_TIMEOUT,
          ResponseMessage.FS_DEADLINE_EXCEEDED,
        );
      case 'not-found':
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.FS_NOT_FOUND);
      case 'already-exists':
        return Failure(
          ResponseCode.BAD_REQUEST,
          ResponseMessage.FS_ALREADY_EXISTS,
        );
      case 'permission-denied':
        return Failure(
          ResponseCode.FORBIDDEN,
          ResponseMessage.FS_PERMISSION_DENIED,
        );
      case 'resource-exhausted':
        return Failure(
          ResponseCode.CONNECTION_ERROR,
          ResponseMessage.FS_RESOURCE_EXHAUSTED,
        );
      case 'failed-precondition':
        return Failure(
          ResponseCode.BAD_REQUEST,
          ResponseMessage.FS_FAILED_PRECONDITION,
        );
      case 'aborted':
        return Failure(ResponseCode.CANCEL, ResponseMessage.FS_ABORTED);
      case 'out-of-range':
        return Failure(
          ResponseCode.BAD_REQUEST,
          ResponseMessage.FS_OUT_OF_RANGE,
        );
      case 'unimplemented':
        return Failure(ResponseCode.DEFAULT, ResponseMessage.FS_UNIMPLEMENTED);
      case 'internal':
        return Failure(
          ResponseCode.INTERNAL_SERVER_ERROR,
          ResponseMessage.FS_INTERNAL,
        );
      case 'unavailable':
        return Failure(
          ResponseCode.NO_INTERNET_CONNECTION,
          ResponseMessage.FS_UNAVAILABLE,
        );
      case 'data-loss':
        return Failure(
          ResponseCode.INTERNAL_SERVER_ERROR,
          ResponseMessage.FS_DATA_LOSS,
        );
      case 'unauthenticated':
        return Failure(
          ResponseCode.UNAUTHORISED,
          ResponseMessage.FS_UNAUTHENTICATED,
        );

      /// ===== STORAGE =====
      case 'unauthorized':
        return Failure(
          ResponseCode.UNAUTHORISED,
          ResponseMessage.ST_UNAUTHORIZED,
        );
      case 'object-not-found':
        return Failure(
          ResponseCode.NOT_FOUND,
          ResponseMessage.ST_OBJECT_NOT_FOUND,
        );
      case 'bucket-not-found':
        return Failure(
          ResponseCode.NOT_FOUND,
          ResponseMessage.ST_BUCKET_NOT_FOUND,
        );
      case 'project-not-found':
        return Failure(
          ResponseCode.NOT_FOUND,
          ResponseMessage.ST_PROJECT_NOT_FOUND,
        );
      case 'quota-exceeded':
        return Failure(
          ResponseCode.CONNECTION_ERROR,
          ResponseMessage.ST_QUOTA_EXCEEDED,
        );
      case 'retry-limit-exceeded':
        return Failure(
          ResponseCode.CONNECTION_ERROR,
          ResponseMessage.ST_RETRY_LIMIT_EXCEEDED,
        );
      case 'invalid-checksum':
        return Failure(
          ResponseCode.BAD_REQUEST,
          ResponseMessage.ST_INVALID_CHECKSUM,
        );
      case 'canceled':
        return Failure(ResponseCode.CANCEL, ResponseMessage.ST_CANCELLED);
      case 'download-size-exceeded':
        return Failure(
          ResponseCode.BAD_REQUEST,
          ResponseMessage.ST_DOWNLOAD_SIZE_EXCEEDED,
        );

      /// ===== DEFAULT =====
      default:
        return DataSource.DEFAULT.getFailure();
    }
  }
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTHORISED:
        return Failure(ResponseCode.UNAUTHORISED, ResponseMessage.UNAUTHORISED);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(
          ResponseCode.INTERNAL_SERVER_ERROR,
          ResponseMessage.INTERNAL_SERVER_ERROR,
        );
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
          ResponseCode.CONNECT_TIMEOUT,
          ResponseMessage.CONNECT_TIMEOUT,
        );
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      case DataSource.RECEIVE_TIMEOUT:
        return Failure(
          ResponseCode.RECEIVE_TIMEOUT,
          ResponseMessage.RECEIVE_TIMEOUT,
        );
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(
          ResponseCode.NO_INTERNET_CONNECTION,
          ResponseMessage.NO_INTERNET_CONNECTION,
        );
      case DataSource.BAD_CERTIFICATE:
        return Failure(
          ResponseCode.BAD_CERTIFICATE,
          ResponseMessage.BAD_CERTIFICATE,
        );
      case DataSource.CONNECTION_ERROR:
        return Failure(
          ResponseCode.CONNECTION_ERROR,
          ResponseMessage.CONNECTION_ERROR,
        );
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
      default:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}

class ResponseCode {
  // API status codes
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no content
  static const int BAD_REQUEST = 400; // failure, api rejected the request
  static const int FORBIDDEN = 403; // failure, api rejected the request
  static const int UNAUTHORISED = 401; // failure user is not authorised
  static const int NOT_FOUND =
      404; // failure, api url is not correct and not found
  static const int INTERNAL_SERVER_ERROR =
      500; // failure, crash happened in server side
  static const int BAD_CERTIFICATE =
      495; // the certificate of the response is not approved
  static const int CONNECTION_ERROR = 504; // the connection errored

  // local status code
  static const int DEFAULT = -1;
  static const int CONNECT_TIMEOUT = -2;
  static const int CANCEL = -3;
  static const int RECEIVE_TIMEOUT = -4;
  static const int SEND_TIMEOUT = -5;
  static const int CACHE_ERROR = -6;
  static const int NO_INTERNET_CONNECTION = -7;
  static const int PERMISSION_DENIED = -8;
}

class ResponseMessage {
  // ===== API / generic =====
  static const String SUCCESS = "ResMes.success";
  static const String NO_CONTENT = "ResMes.noContent";
  static const String BAD_REQUEST = "ResMes.badRequestError";
  static const String FORBIDDEN = "ResMes.forbiddenError";
  static const String UNAUTHORISED = "ResMes.unauthorizedError";
  static const String NOT_FOUND = "ResMes.notFoundError";
  static const String INTERNAL_SERVER_ERROR = "ResMes.internalServerError";
  static const String BAD_CERTIFICATE = "ResMes.badCertificate";
  static const String CONNECTION_ERROR = "ResMes.connectionError";

  // ===== FirebaseAuth =====
  static const String AUTH_INVALID_EMAIL = "ResMes.authInvalidEmail";
  static const String AUTH_USER_DISABLED = "ResMes.authUserDisabled";
  static const String AUTH_USER_NOT_FOUND = "ResMes.authUserNotFound";
  static const String AUTH_WRONG_PASSWORD = "ResMes.authWrongPassword";
  static const String AUTH_EMAIL_ALREADY_IN_USE =
      "ResMes.authEmailAlreadyInUse";
  static const String AUTH_OPERATION_NOT_ALLOWED =
      "ResMes.authOperationNotAllowed";
  static const String AUTH_WEAK_PASSWORD = "ResMes.authWeakPassword";
  static const String AUTH_INVALID_CREDENTIAL = "ResMes.authInvalidCredential";
  static const String AUTH_TOO_MANY_REQUESTS = "ResMes.authTooManyRequests";
  static const String AUTH_NETWORK_REQUEST_FAILED =
      "ResMes.authNetworkRequestFailed";

  // ===== Firestore =====
  static const String FS_PERMISSION_DENIED = "ResMes.fsPermissionDenied";
  static const String FS_NOT_FOUND = "ResMes.fsNotFound";
  static const String FS_UNAVAILABLE = "ResMes.fsUnavailable";
  static const String FS_CANCELLED = "ResMes.cancelled";
  static const String FS_UNKNOWN = "ResMes.fsUnknown";
  static const String FS_INVALID_ARGUMENT = "ResMes.fsInvalidArgument";
  static const String FS_DEADLINE_EXCEEDED = "ResMes.fsDeadlineExceeded";
  static const String FS_ALREADY_EXISTS = "ResMes.fsAlreadyExists";
  static const String FS_RESOURCE_EXHAUSTED = "ResMes.fsResourceExhausted";
  static const String FS_FAILED_PRECONDITION = "ResMes.fsFailedPrecondition";
  static const String FS_ABORTED = "ResMes.fsAborted";
  static const String FS_OUT_OF_RANGE = "ResMes.fsOutOfRange";
  static const String FS_UNIMPLEMENTED = "ResMes.fsUnimplemented";
  static const String FS_INTERNAL = "ResMes.fsInternal";
  static const String FS_DATA_LOSS = "ResMes.fsDataLoss";
  static const String FS_UNAUTHENTICATED = "ResMes.fsUnauthenticated";

  // ===== Firebase Storage =====
  static const String ST_UNAUTHORIZED = "ResMes.stUnauthorized";
  static const String ST_OBJECT_NOT_FOUND = "ResMes.stObjectNotFound";
  static const String ST_BUCKET_NOT_FOUND = "ResMes.stBucketNotFound";
  static const String ST_PROJECT_NOT_FOUND = "ResMes.stProjectNotFound";
  static const String ST_QUOTA_EXCEEDED = "ResMes.stQuotaExceeded";
  static const String ST_RETRY_LIMIT_EXCEEDED = "ResMes.stRetryLimitExceeded";
  static const String ST_CANCELLED = "ResMes.cancelled";
  static const String ST_INVALID_CHECKSUM = "ResMes.stInvalidChecksum";
  static const String ST_DOWNLOAD_SIZE_EXCEEDED =
      "ResMes.stDownloadSizeExceeded";

  // ===== Local / connectivity =====
  static const String DEFAULT = "ResMes.defaultError";
  static const String CONNECT_TIMEOUT = "ResMes.timeoutError";
  static const String CANCEL = "ResMes.defaultError";
  static const String RECEIVE_TIMEOUT = "ResMes.timeoutError";
  static const String SEND_TIMEOUT = "ResMes.timeoutError";
  static const String CACHE_ERROR = "ResMes.defaultError";
  static const String NO_INTERNET_CONNECTION = "ResMes.noInternetError";
  static const String PERMISSION_DENIED = "ResMes.fsPermissionDenied";
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';

import 'failure.dart';

enum DataSource {
  // Success
  SUCCESS,
  NO_CONTENT,
  // Client
  BAD_REQUEST,
  UNAUTHORIZED,
  FORBIDDEN,
  NOT_FOUND,
  // Server
  INTERNAL_SERVER_ERROR,
  SERVER_UNAVAILABLE,
  // Network
  NO_INTERNET_CONNECTION,
  NETWORK_UNAVAILABLE,
  CONNECTION_ERROR,
  CONNECT_TIMEOUT,
  SEND_TIMEOUT,
  RECEIVE_TIMEOUT,
  CANCEL,
  // Sync (offline-first)
  SYNC_FAILED,
  SYNC_IN_PROGRESS,
  SYNC_CONFLICT,
  STALE_DATA,
  OFFLINE_MODE,
  // Local Data
  LOCAL_DATA_ERROR,
  // Other
  BAD_CERTIFICATE,
  PERMISSION_DENIED,
  UNKNOWN,
}

/// Error Handler
class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is FirebaseException) {
      failure = _handleFirebaseError(error);
    } else if (error is HiveError) {
      failure = _handleHiveError(error);
    } else if (error is TimeoutException) {
      failure = TimeoutFailure();
    } else {
      failure = UnknownFailure(message: error.toString());
    }
  }

  /// Handle Firebase Error
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
          ResponseCode.UNAUTHORIZED,
          ResponseMessage.AUTH_USER_DISABLED,
        );
      case 'user-not-found':
        return Failure(
          ResponseCode.NOT_FOUND,
          ResponseMessage.AUTH_USER_NOT_FOUND,
        );
      case 'wrong-password':
        return Failure(
          ResponseCode.UNAUTHORIZED,
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
          ResponseCode.UNAUTHORIZED,
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
        return Failure(ResponseCode.UNKNOWN, ResponseMessage.FS_UNKNOWN);
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
        return Failure(ResponseCode.UNKNOWN, ResponseMessage.FS_UNIMPLEMENTED);
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
          ResponseCode.UNAUTHORIZED,
          ResponseMessage.FS_UNAUTHENTICATED,
        );

      /// ===== DEFAULT =====
      default:
        return DataSource.UNKNOWN.getFailure();
    }
  }

  /// Handle Hive Error
  /// Handle Hive Error
  Failure _handleHiveError(HiveError error) {
    final message = error.message.toLowerCase();

    if (message.contains('not opened')) {
      return Failure(ResponseCode.LOCAL_DATA_ERROR, ResponseMessage.NOT_FOUND);
    } else if (message.contains('unknown type')) {
      return Failure(
        ResponseCode.LOCAL_DATA_ERROR,
        ResponseMessage.BAD_REQUEST,
      );
    } else if (message.contains('not found') ||
        message.contains('does not exist')) {
      return Failure(ResponseCode.LOCAL_DATA_ERROR, ResponseMessage.NO_CONTENT);
    } else if (message.contains('already open') ||
        message.contains('already opened')) {
      return LocalDataFailure(message: error.toString());
    } else if (message.contains('invalid key')) {
      return Failure(
        ResponseCode.LOCAL_DATA_ERROR,
        ResponseMessage.BAD_REQUEST,
      );
    } else if (message.contains('compaction') ||
        message.contains('corrupted')) {
      return LocalDataFailure(message: error.toString());
    } else {
      return LocalDataFailure(message: error.toString());
    }
  }
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
      case DataSource.UNAUTHORIZED:
        return Failure(ResponseCode.UNAUTHORIZED, ResponseMessage.UNAUTHORIZED);
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(
          ResponseCode.INTERNAL_SERVER_ERROR,
          ResponseMessage.INTERNAL_SERVER_ERROR,
        );
      case DataSource.SERVER_UNAVAILABLE:
        return Failure(
          ResponseCode.SERVER_UNAVAILABLE,
          ResponseMessage.SERVER_UNAVAILABLE,
        );
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(
          ResponseCode.NO_INTERNET_CONNECTION,
          ResponseMessage.NO_INTERNET_CONNECTION,
        );
      case DataSource.NETWORK_UNAVAILABLE:
        return Failure(
          ResponseCode.NETWORK_UNAVAILABLE,
          ResponseMessage.NETWORK_UNAVAILABLE,
        );
      case DataSource.CONNECTION_ERROR:
        return Failure(
          ResponseCode.CONNECTION_ERROR,
          ResponseMessage.CONNECTION_ERROR,
        );
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
          ResponseCode.CONNECT_TIMEOUT,
          ResponseMessage.CONNECT_TIMEOUT,
        );
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.RECEIVE_TIMEOUT:
        return Failure(
          ResponseCode.RECEIVE_TIMEOUT,
          ResponseMessage.RECEIVE_TIMEOUT,
        );
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      case DataSource.SYNC_FAILED:
        return Failure(ResponseCode.SYNC_FAILED, ResponseMessage.SYNC_FAILED);
      case DataSource.SYNC_IN_PROGRESS:
        return Failure(
          ResponseCode.SYNC_IN_PROGRESS,
          ResponseMessage.SYNC_IN_PROGRESS,
        );
      case DataSource.SYNC_CONFLICT:
        return Failure(
          ResponseCode.SYNC_CONFLICT,
          ResponseMessage.SYNC_CONFLICT,
        );
      case DataSource.STALE_DATA:
        return Failure(ResponseCode.STALE_DATA, ResponseMessage.STALE_DATA);
      case DataSource.OFFLINE_MODE:
        return Failure(ResponseCode.OFFLINE_MODE, ResponseMessage.OFFLINE_MODE);
      case DataSource.LOCAL_DATA_ERROR:
        return Failure(
          ResponseCode.LOCAL_DATA_ERROR,
          ResponseMessage.LOCAL_DATA_ERROR,
        );
      case DataSource.BAD_CERTIFICATE:
        return Failure(
          ResponseCode.BAD_CERTIFICATE,
          ResponseMessage.BAD_CERTIFICATE,
        );
      case DataSource.PERMISSION_DENIED:
        return Failure(
          ResponseCode.PERMISSION_DENIED,
          ResponseMessage.PERMISSION_DENIED,
        );
      case DataSource.UNKNOWN:
        return Failure(ResponseCode.UNKNOWN, ResponseMessage.UNKNOWN);
    }
  }
}

class ResponseCode {
  // Success
  static const int SUCCESS = 200;
  static const int NO_CONTENT = 204;

  // Client errors
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;

  // Server errors
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int SERVER_UNAVAILABLE = 503;

  // Network (custom negative codes)
  static const int NO_INTERNET_CONNECTION = -1;
  static const int NETWORK_UNAVAILABLE = -2;
  static const int CONNECTION_ERROR = -3;

  static const int CONNECT_TIMEOUT = -4;
  static const int SEND_TIMEOUT = -5;
  static const int RECEIVE_TIMEOUT = -6;
  static const int CANCEL = -7;

  static const int BAD_CERTIFICATE = -8;
  static const int PERMISSION_DENIED = -9;

  // Offline-first / Sync
  static const int SYNC_FAILED = -20;
  static const int SYNC_IN_PROGRESS = -21;
  static const int SYNC_CONFLICT = -22;
  static const int STALE_DATA = -23;
  static const int OFFLINE_MODE = -24;

  // Local
  static const int LOCAL_DATA_ERROR = -30;

  // Unknown
  static const int UNKNOWN = -100;
}

class ResponseMessage {
  // ===== Success =====
  static const String SUCCESS = "ResMes.success";
  static const String NO_CONTENT = "ResMes.noContent";

  // ===== Client errors =====
  static const String BAD_REQUEST = "ResMes.badRequest";
  static const String UNAUTHORIZED = "ResMes.unauthorized";
  static const String FORBIDDEN = "ResMes.forbidden";
  static const String NOT_FOUND = "ResMes.notFound";

  // ===== Server errors =====
  static const String INTERNAL_SERVER_ERROR = "ResMes.internalServerError";
  static const String SERVER_UNAVAILABLE = "ResMes.serverUnavailable";

  // ===== Network =====
  static const String NO_INTERNET_CONNECTION = "ResMes.noInternetConnection";
  static const String NETWORK_UNAVAILABLE = "ResMes.networkUnavailable";
  static const String CONNECTION_ERROR = "ResMes.connectionError";
  static const String CONNECT_TIMEOUT = "ResMes.connectTimeout";
  static const String SEND_TIMEOUT = "ResMes.sendTimeout";
  static const String RECEIVE_TIMEOUT = "ResMes.receiveTimeout";
  static const String CANCEL = "ResMes.cancel";
  static const String BAD_CERTIFICATE = "ResMes.badCertificate";
  static const String PERMISSION_DENIED = "ResMes.permissionDenied";

  // ===== Offline-first / Sync =====
  static const String SYNC_FAILED = "ResMes.syncFailed";
  static const String SYNC_IN_PROGRESS = "ResMes.syncInProgress";
  static const String SYNC_CONFLICT = "ResMes.syncConflict";
  static const String STALE_DATA = "ResMes.staleData";
  static const String OFFLINE_MODE = "ResMes.offlineMode";

  // ===== Local =====
  static const String LOCAL_DATA_ERROR = "ResMes.localDataError";

  // ===== Unknown =====
  static const String UNKNOWN = "ResMes.unknown";

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
}

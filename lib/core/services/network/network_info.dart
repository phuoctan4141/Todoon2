import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _internetConnectionChecker;

  NetworkInfoImpl(this._internetConnectionChecker);

  Stream<InternetConnectionStatus> get onStatusChange =>
      _internetConnectionChecker.onStatusChange;

  @override
  Future<bool> get isConnected => _internetConnectionChecker.hasConnection;
}

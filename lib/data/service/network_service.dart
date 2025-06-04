import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  Stream<bool> get isConnectedStream => Connectivity()
      .onConnectivityChanged
      .map((result) => !result.contains(ConnectivityResult.none));
}

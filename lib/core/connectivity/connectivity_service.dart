import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

final class ConnectivityService {
  ConnectivityService() : _plugin = Connectivity();

  final Connectivity _plugin;

  Future<bool> checkOnline() async {
    final list = await _plugin.checkConnectivity();
    return _isConnectedList(list);
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _plugin.onConnectivityChanged;
  }

  bool _isConnectedList(List<ConnectivityResult> list) {
    if (list.isEmpty) {
      return false;
    }
    return !list.every((e) => e == ConnectivityResult.none);
  }
}

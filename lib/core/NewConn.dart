
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConn {
  final Connectivity _connectivity = Connectivity();

  Future <bool> check() async{
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    return  true;

}
  Future<bool> _updateConnectionStatus(List<ConnectivityResult> connectivityResult) async {
    return  true;
  }

}





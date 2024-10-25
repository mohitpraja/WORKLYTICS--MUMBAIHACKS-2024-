import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckConn {
  final Connectivity _connectivity = Connectivity();
  RxBool isNetworkAvailable = false.obs;

  Future <bool> check() async {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    return true;
  }

  Future<void> _updateConnectionStatus(
      List<ConnectivityResult> connectivityResult) async {
    debugPrint("ConnectivityResult ======== $connectivityResult");
    if (connectivityResult.contains(ConnectivityResult.none)) {
      isNetworkAvailable.value = false;
    }
    else if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn)) {
      isNetworkAvailable.value = true;
    }
  }

}
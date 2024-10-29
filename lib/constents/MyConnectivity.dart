import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    print("ConnectivityResult.. " + ConnectivityResult.values.toString());
    try {
      if (result == ConnectivityResult.mobile) {
        isOnline = true;
      } else if (result == ConnectivityResult.wifi) {
        isOnline = true;
      } else if (result == ConnectivityResult.ethernet) {
        isOnline = true;
      } else if (result == ConnectivityResult.bluetooth) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
      print("excpeotionnn..  ");
    }
    _controller.sink.add({"result": isOnline});
  }

  void disposeStream() => _controller.close();
}

import 'dart:async';
import 'dart:developer';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/toast.dart';

import '../constents/MyConnectivity.dart';
import '../constents/internetConnectionDialog.dart';
import '../utils/app_constents.dart';
import '../utils/user_session.dart';
import 'dashboard/controller/home_controller.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _size = 20.0;
  bool _large = false;
  final MyConnectivity _connectivity = MyConnectivity.instance;
  HomeController homeController = HomeController();
  RxBool isLoading = false.obs;

  @override
  void initState() {
    FlutterNativeSplash.remove();

    log("source.. splash screen");
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      log("source..  $source");
      log("source..  ${source["result"]}");
      FBroadcast.instance().broadcast("network", value: source["result"]);
    });
    //locationPermission();

    Timer(const Duration(seconds: 1), () {
      _large = true;
      setState(() {
        _size = _large ? 200.0 : 30.0;
      });
    });
    Timer(
        const Duration(seconds: 3),
        () => Helper.verifyInternet().then((intenet) async {
              // ignore: unnecessary_null_comparison
              if (intenet != null && intenet) {
                navigateToNextScreen();
              } else {
                Get.dialog(WillPopScope(
                    onWillPop: () async => false,
                    child: InternetConnectionDialog()));
              }
            }));
    super.initState();
  }

  navigateToNextScreen() {
    print("-=-=-=-");
    var isLoggedIn = UserSession.getBoolFromSession(UserSession.keyIsLoggedIn);
    print("isLoggedIn....   " + isLoggedIn.toString());
    if (isLoggedIn == true) {
      // SocketConnection.connectToServer();
      homeController.BookingStatusThroughFirebase(false);
    } else {
      Get.offAllNamed("LoginScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ConstColor.codeBackgroundColor,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            AnimatedContainer(
              height: _size,
              width: _size,
              alignment: AlignmentDirectional.center,
              duration: const Duration(seconds: 3),
              curve: Curves.fastOutSlowIn,
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    AppConstents.splashScreenGif,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

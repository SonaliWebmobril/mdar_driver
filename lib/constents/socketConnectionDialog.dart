import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/design/auth_design/custom_widget/commonbutton.dart';
import 'package:madr_driver/services/api_sevices.dart';
import 'package:madr_driver/socket_connection/socket_connection.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/style.dart';
import 'package:madr_driver/utils/user_session.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../design/dashboard/controller/home_controller.dart';
import '../design/splash_screen.dart';
import '../utils/toast.dart';

class SocketConnectionDialog extends StatelessWidget {
  SocketConnectionDialog({super.key});
  var buttonDismiss = false;
  var homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    UserSession.setBoolInSession(UserSession.isDialogOpen, true);
    return Material(
        child: Container(
      color: ConstColor.accentColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsetsDirectional.only(start: 50, end: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/ic_server_err.png",
            width: 120,
            height: 120,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            AppConstents().txtSomethingWrong,
            style: mainTitleStyle,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            AppConstents().txtRefreshPage,
            style: subTitleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 70,
          ),
          Container(
            child: CommonButton(
              title: AppLocalizations.of(Get.key.currentContext!)!.txt_retry,
              onPressed: () async {
                print("button dismiss..    $buttonDismiss");
                await Helper.verifyInternet().then((intenet) async {
                  // ignore: unnecessary_null_comparison
                  print("internet at socket..  " + intenet.toString());
                  if (intenet) {
                    print("buttonDismiss " + buttonDismiss.toString());
                    if (buttonDismiss == false) {
                      buttonDismiss = true;
                      try {
                        print(
                            "keyIsLoggedIn) ${UserSession.getBoolFromSession(UserSession.keyIsLoggedIn)}");
                        if (UserSession.getBoolFromSession(
                                UserSession.keyIsLoggedIn) ==
                            true) {
                          await homeController.ServerBookingStatus();
                          buttonDismiss = true;
                          UserSession.setBoolInSession(
                              UserSession.isDialogOpen, false);
                          print("Get.currentRoute//.... ${Get.currentRoute}");
                        } else {
                          NetworkServices networkServices = NetworkServices();
                          var response = await networkServices.getProfileCall();
                          if (response.responseCode == 200) {
                          } else if (response.responseCode == 401) {
                            await UserSession.clearSession();
                            SocketConnection.socket?.disconnect();
                            SocketConnection.socket?.dispose();
                          }
                          buttonDismiss = true;
                          UserSession.setBoolInSession(
                              UserSession.isDialogOpen, false);
                          if (Get.currentRoute == "/") {
                            Get.offAndToNamed(SplashScreen.routeName);
                          } else {
                            Get.back();
                          }
                        }
                      } catch (e) {
                        print(" socket connection dialog  exp...  $e");
                        buttonDismiss = false;
                      }
                    }
                  } else {
                    buttonDismiss = false;
                    showFlutterToast(
                        message: AppConstents().txtConnectivityAndRetry);
                  }
                });
              },
            ),
          )
        ],
      ),
    ));
  }
}

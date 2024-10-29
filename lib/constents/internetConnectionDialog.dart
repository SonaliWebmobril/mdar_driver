import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/services/api_sevices.dart';
import 'package:madr_driver/socket_connection/socket_connection.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/style.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:madr_driver/utils/user_session.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../design/auth_design/custom_widget/commonbutton.dart';
import '../design/dashboard/controller/home_controller.dart';

class InternetConnectionDialog extends StatelessWidget {
  InternetConnectionDialog({super.key});
  var buttonDismiss = false;
  var homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    UserSession.setBoolInSession(UserSession.isDialogOpen, true);
    return
        // Dialog(
        //   backgroundColor: ConstColor.blackDialogColor,
        //  insetPadding: EdgeInsets.zero,
        //  child:
        Material(
            child: Container(
      color: ConstColor.accentColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsetsDirectional.only(start: 50, end: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/ic_network_err.png",
            width: 120,
            height: 120,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            AppConstents().txtNoNetwork,
            style: mainTitleStyle,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            AppConstents().txtConnectivityAndRetry,
            style: subTitleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 70,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: CommonButton(
              title: AppLocalizations.of(Get.key.currentContext!)!.txt_retry,
              onPressed: () async {
                print("button dismiss..    " + buttonDismiss.toString());

                if (buttonDismiss == false) {
                  buttonDismiss = true;
                  await Helper.verifyInternet().then((intenet) async {
                    // ignore: unnecessary_null_comparison
                    print("internet at socket..  " + intenet.toString());
                    if (intenet) {
                      if (UserSession.getBoolFromSession(
                              UserSession.keyIsLoggedIn) ==
                          true) {
                        await homeController.ServerBookingStatus();
                        buttonDismiss = true;
                        UserSession.setBoolInSession(
                            UserSession.isDialogOpen, false);
                      } else {
                        NetworkServices networkServices = NetworkServices();
                        var response = await networkServices.getProfileCall();
                        print("response... " + response.toString());
                        if (response.responseCode == 200) {
                        } else if (response.responseCode == 401) {
                          await UserSession.clearSession();
                          SocketConnection.socket?.disconnect();
                          SocketConnection.socket?.dispose();
                        }
                        buttonDismiss = true;
                        UserSession.setBoolInSession(
                            UserSession.isDialogOpen, false);
                        Get.back();
                      }
                    } else {
                      buttonDismiss = false;
                      UserSession.setBoolInSession(
                          UserSession.isDialogOpen, true);
                    }
                  });
                }
              },
            ),
          )
        ],
      ),
    ));
  }
}

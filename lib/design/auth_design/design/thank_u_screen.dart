import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/socket_connection/socket_connection.dart';
import 'package:madr_driver/utils/user_session.dart';
import '../../../utils/const_color.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/style.dart';
import '../custom_widget/commonbutton.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThankYouScreen extends StatefulWidget {
  static String routeName = "ThankYouScreen";
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  int addressTypeInitial = 0;

  final isTaxiSelected = List<bool>.generate(15, (int index) => false);

  @override
  void initState() {
    super.initState();
    log("growableList $isTaxiSelected");
  }

  // bool _switchValue = true;
  // bool _enable = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          UserSession.setBoolInSession(UserSession.keyIsLoggedIn, true);
          SocketConnection.connectToServer();
          // await Location.locationPermission();

          var value = await Get.offAllNamed("HomeScreen");
          return value as bool;
        },
        child: Scaffold(
          backgroundColor: ConstColor.codeBackgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: double.maxFinite,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Image.asset(
                          AppConstents.mapBgImg,
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height,
                        ),
                        Container(
                          // height: 320,
                          alignment: AlignmentDirectional.bottomStart,
                          color: Colors.transparent,
                          child: Container(
                            decoration: bottomSheetDecoration,
                            padding: const EdgeInsetsDirectional.only(
                                start: 20, end: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Container(
                                    width: 72,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        color: ConstColor.codeBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Image.asset(
                                    "assets/images/done_button.png",
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: Text(
                                    // AppLocalizations.of(
                                    //         Get.key.currentContext!)!
                                    //     .txt_thank_for_reg,
                                    AppConstents().thanksForRegistration,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: ConstColor.accentColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Center(
                                  child: Text(
                                    AppConstents().checkStatusOnStatusBar,
                                    // AppLocalizations.of(
                                    //             Get.key.currentContext!)!
                                    //         .txt_verify_your_doc +
                                    //     "\n" +
                                    //     AppLocalizations.of(
                                    //             Get.key.currentContext!)!
                                    //         .txt_notify_you,
                                    style: formhintStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 25),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 490,
                                        height: 3,
                                        decoration: BoxDecoration(
                                            color: ConstColor.codeFieldColor,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: Text(
                                          AppLocalizations.of(
                                                  Get.key.currentContext!)!
                                              .txt_active_after_verification,
                                          // AppConstents
                                          //     .txtActiveAfterVerification,
                                          style: TextStyle(
                                              color: ConstColor.accentColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 140,
                                            child: CommonButton(
                                              onPressed: () async {
                                                // Get.toNamed("HomeScreen");
                                                UserSession.setBoolInSession(
                                                    UserSession.keyIsLoggedIn,
                                                    true);
                                                SocketConnection
                                                    .connectToServer();
                                                // await Location
                                                //   .locationPermission();

                                                Get.offAllNamed("HomeScreen");
                                              },
                                              title: AppLocalizations.of(
                                                      Get.key.currentContext!)!
                                                  .txt_ok,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}

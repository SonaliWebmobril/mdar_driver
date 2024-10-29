import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:madr_driver/services/api_sevices.dart';
import 'package:madr_driver/utils/StringExtension.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/style.dart';
import 'package:madr_driver/design/settings/controller/profile_controller.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/const_color.dart';
import '../../../utils/user_session.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = "SettingsScreen";
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var isVerified = false;
  final profileController = Get.find<ProfileController>();
  // var userStatus = "0";
  NetworkServices networkServices = NetworkServices();
  var termsCondition = "";
  var privacyPolicy = "";
  var aboutUs = "";

  @override
  void initState() {
    log("in setting init  ${UserSession.getStringFromSession(UserSession.keyUserStatus)}");
    UserSession.isCurrentLoading = profileController.isLoading;
    termsConditionApi();
    super.initState();
  }

  Future<void> termsConditionApi() async {
    try {
      var response = await networkServices.termsConditionMethod();
      final jsonData = jsonDecode(response);
      if (jsonData['ResponseCode'] == 200) {
        termsCondition = jsonData['ResponseBody']['terms_url'];
        privacyPolicy = jsonData['ResponseBody']['privacy_policy_url'];
        aboutUs = jsonData['ResponseBody']['about_us'];
      } else {
        showFlutterToast(message: response['ResponseMessage'].toString());
      }
    } catch (e) {
      // showFlutterToast(message: e.toString());
      print("termsConditionApi..   $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.accentColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(Get.key.currentContext!)!.txt_menu.toUpperCase(),
          style: buttonBlackTitleStyle,
        ),
        elevation: 0,
        backgroundColor: ConstColor.accentColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset(
              AppConstents.arrowBack,
              color: ConstColor.blackColor,
              height: 20,
              width: 20,
            )),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              child: ListTile(
                onTap: () {
                  Helper.verifyInternet().then((intenet) {
                    // ignore: unnecessary_null_comparison
                    if (intenet != null && intenet) {
                      Get.toNamed("EditProfileScreen");
                    } else {
                      Helper.createSnackBar(context);
                    }
                  });
                },
                title: Text(
                  AppLocalizations.of(Get.key.currentContext!)!
                      .txt_driver_profile,
                  style: black14Normal500,
                ),
                leading: Image.asset(
                  "assets/images/driver_profile.png",
                  color: ConstColor.blackColor,
                  width: 22,
                  height: 22,
                ),
                trailing: Image.asset(AppConstents.arrowFarword,
                    color: ConstColor.blackColor, height: 16, width: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: commonDivider(),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              child: ListTile(
                onTap: () {
                  Helper.verifyInternet().then((intenet) async {
                    // ignore: unnecessary_null_comparison
                    if (intenet != null && intenet) {
                      Get.toNamed("UploadedDocInfoScreen");
                    } else {
                      Helper.createSnackBar(context);
                    }
                  });
                },
                title: Text(
                  (AppLocalizations.of(Get.key.currentContext!)!
                          .txt_uploaded_documents_info)
                      .toTitleCase(),
                  style: black14Normal500,
                ),
                leading: Image.asset(
                  "assets/images/upload_document.png",
                  color: ConstColor.blackColor,
                  width: 22,
                  height: 22,
                ),
                trailing: Image.asset(AppConstents.arrowFarword,
                    color: ConstColor.blackColor, height: 16, width: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: commonDivider(),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              child: ListTile(
                onTap: () {
                  Helper.verifyInternet().then((intenet) async {
                    // ignore: unnecessary_null_comparison
                    if (intenet != null && intenet) {
                      Get.toNamed("AddNewDocumentScreen");
                    } else {
                      Helper.createSnackBar(context);
                    }
                  });
                },
                title: Text(
                  AppConstents().txtUpdateDocuments,
                  style: black14Normal500,
                ),
                leading: Image.asset(
                  "assets/images/new_docs.png",
                  color: ConstColor.blackColor,
                  width: 22,
                  height: 22,
                ),
                trailing: Image.asset(AppConstents.arrowFarword,
                    color: ConstColor.blackColor, height: 16, width: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: commonDivider(),
            ),

            (UserSession.getStringFromSession(UserSession.keyUserStatus) ==
                        "0" ||
                    UserSession.getStringFromSession(
                            UserSession.keyUserStatus) ==
                        "2")
                ? Container()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 18),
                        child: ListTile(
                          onTap: () {
                            Helper.verifyInternet().then((intenet) async {
                              // ignore: unnecessary_null_comparison
                              if (intenet != null && intenet) {
                                Get.toNamed("WalletScreen");
                              } else {
                                Helper.createSnackBar(context);
                              }
                            });
                          },
                          title: Text(
                            AppConstents().Wallet,
                            style: black14Normal500,
                          ),
                          leading: Image.asset(
                            "assets/images/wallet.png",
                            color: ConstColor.blackColor,
                            width: 22,
                            height: 22,
                          ),
                          trailing: Image.asset(AppConstents.arrowFarword,
                              color: ConstColor.blackColor,
                              height: 16,
                              width: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 24),
                        child: commonDivider(),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 18),
                        child: ListTile(
                          onTap: () {
                            Helper.verifyInternet().then((intenet) async {
                              // ignore: unnecessary_null_comparison
                              if (intenet != null && intenet) {
                                Get.toNamed("TransectionHistroyScreen");
                              } else {
                                Helper.createSnackBar(context);
                              }
                            });
                          },
                          title: Text(
                            (AppLocalizations.of(Get.key.currentContext!)!
                                    .txt_transaction_upr)
                                .toTitleCase(),
                            style: black14Normal500,
                          ),
                          leading: Image.asset(
                            "assets/images/transaction.png",
                            color: ConstColor.blackColor,
                            width: 22,
                            height: 22,
                          ),
                          trailing: Image.asset(AppConstents.arrowFarword,
                              color: ConstColor.blackColor,
                              height: 16,
                              width: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 24),
                        child: commonDivider(),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 18),
                        child: ListTile(
                          onTap: () {
                            Helper.verifyInternet().then((intenet) async {
                              // ignore: unnecessary_null_comparison
                              if (intenet != null && intenet) {
                                Get.toNamed("MyTripScreen");
                              } else {
                                Helper.createSnackBar(context);
                              }
                            });
                          },
                          title: Text(
                            AppConstents().txtMyRides,
                            // AppLocalizations.of(Get.key.currentContext!)!
                            //     .txt_my_trip,
                            style: black14Normal500,
                          ),
                          leading: Image.asset(
                            "assets/images/trip.png",
                            color: ConstColor.blackColor,
                            width: 22,
                            height: 22,
                          ),
                          trailing: Image.asset(AppConstents.arrowFarword,
                              color: ConstColor.blackColor,
                              height: 16,
                              width: 16),
                        ),
                      ),
                      //  Padding(
                      //   padding: const EdgeInsetsDirectional.symmetric(
                      //       horizontal: 24),
                      //   child: commonDivider(),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsetsDirectional.symmetric(
                      //       horizontal: 18),
                      //   child: ListTile(
                      //     onTap: () {
                      //       Helper.verifyInternet().then((intenet) async {
                      //         // ignore: unnecessary_null_comparison
                      //         if (intenet != null && intenet) {
                      //           Get.toNamed("SubscriptionPlan");
                      //         } else {
                      //           Helper.createSnackBar(context);
                      //         }
                      //       });
                      //     },
                      //     title: Text(
                      //       AppConstents().txtSubscriptionPlan,
                      //       // AppLocalizations.of(Get.key.currentContext!)!
                      //       //     .txt_my_trip,
                      //       style: black14Normal500,
                      //     ),
                      //     leading: Image.asset(
                      //       "assets/images/pay.png",
                      //       color: ConstColor.blackColor,
                      //       width: 22,
                      //       height: 22,
                      //     ),
                      //     trailing: Image.asset(AppConstents.arrowFarword,
                      //         color: ConstColor.blackColor,
                      //         height: 16,
                      //         width: 16),
                      //   ),
                      // ),
                      //  Padding(
                      //   padding: const EdgeInsetsDirectional.symmetric(
                      //       horizontal: 24),
                      //   child: commonDivider(),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsetsDirectional.symmetric(
                      //       horizontal: 18),
                      //   child: ListTile(
                      //     onTap: () {
                      //       Helper.verifyInternet().then((intenet) async {
                      //         // ignore: unnecessary_null_comparison
                      //         if (intenet != null && intenet) {
                      //           Get.toNamed("FranchisePlan");
                      //         } else {
                      //           Helper.createSnackBar(context);
                      //         }
                      //       });
                      //     },
                      //     title: Text(
                      //       AppConstents().txtFranchise,
                      //       // AppLocalizations.of(Get.key.currentContext!)!
                      //       //     .txt_my_trip,
                      //       style: black14Normal500,
                      //     ),
                      //     leading: Image.asset(
                      //       "assets/images/pay.png",
                      //       color: ConstColor.blackColor,
                      //       width: 22,
                      //       height: 22,
                      //     ),
                      //     trailing: Image.asset(AppConstents.arrowFarword,
                      //         color: ConstColor.blackColor,
                      //         height: 16,
                      //         width: 16),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 24),
                        child: commonDivider(),
                      ),
                    ],
                  ),
            // }),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              child: ListTile(
                onTap: () {
                  Helper.verifyInternet().then((intenet) async {
                    // ignore: unnecessary_null_comparison
                    if (intenet != null && intenet) {
                      Get.toNamed("ChangeLanguage");
                    } else {
                      Helper.createSnackBar(context);
                    }
                  });
                },
                title: Text(
                  AppLocalizations.of(Get.key.currentContext!)!.txt_change_lng,
                  style: black14Normal500,
                ),
                leading: Image.asset(
                  "assets/images/change_language.png",
                  color: ConstColor.blackColor,
                  width: 22,
                  height: 22,
                ),
                trailing: Image.asset(AppConstents.arrowFarword,
                    color: ConstColor.blackColor, height: 16, width: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: commonDivider(),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              child: ListTile(
                onTap: () {
                  Helper.verifyInternet().then((intenet) async {
                    // ignore: unnecessary_null_comparison
                    if (intenet != null && intenet) {
                      Get.toNamed("SupportScreen");
                    } else {
                      Helper.createSnackBar(context);
                    }
                  });
                },
                title: Text(
                  AppLocalizations.of(Get.key.currentContext!)!.txt_support,
                  style: black14Normal500,
                ),
                leading: Image.asset(
                  "assets/images/support.png",
                  color: ConstColor.blackColor,
                  width: 22,
                  height: 22,
                ),
                trailing: Image.asset(AppConstents.arrowFarword,
                    color: ConstColor.blackColor, height: 16, width: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: commonDivider(),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              child: ListTile(
                onTap: () {
                  launchUrl(Uri.parse(aboutUs),
                      mode: LaunchMode.externalApplication);
                },
                title: Text(
                  AppLocalizations.of(Get.key.currentContext!)!.txt_about_us,
                  style: black14Normal500,
                ),
                leading: Image.asset(
                  "assets/images/about_us.png",
                  color: ConstColor.blackColor,
                  width: 22,
                  height: 22,
                ),
                trailing: Image.asset(AppConstents.arrowFarword,
                    color: ConstColor.blackColor, height: 16, width: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: commonDivider(),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              child: ListTile(
                onTap: () {
                  launchUrl(Uri.parse(termsCondition),
                      mode: LaunchMode.externalApplication);
                },
                title: Text(
                  AppLocalizations.of(Get.key.currentContext!)!
                      .txt_terms_condition,
                  style: black14Normal500,
                ),
                leading: Image.asset(
                  "assets/images/term_condition.png",
                  color: ConstColor.blackColor,
                  width: 22,
                  height: 22,
                ),
                trailing: Image.asset(AppConstents.arrowFarword,
                    color: ConstColor.blackColor, height: 16, width: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: commonDivider(),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialogLogut();
                    },
                  );
                },
                title: Text(
                  AppLocalizations.of(Get.key.currentContext!)!.txt_logout,
                  style: black14Normal500,
                ),
                leading: Image.asset(
                  "assets/images/logout.png",
                  color: ConstColor.blackColor,
                  width: 22,
                  height: 22,
                ),
                trailing: Image.asset(AppConstents.arrowFarword,
                    color: ConstColor.blackColor, height: 16, width: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: commonDivider(),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialogDelete();
                    },
                  );
                },
                title: Text(
                  AppConstents().txtDelete,
                  style: black14Normal500,
                ),
                leading: Image.asset(
                  "assets/images/logout.png",
                  color: ConstColor.blackColor,
                  width: 22,
                  height: 22,
                ),
                trailing: Image.asset(AppConstents.arrowFarword,
                    color: ConstColor.blackColor, height: 16, width: 16),
              ),
            ),
          ],
        ),
      )),
    );
    //));
  }
}

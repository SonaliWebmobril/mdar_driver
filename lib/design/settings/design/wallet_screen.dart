import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:madr_driver/utils/user_session.dart';

import '../../../utils/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/app_constents.dart';
import '../../../utils/email_rule.dart';
import '../controller/wallet_controller.dart';

import 'package:group_radio_button/group_radio_button.dart';

class WalletScreen extends StatefulWidget {
  static String routeName = "WalletScreen";
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _walletScreenState();
}

class _walletScreenState extends State<WalletScreen> {
  WalletController walletController = Get.put(WalletController());

  @override
  void initState() {
    super.initState();
    UserSession.isCurrentLoading = walletController.isLoading;
    walletController.getList();
    walletController.mode.value = AppConstents().txtMpesa;
    walletController.status.value = [
      AppLocalizations.of(Get.key.currentContext!)!.txt_online,
      AppLocalizations.of(Get.key.currentContext!)!.txt_cash
    ];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<WalletController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ProgressHUD(
        inAsyncCall: walletController.isLoading.value == true,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: ConstColor.accentColor,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                AppConstents().Wallet,
                style: buttonBlackTitleStyle,
              ),
              elevation: 0,
              backgroundColor: ConstColor.accentColor,
              leading: IconButton(
                  onPressed: () {
                    Get.back(canPop: true);
                  },
                  icon: Image.asset(
                    AppConstents.arrowBack,
                    height: 20,
                    width: 20,
                    color: ConstColor.blackColor,
                  )),
              actions: [
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Get.toNamed("WalletHistory");
                  },
                  child: Container(
                    // height: 40,
                    alignment: AlignmentDirectional.center,
                    margin: const EdgeInsetsDirectional.only(
                      end: 18,
                      top: 14,
                      bottom: 8,
                    ),
                    padding:
                        const EdgeInsetsDirectional.only(start: 16, end: 16),
                    // width: 90,
                    decoration: BoxDecoration(
                      color: ConstColor.codeLogoYellow,
                      // gradient: const LinearGradient(
                      //   begin: AlignmentDirectional.topEnd,
                      //   end: AlignmentDirectional.bottomStart,
                      //   colors: [
                      //     ConstColor.codeFieldColor,
                      //     ConstColor.codeFieldColor,
                      //   ],
                      // ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppConstents().History,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: ConstColor.codeFieldTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // margin: EdgeInsetsDirectional.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          // height: 40,
                          alignment: AlignmentDirectional.center,
                          margin: const EdgeInsetsDirectional.only(
                              end: 24, top: 20, bottom: 10, start: 24),
                          padding: const EdgeInsetsDirectional.only(
                              start: 16, end: 16, top: 40, bottom: 40),
                          // width: 90,
                          decoration: BoxDecoration(
                            color: ConstColor.codeLogoYellow,
                            // gradient: const LinearGradient(
                            //   begin: AlignmentDirectional.topEnd,
                            //   end: AlignmentDirectional.bottomStart,
                            //   colors: [
                            //     ConstColor.codeFieldColor,
                            //     ConstColor.codeFieldColor,
                            //   ],
                            // ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                AppConstents().ToatlAmount,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: ConstColor.codeFieldTextColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(
                                () => Text(
                                  UserSession.getStringFromSession(
                                              UserSession.currencyPosition) ==
                                          "0"
                                      ? "${UserSession.getStringFromSession(UserSession.currencySymbol)} ${walletController.totalAmt.value}"
                                      : "${walletController.totalAmt.value} ${UserSession.getStringFromSession(UserSession.currencySymbol)}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: ConstColor.codeFieldTextColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                      Container(
                        margin: const EdgeInsetsDirectional.only(
                            end: 40, start: 40, bottom: 10, top: 20),

                        alignment: AlignmentDirectional.center,
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(8),
                        //     border: Border.all(color: ConstColor.accentColor, width: 1.0)),
                        child: TextField(
                            style: drawer1TextStyle,
                            textAlign: TextAlign.start,
                            enableInteractiveSelection: false,
                            keyboardType: TextInputType.number,
                            controller: walletController.withdrawalAmount.value,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: ConstColor.blackColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: ConstColor.blackColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsetsDirectional.only(
                                  top: 16, bottom: 16, start: 20, end: 20),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.start,
                              labelText: AppConstents().WithdrawalAmount,
                              labelStyle: const TextStyle(
                                  color: ConstColor.blackColor,
                                  fontSize: 16,
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w400),
                            ),
                            onChanged: (val) {
                              print(
                                  "text on submit   ${walletController.withdrawalAmount.value.text}");
                            }),
                      ),
                      Container(
                        margin: const EdgeInsetsDirectional.only(
                            end: 40, start: 40, bottom: 10, top: 16),
                        alignment: AlignmentDirectional.topStart,
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(8),
                        //     border: Border.all(color: ConstColor.accentColor, width: 1.0)),
                        child: TextField(
                            style: const TextStyle(
                                color: ConstColor.blackColor,
                                fontSize: 15,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w400),
                            maxLines: 5,
                            textAlign: TextAlign.start,
                            enableInteractiveSelection: false,
                            keyboardType: TextInputType.text,
                            controller: walletController.remarkText.value,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: ConstColor.blackColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: ConstColor.blackColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              isDense: false,
                              contentPadding: const EdgeInsetsDirectional.only(
                                  start: 14, end: 14, top: 14, bottom: 10),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.start,
                              labelText: AppConstents().NoteRemark,
                              labelStyle: const TextStyle(
                                  color: ConstColor.blackColor,
                                  fontSize: 16,
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w400),
                            ),
                            onChanged: (val) {
                              print(
                                  "text on submit   ${walletController.withdrawalAmount.value.text}");
                            }),
                      ),
                      Container(
                          margin: const EdgeInsetsDirectional.only(
                              end: 40, start: 40, bottom: 10, top: 16),
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            AppConstents().RequestMode,
                            style: const TextStyle(
                                color: ConstColor.blackColor,
                                fontSize: 15,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w400),
                          )),
                      Obx(
                        () => Container(
                          height: 40,
                          margin: const EdgeInsetsDirectional.only(
                              end: 40, start: 40, bottom: 10, top: 5),
                          alignment: AlignmentDirectional.topStart,
                          child: RadioGroup<String>.builder(
                            direction: Axis.horizontal,
                            groupValue: walletController.mode.value,
                            horizontalAlignment: MainAxisAlignment.spaceAround,
                            activeColor: ConstColor.codeFieldTextColor,
                            fillColor: ConstColor.blackColor,
                            onChanged: (value) {
                              walletController.mode.value = value ?? '';
                            },
                            items: walletController.status,
                            textStyle: const TextStyle(
                              fontSize: 15,
                              color: ConstColor.blackColor,
                            ),
                            itemBuilder: (item) => RadioButtonBuilder(
                              item,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          var type = walletController.mode.value ==
                                  AppConstents().txtMpesa
                              ? "online"
                              : "cash";
                          log("send req ss $type");
                          String amtError = AppValidation().AmtValidate(
                              walletController.withdrawalAmount.value.text
                                  .trim()
                                  .toString());

                          if (walletController.withdrawalAmount.value.text
                              .trim()
                              .isEmpty) {
                            showFlutterToast(message: AppConstents().EnterAmt);
                          } else if (amtError.isNotEmpty) {
                            showFlutterToast(message: amtError);
                          } else {
                            walletController.sendRequest();
                          }
                        },
                        child: Container(
                          // height: 40,
                          alignment: AlignmentDirectional.center,
                          margin: const EdgeInsetsDirectional.only(
                              end: 10, top: 44, start: 10, bottom: 10),
                          padding: const EdgeInsetsDirectional.only(
                              start: 16, end: 16, top: 14, bottom: 14),
                          width: 160,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: AlignmentDirectional.topEnd,
                              end: AlignmentDirectional.bottomStart,
                              colors: [
                                ConstColor.codeTextButtonColor,
                                ConstColor.codeTextButtonColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            AppConstents().SendRequest,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: ConstColor.codeFieldTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )))));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/toast.dart';

import '../../../../utils/style.dart';
import '../../../../utils/time_rule.dart';
import '../../../../utils/user_session.dart';
import '../../controller/transection_histroy_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransectionHistroyScreen extends StatefulWidget {
  static String routeName = "TransectionHistroyScreen";

  const TransectionHistroyScreen({super.key});

  @override
  State<TransectionHistroyScreen> createState() =>
      _TransectionHistroyScreenState();
}

class _TransectionHistroyScreenState extends State<TransectionHistroyScreen> {
  int initSelectBotton = 0;

  //doMytripTransactionGetAllRequest

  var transactionHistoryControllerInstance =
      Get.put(TransactionHistoryController());

  @override
  void initState() {
    super.initState();
    UserSession.isCurrentLoading =
        transactionHistoryControllerInstance.isLoading;
    transactionHistoryControllerInstance.doMytripTransactionGetAllRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.accentColor,
      appBar: ReusableWidgets.getAppBar(
          AppLocalizations.of(Get.key.currentContext!)!.txt_transaction_upr),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Align(
            alignment: AlignmentDirectional.center,
            child: Obx(() {
              if (transactionHistoryControllerInstance.isLoading.value ==
                  true) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ConstColor.codeBackgroundColor,
                  ),
                );
              } else {
                return Text(
                  transactionHistoryControllerInstance
                                  .transactionHistoryResponseModel
                                  .value!
                                  .responseBody!
                                  .paymentInfo!
                                  .totalPrice !=
                              0 &&
                          transactionHistoryControllerInstance
                                  .transactionHistoryResponseModel
                                  .value!
                                  .responseBody!
                                  .paymentInfo!
                                  .totalPrice !=
                              null
                      ? UserSession.getStringFromSession(
                                  UserSession.currencyPosition) ==
                              "0"
                          ? "${UserSession.getStringFromSession(UserSession.currencySymbol)} ${double.parse(transactionHistoryControllerInstance.transactionHistoryResponseModel.value!.responseBody!.paymentInfo!.totalPrice.toString()).toStringAsFixed(2)}"
                          : "${double.parse(transactionHistoryControllerInstance.transactionHistoryResponseModel.value!.responseBody!.paymentInfo!.totalPrice.toString()).toStringAsFixed(2)} ${UserSession.getStringFromSession(UserSession.currencySymbol)}"
                      : "0",
                  style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                      color: ConstColor.blackColor),
                );
              }
            }),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              AppLocalizations.of(Get.key.currentContext!)!.txt_total_amt,
              style: black16Bold600,
            ),
          ),
          const SizedBox(height: 40),
          commonButtons(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              AppLocalizations.of(Get.key.currentContext!)!.txt_payment_history,
              style: black14Bold600,
            ),
          ),
          const SizedBox(height: 15),
          Obx(() {
            if (transactionHistoryControllerInstance.isLoading.value == true) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ConstColor.codeBackgroundColor,
                ),
              );
            } else {
              return Expanded(
                  child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                child: initSelectBotton == 0
                    ? transactionHistoryControllerInstance
                            .transactionHistoryResponseModel
                            .value!
                            .responseBody!
                            .paymentInfo!
                            .cash!
                            .isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.of(Get.key.currentContext!)!
                                  .txt_no_data_found,
                              style: black14Bold600,
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 22),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "#${transactionHistoryControllerInstance.transactionHistoryResponseModel.value!.responseBody!.paymentInfo!.cash![index].sId}",
                                          style: black14Normal500,
                                        ),
                                        Text(
                                            UserSession.getStringFromSession(
                                                        UserSession
                                                            .currencyPosition) ==
                                                    "0"
                                                ? "${UserSession.getStringFromSession(UserSession.currencySymbol)} ${double.parse(transactionHistoryControllerInstance.transactionHistoryResponseModel.value!.responseBody!.paymentInfo!.cash![index].totalPrice.toString()).toStringAsFixed(2)} "
                                                : "${double.parse(transactionHistoryControllerInstance.transactionHistoryResponseModel.value!.responseBody!.paymentInfo!.cash![index].totalPrice.toString()).toStringAsFixed(2)} ${UserSession.getStringFromSession(UserSession.currencySymbol)}",
                                            style: black14Bold600)
                                      ],
                                    ),
                                    Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(vertical: 6),
                                          child: Text(
                                            TimeRues().margedDateTime(
                                                transactionHistoryControllerInstance
                                                    .transactionHistoryResponseModel
                                                    .value!
                                                    .responseBody!
                                                    .paymentInfo!
                                                    .cash![index]
                                                    .createdAt
                                                    .toString()),
                                            style: black14Normal500,
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return commonDivider();
                            },
                            itemCount: transactionHistoryControllerInstance
                                .transactionHistoryResponseModel
                                .value!
                                .responseBody!
                                .paymentInfo!
                                .cash!
                                .length)
                    : transactionHistoryControllerInstance
                            .transactionHistoryResponseModel
                            .value!
                            .responseBody!
                            .paymentInfo!
                            .online!
                            .isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.of(Get.key.currentContext!)!
                                  .txt_no_data_found,
                              style: black14Bold600,
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index1) {
                              return Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 22),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "#${transactionHistoryControllerInstance.transactionHistoryResponseModel.value!.responseBody!.paymentInfo!.online![index1].transactionId}",
                                          style: black14Normal500,
                                        ),
                                        Text(
                                            UserSession.getStringFromSession(
                                                        UserSession
                                                            .currencyPosition) ==
                                                    "0"
                                                ? "${UserSession.getStringFromSession(UserSession.currencySymbol)} ${double.parse(transactionHistoryControllerInstance.transactionHistoryResponseModel.value!.responseBody!.paymentInfo!.online![index1].totalPrice.toString()).toStringAsFixed(2)} "
                                                : "${transactionHistoryControllerInstance.transactionHistoryResponseModel.value!.responseBody!.paymentInfo!.online![index1].totalPrice} ${UserSession.getStringFromSession(UserSession.currencySymbol)}",
                                            style: black14Bold600)
                                      ],
                                    ),
                                    Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(vertical: 6),
                                          child: Text(
                                            TimeRues().margedDateTime(
                                                transactionHistoryControllerInstance
                                                    .transactionHistoryResponseModel
                                                    .value!
                                                    .responseBody!
                                                    .paymentInfo!
                                                    .online![index1]
                                                    .createdAt
                                                    .toString()),
                                            style: black14Normal500,
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return commonDivider();
                            },
                            itemCount: transactionHistoryControllerInstance
                                .transactionHistoryResponseModel
                                .value!
                                .responseBody!
                                .paymentInfo!
                                .online!
                                .length),
              ));
            }
            //}
          })
        ],
      ),
    );
  }

  Widget commonButtons() {
    return Container(
      decoration: borderDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                initSelectBotton = 0;
              });
            },
            child: Container(
              alignment: AlignmentDirectional.center,
              height: 40,
              decoration: initSelectBotton == 0
                  ? linearColorDecoration
                  : withoutBorderDecoration,
              width: MediaQuery.of(context).size.width * 0.40,
              child: Text(
                AppLocalizations.of(Get.key.currentContext!)!.txt_cash,
                style: initSelectBotton == 0
                    ? quantityTextStyle
                    : quantityTextStyle1,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                initSelectBotton = 1;
              });
            },
            child: Container(
              alignment: AlignmentDirectional.center,
              height: 40,
              decoration: initSelectBotton == 1
                  ? linearColorDecoration
                  : withoutBorderDecoration,
              width: MediaQuery.of(context).size.width * 0.40,
              child: Text(
                AppLocalizations.of(Get.key.currentContext!)!.txt_online,
                style: initSelectBotton == 1
                    ? quantityTextStyle
                    : quantityTextStyle1,
              ),
            ),
          )
        ],
      ),
    );
  }
}

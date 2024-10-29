import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/design/settings/model/wallet_model.dart';
import 'package:madr_driver/utils/app_constents.dart';

import '../../../services/api_sevices.dart';
import '../../../utils/toast.dart';
import '../../../utils/user_session.dart';

class WalletController extends GetxController {
  var isLoading = true.obs;
  var isHistoryLoading = true.obs;
  NetworkServices networkServices = NetworkServices();
  Rx<TextEditingController> withdrawalAmount = TextEditingController().obs;
  Rx<TextEditingController> remarkText = TextEditingController().obs;
  RxInt page = 1.obs;
  RxInt record = 10.obs;
  RxList<Data> withdrawalList = <Data>[].obs;
  RxString mode = "".obs;
  RxList<String> status = [''].obs;
  RxString totalAmt = "".obs;

  Future<List<Data>> getList() async {
    if (page.value == 1) {
      isLoading.value = true;
    }

    var response = await networkServices.getWalletHistory(
        record.toString(),
        page.toString(),
        UserSession.getStringFromSession(UserSession.keyUserToken));

    log("reeepooo.. $record   $page    ");
    log("reeepooo.. $response");

    try {
      if (response.responseCode == 200) {
        totalAmt.value = response.responseBody!.totalPayment.toString();
        log("reeepooo..totalAmt    ${totalAmt.value}");
        var rest = json.encode(response.responseBody!.list);
        log("reeepooo.rest. rest  $rest");
        var restdecode = json.decode(rest);

        if (page.value == 1) {
          withdrawalList.clear();
          if (restdecode.length > 0) {
            log("reeepooo..rest $restdecode");

            withdrawalList.addAll(await restdecode
                .map<Data>((json) => Data.fromJson(json))
                .toList());

            isLoading.value = false;
          } else {
            log("reeepooo..rest $restdecode");
            isLoading.value = false;
            withdrawalList.value = [];
          }
        } else {
          if (restdecode.length > 0) {
            withdrawalList.addAll(await restdecode
                .map<Data>((json) => Data.fromJson(json))
                .toList());
            isLoading.value = false;
          } else {
            isLoading.value = false;
          }
        }
      } else {
        print('<<<<<<<<<<<<LotteryApp>>>>>>>>>$response');
        showFlutterToast(message: response.responseMessage.toString());
        isLoading.value = false;
        withdrawalList.value = [];
      }
    } catch (e) {
      print(e);
      isLoading.value = false;
      withdrawalList.value = [];
    }

    return withdrawalList;
  }

  Future<List<Data>> fecthTripList() async {
    return withdrawalList;
  }

  Future<List<Data>> getHistoryList() async {
    if (page.value == 1) {
      isHistoryLoading.value = true;
    }
    var response = await networkServices.getWalletHistory(
        record.toString(),
        page.toString(),
        UserSession.getStringFromSession(UserSession.keyUserToken));

    log("reeepooo.. $record   $page    ");
    log("reeepooo.. $response");

    try {
      if (response.responseCode == 200) {
        totalAmt.value = response.responseBody!.totalPayment.toString();
        log("reeepooo..totalAmt    ${totalAmt.value}");
        var rest = json.encode(response.responseBody!.list);
        log("reeepooo.rest. rest  $rest");
        var restdecode = json.decode(rest);

        if (page.value == 1) {
          withdrawalList.clear();
          if (restdecode.length > 0) {
            log("reeepooo..rest $restdecode");

            withdrawalList.addAll(await restdecode
                .map<Data>((json) => Data.fromJson(json))
                .toList());

            isHistoryLoading.value = false;
          } else {
            log("reeepooo..rest $restdecode");
            isHistoryLoading.value = false;
            withdrawalList.value = [];
          }
        } else {
          if (restdecode.length > 0) {
            withdrawalList.addAll(await restdecode
                .map<Data>((json) => Data.fromJson(json))
                .toList());
            isHistoryLoading.value = false;
          } else {
            isHistoryLoading.value = false;
          }
        }
      } else {
        print('<<<<<<<<<<<<LotteryApp>>>>>>>>>$response');
        showFlutterToast(message: response.responseMessage.toString());
        isHistoryLoading.value = false;
        withdrawalList.value = [];
      }
    } catch (e) {
      print(e);
      isHistoryLoading.value = false;
      withdrawalList.value = [];
    }

    return withdrawalList;
  }

  sendRequest() async {
    isLoading.value = true;
    var response = await networkServices.sendAmtRequest({
      "amount": withdrawalAmount.value.text,
      "request_type": mode.value == AppConstents().txtMpesa ? "online" : "cash",
      "remark": remarkText.value.text
    });
    log("reeepooo.. sendRequest   $response");

    try {
      if (response['ResponseCode'] == 200) {
        log("reeepooo..rest sendRequest $response");
        showFlutterToast(message: response['ResponseMessage'].toString());
        withdrawalAmount.value.text = "";
        remarkText.value.text = "";

        isLoading.value = false;
      } else {
        print('<<<<<<<<<<<<sendRequest>>>>>>>>>$response');
        showFlutterToast(message: response['ResponseMessage'].toString());
        isLoading.value = false;
      }
    } catch (e) {
      print(" ... sendRequest ..... $e");
      isLoading.value = false;
    }
  }
}

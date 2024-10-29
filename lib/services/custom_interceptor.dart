import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/constents/socketConnectionDialog.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:madr_driver/utils/user_session.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../socket_connection/socket_connection.dart';

class CustomInterceptor extends InterceptorsWrapper {
  @override
  DioException onError(DioException err, ErrorInterceptorHandler handler) {
    print(" custom interceptor..  ${err.type}   handler..  $handler");
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        if (UserSession.isCurrentLoading.value == true) {
          UserSession.isCurrentLoading.value = false;
        }
        showFlutterToast(
          message: AppConstents().txtCheckConnectionTimeout,
        );
        break;
      case DioExceptionType.sendTimeout:
        showFlutterToast(message: AppConstents().txtTimeoutExcep);
        break;
      case DioExceptionType.receiveTimeout:
        showFlutterToast(message: AppConstents().txtTimeoutExcep);
        break;
      case DioExceptionType.cancel:
        showFlutterToast(message: AppConstents().txtRequestCancel);
        break;
      case DioExceptionType.badCertificate:
        break;
      case DioExceptionType.badResponse:
        showFlutterToast(message: AppConstents().txtWrongResponse);
        break;
      case DioExceptionType.connectionError:
        showFlutterToast(message: AppConstents().txtConnectionError);
        break;
      case DioExceptionType.unknown:
        print("unkonwm");
        Helper.verifyInternet().then((intenet) async {
          // ignore: unnecessary_null_comparison
          if (intenet != null && intenet) {
            print("  Get.isDialogOpen .. ${Get.isDialogOpen}");
            if (Get.isDialogOpen == true) {
              showFlutterToast(message: AppConstents().txtContactAdmin);
            } else {
              print("custom interceptor socket connection dialog...  ");
              Get.dialog(WillPopScope(
                  onWillPop: () async => false,
                  child: SocketConnectionDialog()));
              // },
              //);
            }
          } else {
            FBroadcast.instance().broadcast("network", value: false);
          }
        });

        break;
    }
    return err;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    print("onRequest..   " + options.uri.toString());
    print("onRequest..   " + options.path.toString());
    print("onRequest..   " + options.uri.toString());
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse

    print("response.. interceptor " + response.toString());
    print("json.decode(response.toString())['ResponseCode']...    " +
        json.decode(response.toString())['ResponseCode'].toString());
    if (json.decode(response.toString())['ResponseCode'].toString() == "401") {
      print("show dialog..  111");
      showUnauthorizedDialog();
    } else if (json.decode(response.toString())['ResponseCode'].toString() ==
        "402") {
      print("show dialog.. 222 ");
      showAdminDeleteDialog();
    } else {
      print("show dialog.. 222 ");
      super.onResponse(response, handler);
    }
  }

  showUnauthorizedDialog() {
    print("show dialog..  ");
    return Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text(AppConstents().txtUnauthorizeLogin),
        content: Text(AppConstents().txtReLogin),
        actions: [
          TextButton(
            onPressed: () async {
              await UserSession.clearSession();
              SocketConnection.socket?.disconnect();
              SocketConnection.socket?.dispose();
              Get.offNamedUntil("LoginScreen", (route) => false);
            },
            child: Text(AppLocalizations.of(Get.key.currentContext!)!.txt_ok),
          ),
        ],
      ),
    );
  }

  showAdminDeleteDialog() {
    print("show dialog..  ");
    return Get.dialog(
      barrierDismissible: false,
      WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(AppConstents().txtUnauthorizeLogin),
            content: Text(AppConstents().txtAdminDelete),
            actions: [
              TextButton(
                onPressed: () async {
                  await UserSession.clearSession();
                  SocketConnection.socket?.disconnect();
                  SocketConnection.socket?.dispose();
                  Get.offNamedUntil("LoginScreen", (route) => false);
                },
                child:
                    Text(AppLocalizations.of(Get.key.currentContext!)!.txt_ok),
              ),
            ],
          )),
    );
  }
}

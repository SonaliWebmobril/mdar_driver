import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'internetConnectionDialog.dart';

class BroadcastData {
  data(value) {
    if (value == true) {
    } else {
      if (Get.isDialogOpen == false) {
        Get.dialog(WillPopScope(
            onWillPop: () async => false, child: InternetConnectionDialog()));
      }
    }
  }
}

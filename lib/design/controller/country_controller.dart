import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/services/api_sevices.dart';
import 'package:madr_driver/utils/toast.dart';

import '../auth_design/auth_model/country_model.dart';

class CountryController extends GetxController {
  NetworkServices networkServices = NetworkServices();
  RxList<ListData> countryList = <ListData>[].obs;
  RxList<ListData> tempCountryList = <ListData>[].obs;
  final ScrollController scrollController = ScrollController();
  var isLoading = false.obs;

  Rx<TextEditingController> etCountrySearch = TextEditingController().obs;

  onSearchTextChanged(String text) async {
    countryList.value = [];
    print("userdata..  ${tempCountryList.length}");
    print("userdata..  ${tempCountryList[0].name!}");
    if (tempCountryList.isNotEmpty) {
      for (var userDetail in tempCountryList) {
        print("userdata..  ${userDetail.name!}");
        print("userdata..text  $text");
        var name = userDetail.name!.toLowerCase().trim();
        var code = userDetail.currencyCode!.toLowerCase().trim();
        var searchVal = text.toLowerCase().trim();
        print(
            "userdata.. contains ${(name.contains(searchVal) || code.contains(searchVal))}");
        if (name.contains(searchVal) || code.contains(searchVal)) {
          countryList.add(userDetail);
        }
      }
    }
  }

  Future<void> currentList() async {
    try {
      countryList.clear();
      tempCountryList.clear();
      var response = await networkServices.countryListMethod();

      if (response.responseCode == 200) {
        if (response.responseBody!.list!.isNotEmpty) {
          countryList.addAll(response.responseBody!.list!.toList());
          tempCountryList.addAll(response.responseBody!.list!.toList());
          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
        showFlutterToast(message: response.responseMessage.toString());
      }
    } catch (e) {
      // showFlutterToast(message: e.toString());
      print("currentList..   $e");
    }
  }
}

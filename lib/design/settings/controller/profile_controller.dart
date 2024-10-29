import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/design/dashboard/controller/home_controller.dart';
import 'package:madr_driver/utils/StringExtension.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/email_rule.dart';
import 'package:madr_driver/utils/toast.dart';

import '../../../services/api_sevices.dart';
import '../../../utils/user_session.dart';
import '../model/get_profile.dart';
import '../model/update_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileController extends GetxController {
  String driverImageUpload = "driver/update_profile_pic";
  var isLoading = false.obs;
  RxBool isLoadingStatus = false.obs;
  var isUploadingImg = false.obs;
  RxString rideTypeTxt = AppConstents().txtDailyRide.obs;
  RxString profilePic = "".obs;
  RxString criminalRecord = "".obs;
  RxString driverAvgRating = "".obs;
  RxString driverStatus = "".obs;
  GetProfileResponseModel? getProfileResponseModel;
  RxList<String> driverTypeList = [AppConstents().txtDailyRide].obs;
  // [AppConstents().txtDailyRide, AppConstents().txtRentalRide].obs;

  NetworkServices networkServices = NetworkServices();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  RxList<String> genderlist = [
    AppConstents().txtMale,
    AppConstents().txtFemale,
    // AppConstents().txtOther
  ].obs;
  RxString genderTxt = AppConstents().txtMale.obs;

  Future<void> getProfileRequest() async {
    print("GetProfileDrivergetProfileRequest");
    isLoading.value = true;
    // update();
    try {
      var response = await networkServices.getProfileCall();
      log("response ${response.toString()}");
      if (response.responseCode == 200) {
        log("response ${response.toString()}");
        log('response name..  ' + response.responseBody!.name.toString());
        print('response name..  ' + response.responseBody!.mobile.toString());
        nameController.text = response.responseBody!.name.toString();
        emailController.text = response.responseBody!.email.toString();
        phoneController.text = response.responseBody!.mobile.toString();
        mobileController.text = response.responseBody!.mobile.toString();
        genderTxt.value = genderValue(response.responseBody!.gender.toString());
        print("  genderTxt  .. " + genderTxt.value.toString());
        criminalRecord.value = response.responseBody!.criminalRecord.toString();
        driverAvgRating.value = response.responseBody!.avgRating.toString();
        driverStatus.value = response.responseBody!.status.toString();
        print('response driverStatus record../   ' + driverStatus.value);
        print('response name..  ' + mobileController.text.toString());
        countryCodeController.text =
            response.responseBody!.countryCode.toString();
        Get.log(
            "response -==->>>check profilepic ${ProfileController().profilePic}");

        profilePic.value =
            (response.responseBody!.profilePic.toString() == "0" ||
                    response.responseBody!.profilePic.toString() == "")
                ? "0"
                : AppConstents.baseUrl +
                    response.responseBody!.profilePic.toString();

        UserSession.setStringInSession(
            UserSession.keyUserRating, driverAvgRating.value);
        UserSession.setStringInSession(
            UserSession.keyUserStatus, driverStatus.value);
        UserSession.setStringInSession(
            UserSession.keyUserGender, genderTxt.value);
        UserSession.setStringInSession(
            UserSession.keyUserName, nameController.text.capitalizedString());
        UserSession.setStringInSession(
            UserSession.keyUserEmail, emailController.text);
        UserSession.setStringInSession(
            UserSession.keyUserCriminalRecord, criminalRecord.value);
        UserSession.setStringInSession(
            UserSession.keyUserProfile, profilePic.value);
        UserSession.setStringInSession(
            UserSession.keyUserCountryCode, countryCodeController.text);
        UserSession.setStringInSession(
            UserSession.keyUserMobile, mobileController.text);
        UserSession.setStringInSession(
            UserSession.keyRideType, response.responseBody!.rideType ?? "0");
        UserSession.setStringInSession(UserSession.currencyCode,
            response.responseBody!.currencyCode.toString());
        UserSession.setStringInSession(UserSession.currencyPosition,
            response.responseBody!.currencyPosition.toString());
        UserSession.setStringInSession(UserSession.currencySymbol,
            response.responseBody!.currencySymbol.toString());
        UserSession.setStringInSession(
            UserSession.tax, response.responseBody!.tax.toString());
        UserSession.setStringInSession(UserSession.nightTimeStart,
            response.responseBody!.NightTimeStart.toString());
        UserSession.setStringInSession(UserSession.nightTimeEnd,
            response.responseBody!.NightTineEnd.toString());

        isLoading.value = false;
        log("GetProfileDriver ${profilePic.value}");

        update();
      } else {
        isLoading.value = false;
      }
    } on Exception {
      isLoading.value = false;
      log("#######################");
    } catch (e) {
      isLoading.value = false;
      log("#######################" + e.toString());
    }
  }

  driverType() {
    String type = rideTypeTxt.value;
    if (type == AppConstents().txtDailyRide) {
      return "0";
    } else if (type == AppConstents().txtRentalRide) {
      return "1";
    } else {
      return "0";
    }
  }

  genderValue(String gender) {
    print("gender...  " + gender.toString());
    if (gender == "0" || int.parse(gender.toString()) == 0) {
      return AppConstents().txtMale;
    } else if (gender == "1" || int.parse(gender.toString()) == 1) {
      return AppConstents().txtFemale;
    } else if (gender == "2" || int.parse(gender.toString()) == 2) {
      return AppConstents().txtOther;
    } else {
      return "";
    }
  }

  Future<void> updateUserProfileImgReq(file, fileName) async {
    isUploadingImg(true);
    update();

    try {
      final response = await updateProfilePic(file, fileName);
      print("profile update ..   " +
          response.profileUpdate!.profilePic.toString());
      if (response.responseCode == 200) {
        showFlutterToast(message: response.responseMessage.toString());
        isUploadingImg(false);
        print("updateUserProfileImgReq ");

        profilePic.value = AppConstents.baseUrl +
            response.profileUpdate!.profilePic.toString();
        UserSession.setStringInSession(
            UserSession.keyUserProfile, profilePic.value);

        update();
        log("update");
      } else {
        isUploadingImg(true);
        update();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<UpdateProfileResponseModel> updateProfilePic(file, fileName) async {
    var headers = <String, String>{};
    headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConstents.baseUrl + driverImageUpload));
    request.files.add(await http.MultipartFile.fromPath('image', file));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var responseData = await response.stream.bytesToString();
    final responseJson = jsonDecode(responseData);
    print("profile upda..  " + responseJson.toString());
    return UpdateProfileResponseModel.fromJson(responseJson);
  }

  Future<String> validationProfile() async {
    String nameErrorText = AppValidation()
        .fullNameValidator(nameController.text.trim().toString());
    String emailErrorText =
        AppValidation().emailValidator(emailController.text.trim().toString());
    if (nameErrorText.toString().isNotEmpty) {
      return nameErrorText;
    } else if (emailController.text.isNotEmpty) {
      if (emailErrorText.toString().isNotEmpty) {
        return emailErrorText;
      }
    }

    return "";
  }

  genderType() {
    print("gender,...  " + genderTxt.value);
    if (genderTxt.value == AppConstents().txtMale) {
      return "0";
    } else if (genderTxt.value == AppConstents().txtFemale) {
      return "1";
    } else if (genderTxt.value == AppConstents().txtOther) {
      return "2";
    }
  }

  Future<void> updateProfileRequest() async {
    isLoading(true);
    update();
    try {
      var response = await networkServices.updateProfileCall(
          UpdateProfileRequestModel(
              name: nameController.text.toString().capitalizedString(),
              email: emailController.text.toString(),
              gender: genderType(),
              rideType: driverType()));

      if (response.responseCode == 200) {
        isLoading(false);
        UserSession.setStringInSession(
            UserSession.keyUserGender, genderTxt.value);
        UserSession.setStringInSession(UserSession.keyUserName,
            nameController.text.capitalizedString().toString());
        UserSession.setStringInSession(
            UserSession.keyUserEmail, emailController.text);
        UserSession.setStringInSession(UserSession.keyRideType, driverType());
        var homeController = Get.put(HomeController());
        homeController.currentBookingList();
        Get.defaultDialog(
            radius: 10.0,
            backgroundColor: ConstColor.accentColor,
            confirmTextColor: ConstColor.blackColor,
            middleTextStyle:
                TextStyle(color: ConstColor.blackcodeTextButtonColor),
            titleStyle: TextStyle(color: ConstColor.blackcodeTextButtonColor),
            buttonColor: ConstColor.codeLogoYellow,
            titlePadding: EdgeInsetsDirectional.only(top: 15, bottom: 15),
            contentPadding: EdgeInsetsDirectional.only(bottom: 15),
            barrierDismissible: false,
            title: AppConstents().success_txt,
            content: Text(response.responseMessage.toString()),
            textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
            onConfirm: () {
              Get.back();
              Get.back();
            });
      } else {
        isLoading(false);
        update();
        Get.defaultDialog(
            radius: 10.0,
            backgroundColor: ConstColor.accentColor,
            confirmTextColor: ConstColor.blackColor,
            middleTextStyle:
                TextStyle(color: ConstColor.blackcodeTextButtonColor),
            titleStyle: TextStyle(color: ConstColor.blackcodeTextButtonColor),
            buttonColor: ConstColor.codeLogoYellow,
            titlePadding: EdgeInsetsDirectional.only(top: 15, bottom: 15),
            contentPadding: EdgeInsetsDirectional.only(bottom: 15),
            barrierDismissible: false,
            title: AppLocalizations.of(Get.key.currentContext!)!.txt_error,
            content: Text(response.responseMessage.toString()),
            textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
            onConfirm: () {
              Get.back();
            });
      }
    } on Exception {
      isLoading(false);
    } catch (e) {
      log("#######################" + e.toString());

      isLoading(false);
      ScaffoldMessenger.of(Get.key.currentContext!).showSnackBar(SnackBar(
        backgroundColor: ConstColor.blackColor,
        content: Row(
          children: [
            const Icon(
              Icons.error,
              color: ConstColor.codeFieldColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(e.toString(),
                //AppLocalizations.of(Get.key.currentContext!)!.txt_server_error,
                style: const TextStyle(
                    color: ConstColor.accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        duration: const Duration(days: 1),
      ));
    }
  }
}

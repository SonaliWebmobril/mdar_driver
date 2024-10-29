import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/utils/style.dart';
import 'package:madr_driver/utils/toast.dart';
import '../../utils/const_color.dart';
import '../../utils/app_constents.dart';
import '../../services/api_sevices.dart';
import '../../utils/email_rule.dart';
import '../../utils/user_session.dart';
import '../auth_design/auth_model/login_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../dashboard/controller/home_controller.dart';
import '../settings/controller/profile_controller.dart';

class AuthController extends GetxController {
  var selectedLanguage = "Select language";
  RxString selectedCountryCode = "SA".obs;
  var selectedCountryName = "Saudi Arabia";
  RxString selectedCountryFlag =
      "${AppConstents.baseUrl}Uploads/flags/sa.png".obs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  TextEditingController phoneController = TextEditingController();
  TextEditingController phoneCodeController = TextEditingController();
  // TextEditingController languageIdcontroller = TextEditingController();
  TextEditingController socialPhoneController = TextEditingController();

  TextEditingController otpConttroller = TextEditingController();
  var isLoading = false.obs;
  NetworkServices networkServices = NetworkServices();
  HomeController homeController = HomeController();
  ProfileController profileController = ProfileController();

  RxString socialId = "".obs;
  RxString socialType = "".obs;
  RxString socialName = "".obs;
  RxString socialEmail = "".obs;
  RxString socialMobile = "".obs;
  RxString socialToken = "".obs;

  @override
  void onInit() {
    getDeviceToken();
    phoneCodeController.text = "+966";
    super.onInit();
  }

  var deviceToken = "";

  getDeviceToken() {
    _firebaseMessaging.getToken().then((token) {
      deviceToken = token.toString();
      update();
      print("device token..   $deviceToken");
    });
  }

  socialMobileUpdate() async {
    try {
      isLoading(true);

      Map map = {"mobile": socialPhoneController.text, "user_type": "driver"};

      print("map... social login $map");

      final response = await networkServices.socialMobileUpdateService(
          map, socialToken.value);

      isLoading(false);
      if (response.succeeded == true) {
        isLoading(false);
        update();

        if (response.responseCode == 200) {
          log("-==-token ${response.sendOtp!.token.toString()}");
          // Get.toNamed("VerficationScreen", arguments: {
          //   "tempToken": response.sendOtp!.token.toString(),
          //   "mobile": phoneController.text.toString(),
          //   'isFromSignUp': true,
          // });
          Get.defaultDialog(
            radius: 10.0,
            backgroundColor: ConstColor.accentColor,
            titleStyle: white18Bold500,
            middleTextStyle: white16Normal400,
            confirmTextColor: ConstColor.blackColor,
            buttonColor: ConstColor.codeBackgroundColor,
            // backgroundColor: ConstColor.accentColor,
            // confirmTextColor: ConstColor.accentColor,
            // middleTextStyle:
            //     const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // titleStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // buttonColor: ConstColor.bluecodeTextButtonColor,
            titlePadding: const EdgeInsetsDirectional.only(top: 15, bottom: 15),
            contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
            title: AppConstents().success_txt,
            middleText:
                "${AppLocalizations.of(Get.key.currentContext!)!.txt_your_otp} ${response.sendOtp!.otp.toString()} \n${response.responseMessage}",
            textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
            barrierDismissible: false,
            onConfirm: () {
              Get.back();
              Get.toNamed("VerficationScreen", arguments: {
                "tempToken": response.sendOtp!.token.toString(),
                "mobile": phoneController.text.toString(),
                'isFromSignUp': true,
              });
            },
          );
        } else if (response.responseCode == 400) {
          isLoading(false);
          update();
          Get.defaultDialog(
            radius: 10.0,
            backgroundColor: ConstColor.codeBackgroundColor,
            titleStyle: white18Bold500,
            middleTextStyle: white16Normal400,
            confirmTextColor: ConstColor.codeBackgroundColor,
            buttonColor: ConstColor.codeTextButtonColor,
            // backgroundColor: ConstColor.accentColor,
            // confirmTextColor: ConstColor.accentColor,
            // middleTextStyle:
            //     const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // titleStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // buttonColor: ConstColor.bluecodeTextButtonColor,
            titlePadding: const EdgeInsetsDirectional.only(top: 15, bottom: 15),
            contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
            title: AppLocalizations.of(Get.key.currentContext!)!.txt_error,
            barrierDismissible: false,
            middleText: response.responseMessage.toString(),
            textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
            onConfirm: () {
              Get.back();
            },
          );
        } else if (response.responseCode == 500) {
          isLoading(false);
          update();
          Get.defaultDialog(
            radius: 10.0,
            backgroundColor: ConstColor.codeBackgroundColor,
            titleStyle: white18Bold500,
            middleTextStyle: white16Normal400,
            confirmTextColor: ConstColor.codeBackgroundColor,
            buttonColor: ConstColor.codeTextButtonColor,
            // backgroundColor: ConstColor.accentColor,
            // confirmTextColor: ConstColor.accentColor,
            // middleTextStyle:
            //     const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // titleStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // buttonColor: ConstColor.bluecodeTextButtonColor,
            titlePadding: const EdgeInsetsDirectional.only(top: 15, bottom: 15),
            contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
            title: AppLocalizations.of(Get.key.currentContext!)!.txt_error,
            barrierDismissible: false,
            middleText: "${response.responseMessage}",
            textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
            onConfirm: () {
              Get.back();
            },
          );
        }
      } else {
        showFlutterToast(message: response.responseMessage.toString());
      }
    } catch (e) {
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

  socialLogin() async {
    phoneController.clear();
    try {
      isLoading(true);

      Map map = {
        "name": socialName.value,
        "email": socialEmail.value,
        "mobile": socialMobile.value,
        "login_type": socialType.value,
        "social_id": socialId.value,
        "country_code": phoneCodeController.text.toString(),
        "country": selectedCountryCode.toString(),
        "user_type": "driver",
        "language_id": UserSession.getLng(UserSession.keyLocalLng),
        "latitude": UserSession.getDoubleInSession(UserSession.keyCurrentLat),
        "longitude": UserSession.getDoubleInSession(UserSession.keyCurrentLng),
        "device_token": deviceToken.toString()
      };

      print("map... $map");

      final response = await networkServices.socialLoginSevices(map);

      if (response.succeeded == true) {
        if (response.responseCode == 200) {
          if (response.varifyOtp!.isVerify == 0) {
            isLoading.value = false;
            socialToken.value = response.varifyOtp!.loginToken.toString();
            Get.toNamed("SocialLoginScreen");
          } else {
            phoneController.clear();

            print(
                "response.varifyOtp!.documentStatus..   ${response.varifyOtp!.documentStatus}");

            if (response.varifyOtp!.documentStatus == 0) {
              //Get.toNamed("DocmentUploadScreen");
              Get.log("=--=-selectedCountryCode $selectedCountryCode");
              // Get.log("=--=-languageIdcontroller ${languageIdcontroller.text}");
              update();

              UserSession.setStringInSession(UserSession.keyUserToken,
                  response.varifyOtp!.loginToken.toString());
              UserSession.setStringInSession(
                  UserSession.keyUserId, response.varifyOtp!.id.toString());
              UserSession.setStringInSession(UserSession.keyUserMobile,
                  response.varifyOtp!.mobile.toString());
              UserSession.setStringInSession(UserSession.keyUserCountryCode,
                  phoneCodeController.text.toString());
              UserSession.setStringInSession(UserSession.keySecurityAmt,
                  response.varifyOtp!.SecurityDeposit.toString());
              UserSession.setBoolInSession(UserSession.keyIsLoggedIn, false);

              isLoading.value = false;
              Get.offNamedUntil(
                  'DocmentUploadScreen', ModalRoute.withName('LoginScreen'));
            } else {
              isLoading.value = false;
              Get.defaultDialog(
                radius: 10.0,
                backgroundColor: ConstColor.codeBackgroundColor,
                titleStyle: white18Bold500,
                middleTextStyle: white16Normal400,
                confirmTextColor: ConstColor.codeBackgroundColor,
                buttonColor: ConstColor.codeTextButtonColor,
                // backgroundColor: ConstColor.accentColor,
                // confirmTextColor: ConstColor.accentColor,
                // middleTextStyle:
                //     const TextStyle(color: ConstColor.blackcodeTextButtonColor),
                // titleStyle:
                //     const TextStyle(color: ConstColor.blackcodeTextButtonColor),
                // buttonColor: ConstColor.bluecodeTextButtonColor,
                titlePadding:
                    const EdgeInsetsDirectional.only(top: 15, bottom: 15),
                contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
                title: AppConstents().success_txt,
                barrierDismissible: false,
                middleText: "${response.responseMessage}",
                textConfirm:
                    AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
                onConfirm: () async {
                  Get.back();

                  Get.log("=--=-selectedCountryCode $selectedCountryCode");
                  // Get.log("=--=-languageIdcontroller ${languageIdcontroller.text}");
                  update();
                  // var body = <String, String>{};
                  // body['authtoken'] = response.varifyOtp!.loginToken.toString();
                  // // body['username'] = response.varifyOtp.userDetails.;
                  // body['language_id'] = currentLocal.toString();
                  // body['country_code'] = selectedCountryCode.toString();
                  // body['userid'] = response.varifyOtp!.id.toString();
                  // body['status'] = response.varifyOtp!.status.toString();
                  // body['mobile'] = response.varifyOtp!.mobile.toString();
                  // body['securityDeposit'] =
                  //     response.varifyOtp!.SecurityDeposit.toString();
                  // userToken = response.varifyOtp!.loginToken.toString();
                  // userId = response.varifyOtp!.id.toString();
                  // userStatus = response.varifyOtp!.status.toString();
                  // securityDepositAmt =
                  //     response.varifyOtp!.SecurityDeposit.toString();
                  // mobile = response.varifyOtp!.mobile.toString();
                  // log("user token..  " + userToken.toString());

                  // saveUserData(jsonEncode(body));
                  // saveVerifiedData(
                  //     response.varifyOtp!.documentStatus.toString());
                  // //  locationPermission();

                  UserSession.setStringInSession(UserSession.keyUserToken,
                      response.varifyOtp!.loginToken.toString());
                  UserSession.setStringInSession(
                      UserSession.keyUserId, response.varifyOtp!.id.toString());
                  UserSession.setStringInSession(UserSession.keyUserMobile,
                      response.varifyOtp!.mobile.toString());
                  UserSession.setStringInSession(UserSession.keyUserCountryCode,
                      phoneCodeController.text.toString());
                  UserSession.setStringInSession(UserSession.keySecurityAmt,
                      response.varifyOtp!.SecurityDeposit.toString());
                  UserSession.setBoolInSession(UserSession.keyIsLoggedIn, true);

                  // userToken = response.varifyOtp!.loginToken.toString();
                  // userId = response.varifyOtp!.id.toString();
                  // userMobile = response.varifyOtp!.mobile.toString();
                  // securityAmt = response.varifyOtp!.SecurityDeposit.toString();
                  // isUserLoggedin = true;

                  //SocketConnection.connectToServer();
                  //  await Location.locationPermission();
                  // await profileController.getProfileRequest();
                  // await controller.onRejectLead();
                  await homeController.BookingStatusThroughFirebase(
                      isLoading.value);
                  //Get.offAndToNamed("HomeScreen");

                  //  Get.offAndToNamed("DocmentUploadScreen");
                  // locationPermission();
                  // Get.offAndToNamed("HomeScreen");
                },
              );
            }
          }
        } else {
          isLoading.value = false;
          Get.defaultDialog(
            radius: 10.0,
            backgroundColor: ConstColor.codeBackgroundColor,
            titleStyle: white18Bold500,
            middleTextStyle: white16Normal400,
            confirmTextColor: ConstColor.codeBackgroundColor,
            buttonColor: ConstColor.codeTextButtonColor,
            // backgroundColor: ConstColor.accentColor,
            // confirmTextColor: ConstColor.accentColor,
            // middleTextStyle:
            //     const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // titleStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // buttonColor: ConstColor.bluecodeTextButtonColor,
            titlePadding: const EdgeInsetsDirectional.only(top: 15, bottom: 15),
            contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
            title: AppLocalizations.of(Get.key.currentContext!)!.txt_error,
            middleText: response.responseMessage.toString(),
            textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
            barrierDismissible: false,
            onConfirm: () {
              Get.back();
            },
          );
        }
      } else {
        isLoading.value = false;
        showFlutterToast(message: response.responseMessage.toString());
      }
    } catch (e) {
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

extension ValidationAuthLoagin on AuthController {
  Future<String> loginValidation() async {
    String phoneError =
        AppValidation().phoneValidator(phoneController.text.toString());
    if (phoneError.toString().isNotEmpty) {
      return phoneError;
    }
    return "";
  }

  Future<String> socialLoginValidation() async {
    String phoneError =
        AppValidation().phoneValidator(socialPhoneController.text.toString());
    if (phoneError.toString().isNotEmpty) {
      return phoneError;
    }
    return "";
  }

  Future<void> loginResuestApi() async {
    try {
      Get.log("phoneCodeController.text=-= ${phoneCodeController.text}");
      // Get.log("languageIdcontroller.text=-= ${languageIdcontroller.text}");
      isLoading(true);
      update();
      final response = await networkServices.loginSevices(LoginRequestModel(
        mobile: phoneController.text.toString(),
        countryCode: phoneCodeController.text,
        userType: "driver",
        country: selectedCountryCode.toString(),
        languageId: UserSession.getLng(UserSession.keyLocalLng),
        latitude: UserSession.getDoubleInSession(UserSession.keyCurrentLat),
        longitude: UserSession.getDoubleInSession(UserSession.keyCurrentLng),
        deviceToken: deviceToken.toString(),
      ));
      print("login register..   " + response.toString());

      if (response.succeeded == true) {
        isLoading(false);
        update();

        if (response.responseCode == 200) {
          log("-==-token ${response.sendOtp!.token.toString()}");
          // Get.toNamed("VerficationScreen", arguments: {
          //   "tempToken": response.sendOtp!.token.toString(),
          //   "mobile": phoneController.text.toString(),
          //   'isFromSignUp': true,
          // });
          Get.defaultDialog(
            radius: 10.0,
            backgroundColor: ConstColor.accentColor,
            titleStyle: white18Bold500,
            middleTextStyle: white16Normal400,
            confirmTextColor: ConstColor.blackColor,
            buttonColor: ConstColor.codeBackgroundColor,
            // backgroundColor: ConstColor.accentColor,
            // confirmTextColor: ConstColor.accentColor,
            // middleTextStyle:
            //     const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // titleStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // buttonColor: ConstColor.bluecodeTextButtonColor,
            titlePadding: const EdgeInsetsDirectional.only(top: 15, bottom: 15),
            contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
            title: AppConstents().success_txt,
            middleText:
                "${AppLocalizations.of(Get.key.currentContext!)!.txt_your_otp} ${response.sendOtp!.otp.toString()} \n${response.responseMessage}",
            textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
            barrierDismissible: false,
            onConfirm: () {
              Get.back();
              Get.toNamed("VerficationScreen", arguments: {
                "tempToken": response.sendOtp!.token.toString(),
                "mobile": phoneController.text.toString(),
                'isFromSignUp': true,
              });
            },
          );
        }
      } else if (response.responseCode == 400) {
        isLoading(false);
        update();

        Get.defaultDialog(
          radius: 10.0,
          backgroundColor: ConstColor.accentColor,
          titleStyle: white18Bold500,
          middleTextStyle: white16Normal400,
          confirmTextColor: ConstColor.blackColor,
          buttonColor: ConstColor.codeTextButtonColor,
          // backgroundColor: ConstColor.accentColor,
          // confirmTextColor: ConstColor.accentColor,
          // middleTextStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
          // titleStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
          // buttonColor: ConstColor.bluecodeTextButtonColor,
          titlePadding: const EdgeInsetsDirectional.only(top: 15, bottom: 15),
          contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
          title: AppLocalizations.of(Get.key.currentContext!)!.txt_error,
          barrierDismissible: false,
          middleText: response.responseMessage.toString(),
          textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
          onConfirm: () {
            Get.back();
          },
        );
      } else if (response.responseCode == 500) {
        isLoading(false);
        update();
        Get.defaultDialog(
          radius: 10.0,
          backgroundColor: ConstColor.accentColor,
          titleStyle: white18Bold500,
          middleTextStyle: white16Normal400,
          confirmTextColor: ConstColor.blackColor,
          buttonColor: ConstColor.codeTextButtonColor,
          // backgroundColor: ConstColor.accentColor,
          // confirmTextColor: ConstColor.accentColor,
          // middleTextStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
          // titleStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
          // buttonColor: ConstColor.bluecodeTextButtonColor,
          titlePadding: const EdgeInsetsDirectional.only(top: 15, bottom: 15),
          contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
          title: AppLocalizations.of(Get.key.currentContext!)!.txt_error,
          barrierDismissible: false,
          middleText: "${response.responseMessage}",
          textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
          onConfirm: () {
            Get.back();
          },
        );
      }
    } catch (e) {
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

extension OtpValidation on AuthController {
  Future<String> otpValidationError() async {
    String otpError =
        AppValidation().otpCodeValidator(otpConttroller.text.toString());
    if (otpError.toString().isNotEmpty) {
      return otpError;
    }
    return "";
  }
}

extension VerifyOpt on AuthController {
  Future<void> verifyOtpRequestApi() async {
    try {
      isLoading(true);
      update();
      log(phoneController.text.toString());
      log(otpConttroller.text.toString());

      final response = await networkServices.verifyOtp({
        "otp": otpConttroller.text.toString(),
        "country": selectedCountryCode.toString()
      });
      print(" verifiy  response.succeeded ${response.toJson()}");
      if (response.succeeded == true) {
        phoneController.clear();
        // phoneCodeController.clear();
        // languageIdcontroller.clear();
        // otpConttroller.clear();
        if (response.varifyOtp!.documentStatus == 0) {
          // Get.offAndToNamed("DocmentUploadScreen");
          Get.log("=--=-selectedCountryCode $selectedCountryCode");
          // Get.log("=--=-languageIdcontroller ${languageIdcontroller.text}");
          update();

          UserSession.setStringInSession(UserSession.keyUserToken,
              response.varifyOtp!.loginToken.toString());
          UserSession.setStringInSession(
              UserSession.keyUserId, response.varifyOtp!.id.toString());
          UserSession.setStringInSession(
              UserSession.keyUserMobile, response.varifyOtp!.mobile.toString());
          UserSession.setStringInSession(UserSession.keyUserCountryCode,
              phoneCodeController.text.toString());
          UserSession.setStringInSession(UserSession.keySecurityAmt,
              response.varifyOtp!.SecurityDeposit.toString());
          UserSession.setBoolInSession(UserSession.keyIsLoggedIn, false);
          UserSession.setStringInSession(UserSession.currencyCode,
              response.varifyOtp!.currencyCode.toString());
          UserSession.setStringInSession(UserSession.currencyPosition,
              response.varifyOtp!.currencyPosition.toString());
          UserSession.setStringInSession(UserSession.currencySymbol,
              response.varifyOtp!.currencySymbol.toString());
          UserSession.setStringInSession(
              UserSession.tax, response.varifyOtp!.tax.toString());
          UserSession.setStringInSession(UserSession.nightTimeStart,
              response.varifyOtp!.NightTimeStart.toString());
          UserSession.setStringInSession(UserSession.nightTimeEnd,
              response.varifyOtp!.NightTineEnd.toString());
          // userToken = response.varifyOtp!.loginToken.toString();
          // userId = response.varifyOtp!.id.toString();
          // userMobile = response.varifyOtp!.mobile.toString();
          // securityAmt = response.varifyOtp!.SecurityDeposit.toString();
          // isUserLoggedin = false;

          // ///.......
          // var body = <String, String>{};
          // body['authtoken'] = response.varifyOtp!.loginToken.toString();
          // // body['username'] = response.varifyOtp.userDetails.;
          // body['language_id'] = currentLocal;
          // body['country_code'] = selectedCountryCode.toString();
          // body['userid'] = response.varifyOtp!.id.toString();
          // body['status'] = response.varifyOtp!.status.toString();
          // body['mobile'] = response.varifyOtp!.mobile.toString();
          // body['securityDeposit'] =
          //     response.varifyOtp!.SecurityDeposit.toString();
          // userToken = response.varifyOtp!.loginToken.toString();

          // userId = response.varifyOtp!.id.toString();
          // userStatus = response.varifyOtp!.status.toString();
          // securityDepositAmt = response.varifyOtp!.SecurityDeposit.toString();
          // mobile = response.varifyOtp!.mobile.toString();

          // log("user token..  " + userToken.toString());

          // saveUserData(jsonEncode(body));
          // saveVerifiedData(response.varifyOtp!.documentStatus.toString());
          // print("response.varifyOtp!.documentStatus..   " +
          //     response.varifyOtp!.documentStatus.toString());
          isLoading.value = false;
          Get.offNamedUntil(
              'DocmentUploadScreen', ModalRoute.withName('LoginScreen'));
        } else {
          Get.defaultDialog(
            radius: 10.0,
            backgroundColor: ConstColor.accentColor,
            titleStyle: white18Bold500,
            middleTextStyle: white16Normal400,
            confirmTextColor: ConstColor.blackColor,
            buttonColor: ConstColor.codeTextButtonColor,
            // backgroundColor: ConstColor.accentColor,
            // confirmTextColor: ConstColor.accentColor,
            // middleTextStyle:
            //     const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // titleStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
            // buttonColor: ConstColor.bluecodeTextButtonColor,
            titlePadding: const EdgeInsetsDirectional.only(top: 15, bottom: 15),
            contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
            title: AppConstents().success_txt,
            barrierDismissible: false,
            middleText: "${response.responseMessage}",
            textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
            onConfirm: () async {
              Get.back();

              // Get.log("=--=-selectedCountryCode $selectedCountryCode");
              // // Get.log("=--=-languageIdcontroller ${languageIdcontroller.text}");
              // update();
              // var body = <String, String>{};
              // body['authtoken'] = response.varifyOtp!.loginToken.toString();
              // // body['username'] = response.varifyOtp.userDetails.;
              // body['language_id'] = currentLocal;
              // body['country_code'] = selectedCountryCode.toString();
              // body['userid'] = response.varifyOtp!.id.toString();
              // body['status'] = response.varifyOtp!.status.toString();
              // body['mobile'] = response.varifyOtp!.mobile.toString();
              // body['securityDeposit'] =
              //     response.varifyOtp!.SecurityDeposit.toString();
              // userToken = response.varifyOtp!.loginToken.toString();

              // userId = response.varifyOtp!.id.toString();
              // userStatus = response.varifyOtp!.status.toString();
              // securityDepositAmt =
              //     response.varifyOtp!.SecurityDeposit.toString();
              // mobile = response.varifyOtp!.mobile.toString();

              // log("user token..  " + userToken.toString());

              // saveUserData(jsonEncode(body));
              // saveVerifiedData(response.varifyOtp!.documentStatus.toString());
              // print("response.varifyOtp!.documentStatus..   " +
              //     response.varifyOtp!.documentStatus.toString());
              // //locationPermission();

              UserSession.setStringInSession(UserSession.keyUserToken,
                  response.varifyOtp!.loginToken.toString());
              UserSession.setStringInSession(
                  UserSession.keyUserId, response.varifyOtp!.id.toString());
              UserSession.setStringInSession(UserSession.keyUserMobile,
                  response.varifyOtp!.mobile.toString());
              UserSession.setStringInSession(UserSession.keyUserCountryCode,
                  phoneCodeController.text.toString());
              UserSession.setStringInSession(UserSession.keySecurityAmt,
                  response.varifyOtp!.SecurityDeposit.toString());
              UserSession.setBoolInSession(UserSession.keyIsLoggedIn, true);
              // userToken = response.varifyOtp!.loginToken.toString();
              // userId = response.varifyOtp!.id.toString();
              // userMobile = response.varifyOtp!.mobile.toString();
              // securityAmt = response.varifyOtp!.SecurityDeposit.toString();
              // isUserLoggedin = true;

              // SocketConnection.connectToServer();
              // await Location.locationPermission();
              // await profileController.getProfileRequest();
              // await controller.onRejectLead();
              await homeController.BookingStatusThroughFirebase(
                  isLoading.value);
              isLoading.value = false;
              //Get.offAndToNamed("HomeScreen");
            },
          );
        }
      } else {
        isLoading(false);

        update();

        Get.defaultDialog(
          radius: 10.0,
          backgroundColor: ConstColor.accentColor,
          titleStyle: white18Bold500,
          middleTextStyle: white16Normal400,
          confirmTextColor: ConstColor.blackColor,
          buttonColor: ConstColor.codeTextButtonColor,
          // backgroundColor: ConstColor.accentColor,
          // confirmTextColor: ConstColor.accentColor,
          // middleTextStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
          // titleStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
          // buttonColor: ConstColor.bluecodeTextButtonColor,
          titlePadding: const EdgeInsetsDirectional.only(top: 15, bottom: 15),
          contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
          title: AppLocalizations.of(Get.key.currentContext!)!.txt_error,
          middleText: response.responseMessage.toString(),
          textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
          barrierDismissible: false,
          onConfirm: () {
            Get.back();
          },
        );
      }
    } catch (e) {
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

extension ResendOtpRequest on AuthController {
  Future<void> resendOtpRequestApi() async {
    try {
      isLoading(true);
      update();

      final response = await networkServices.resendOtpRequest();
      if (response.succeeded == true) {
        isLoading(false);

        update();

        Get.defaultDialog(
          radius: 10.0,
          backgroundColor: ConstColor.accentColor,
          titleStyle: white18Bold500,
          middleTextStyle: white16Normal400,
          confirmTextColor: ConstColor.blackColor,
          buttonColor: ConstColor.codeTextButtonColor,
          // backgroundColor: ConstColor.accentColor,
          // confirmTextColor: ConstColor.accentColor,
          // middleTextStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
          // titleStyle: const TextStyle(color: ConstColor.blackcodeTextButtonColor),
          // buttonColor: ConstColor.bluecodeTextButtonColor,
          titlePadding: const EdgeInsetsDirectional.only(top: 15, bottom: 15),
          contentPadding: const EdgeInsetsDirectional.only(bottom: 15),
          // buttonColor: ,
          title: AppConstents().success_txt,
          middleText:
              "${AppLocalizations.of(Get.key.currentContext!)!.txt_your_otp} ${response.sendOtp!.otp.toString()} \n${response.responseMessage}",
          textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
          barrierDismissible: false,

          onConfirm: () {
            Get.back();
          },
        );
      } else {
        isLoading(false);

        update();

        Get.defaultDialog(
          radius: 10.0,
          backgroundColor: ConstColor.codeBackgroundColor,
          titleStyle: white18Bold500,
          middleTextStyle: white16Normal400,
          confirmTextColor: ConstColor.codeBackgroundColor,
          buttonColor: ConstColor.codeTextButtonColor,
          // backgroundColor: ConstColor.accentColor,
          // confirmTextColor: ConstColor.accentColor,
          // middleTextStyle: TextStyle(color: ConstColor.blackcodeTextButtonColor),
          // titleStyle: TextStyle(color: ConstColor.blackcodeTextButtonColor),
          // buttonColor: ConstColor.bluecodeTextButtonColor,
          titlePadding: EdgeInsetsDirectional.only(top: 15, bottom: 15),
          contentPadding: EdgeInsetsDirectional.only(bottom: 15),
          title: AppLocalizations.of(Get.key.currentContext!)!.txt_error,
          middleText: response.responseMessage.toString(),
          textConfirm: AppLocalizations.of(Get.key.currentContext!)!.txt_ok,
          barrierDismissible: false,
          onConfirm: () {
            Get.back();
          },
        );
      }
    } catch (e) {
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

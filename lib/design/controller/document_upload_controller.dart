import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:madr_driver/design/controller/auth_controller.dart';
import 'package:madr_driver/utils/style.dart';
import '../../utils/app_constents.dart';
import '../../services/api_sevices.dart';
import '../../utils/const_color.dart';
import '../../utils/email_rule.dart';
import '../../utils/toast.dart';
import '../../utils/user_session.dart';
import '../auth_design/auth_model/document_list_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:basic_utils/basic_utils.dart';
import '../settings/model/update_profile_model.dart';

class DocumentUploadController extends GetxController {
  Rx<TextEditingController> CarMaker = TextEditingController().obs;
  var maker = "".obs;

  Rx<TextEditingController> CarModel = TextEditingController().obs;
  var model = "".obs;
  Rx<TextEditingController> CarColor = TextEditingController().obs;
  var color = "".obs;
  Rx<TextEditingController> VehicleNumber = TextEditingController().obs;

  // var vehiclenumber = "".obs;
  Rx<TextEditingController> IdNumber = TextEditingController().obs;
  var idnumber = "".obs;
  Rx<TextEditingController> LicenseNumber = TextEditingController().obs;
  var licensenumber = "".obs;
  Rx<TextEditingController> RegistrationNumber = TextEditingController().obs;
  var regnumber = "".obs;
  Rx<TextEditingController> OwnershipNumber = TextEditingController().obs;
  var ownernumber = "".obs;
  Rx<TextEditingController> InsuranceNumber = TextEditingController().obs;
  var insurancenumber = "".obs;
  Rx<TextEditingController> InspectionNumber = TextEditingController().obs;

  // var inspecnumber = "".obs;
  Rx<TextEditingController> ManifestNumber = TextEditingController().obs;

  // var manifestnumber = "".obs;
  Rx<TextEditingController> RadioTaxNumber = TextEditingController().obs;

  //var radionumber = "".obs;
  List<String> VehicleFrontImage = [];
  var VehicleBackImage;
  var IdFrontImage, IdBackImage;
  var LicenseFrontImage, LicenseBackImage;
  var RegistrationFrontImage, RegistrationBackImage;
  var OwnershipFrontImage, OwnershipBackImage;
  var InsuranceFrontImage, InsuranceBackImage;
  var InspectionFrontImage, InspectionBackImage;
  var ManifestFrontImage, ManifestBackImage;
  var RadioTaxFrontImage, RadioTaxBackImage;
  RxString CirminalRecordImage = "".obs;

  var isVehicleFrontUpload = false.obs;
  var isVehicleBackUpload = false.obs;

  var isIdFrontUpload = false.obs;
  var isIdBackUpload = false.obs;

  var isLicenseFrontUpload = false.obs;
  var isLicenseBackUpload = false.obs;

  var isRegistrationFrontUpload = false.obs;
  var isRegistrationBackUpload = false.obs;

  var isOwnershipFrontUpload = false.obs;
  var isOwnershipBackUpload = false.obs;

  var isInsuranceFrontUpload = false.obs;
  var isInsuranceBackUpload = false.obs;

  var isInspectionFrontUpload = false.obs;
  var isInspectionBackUpload = false.obs;

  var isManifestFrontUpload = false.obs;
  var isManifestBackUpload = false.obs;

  var isRadioTaxFrontUpload = false.obs;
  var isRadioTaxBackUpload = false.obs;

  RxString IdFrom = "".obs, IdUntil = "".obs;
  RxString LicenseFrom = "".obs, LicenseUntil = "".obs;
  RxString RegistrationFrom = "".obs, RegistrationUntil = "".obs;
  RxString OwnershipFrom = "".obs, OwnershipUntil = "".obs;
  RxString InsuranceFrom = "".obs, InsuranceUntil = "".obs;
  RxString InspectionFrom = "".obs, InspectionUntil = "".obs;
  RxString ManifestFrom = "".obs, ManifestUntil = "".obs;
  RxString RadioTaxFrom = "".obs, RadioTaxiUntil = "".obs;
  RxString PassengerNo =
      AppLocalizations.of(Get.key.currentContext!)!.txt_select.obs;
  RxList<String> driverTypeList = [AppConstents().txtDailyRide].obs;
  // [AppConstents().txtDailyRide, AppConstents().txtRentalRide].obs;

  RxBool isAccept = false.obs;

  RxString termsUrl = "".obs;
  RxString privacyUrl = "".obs;

  var authController = Get.put(AuthController());
  RxString selectedCity =
      AppLocalizations.of(Get.key.currentContext!)!.txt_select.obs;

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

  RxString bitmapFront = "".obs;
  RxString bitmapBack = "".obs;

  RxString FrontFileType = "".obs;
  RxString BackFileType = "".obs;

  NetworkServices networkServices = NetworkServices();

  // RxList<DriverDocuments> documentList = <DriverDocuments>[].obs;
  RxList<DriverDocuments> documentListModel = <DriverDocuments>[].obs;

  RxBool isLoading = false.obs;
  RxBool isMpesaLoading = false.obs;
  RxBool isDocumentLoading = false.obs;
  RxBool documentListLoader = false.obs;
  RxBool depositCheck = false.obs;
  // String publicKey = "";
  String apiKey = "";
  String urlMpesa = "";
  String transactionReference = "";
  String serviceProvider = "";
  bool onlinepaymentDone = false;
  bool securityDeposit = false;

  RxList<String> genderPreference = [
    AppConstents().txtMale,
    AppConstents().txtFemale,
    // AppConstents().txtNoPref,
  ].obs;
  RxString genderTxt = "".obs;
  RxInt genderMaleValue = 2.obs;
  RxInt genderFemaleValue = 2.obs;
  RxInt genderNoValue = 2.obs;

  RxList<String> genderList = [
    AppConstents().txtMale,
    AppConstents().txtFemale,
    // AppConstents().txtOther,
  ].obs;
  RxString yourGender = "".obs;
  RxString rideTypeTxt = "0".obs;

  String publicKey = "";
  String merchantId = "";
  String paymentUrl = "";
  String secretKey = "";
  String responseDescription = "";
  Rx<TextEditingController> paymentEmailController =
      TextEditingController().obs;
  Rx<TextEditingController> paymentNameController = TextEditingController().obs;
  RxList cityList = RxList();

  @override
  void onInit() {
    getPaymentDetail();

    debounce(maker, (_) {
      print("text on execute debounce...  for car maker ");
      DriverDocumentUpload(
          AppLocalizations.of(Get.key.currentContext!)!.txt_car_maker,
          "Car Maker",
          CarMaker.value.text.toString(),
          "",
          "",
          "",
          "");
    }, time: const Duration(seconds: 1));

    debounce(model, (_) {
      print("text on execute debounce...  for car model ");
      DriverDocumentUpload(
          AppLocalizations.of(Get.key.currentContext!)!.txt_car_model,
          "Car Model",
          CarModel.value.text.toString(),
          "",
          "",
          "",
          "");
    }, time: const Duration(seconds: 1));

    debounce(color, (_) {
      print("text on execute debounce...  for car color ");
      DriverDocumentUpload(
          AppLocalizations.of(Get.key.currentContext!)!.txt_car_color,
          "Car Color",
          CarColor.value.text.toString(),
          "",
          "",
          "",
          "");
    }, time: const Duration(seconds: 1));

    debounce(idnumber, (_) {
      print("text on execute debounce...  for idnumber ");
      DriverDocumentUpload(
          AppLocalizations.of(Get.key.currentContext!)!.txt_driver_id,
          "Driver Identification card",
          IdNumber.value.text.toString(),
          IdFrontImage.toString(),
          IdBackImage.toString(),
          "",
          "");
    }, time: const Duration(seconds: 1));

    debounce(licensenumber, (_) {
      print("text on execute debounce...  for licensenumber ");
      DriverDocumentUpload(
          AppLocalizations.of(Get.key.currentContext!)!.txt_driver_driving,
          "Driver driving license",
          LicenseNumber.value.text.toString(),
          LicenseFrontImage.toString(),
          LicenseBackImage.toString(),
          "",
          "");
    }, time: const Duration(seconds: 1));

    debounce(regnumber, (_) {
      print("text on execute debounce...  for regnumber ");
      DriverDocumentUpload(
          AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_reg,
          "Vehicle registration",
          RegistrationNumber.value.text.toString(),
          RegistrationFrontImage.toString(),
          RegistrationBackImage.toString(),
          "",
          "");
    }, time: const Duration(seconds: 1));

    debounce(ownernumber, (_) {
      print("text on execute debounce...  for ownernumber ");
      DriverDocumentUpload(
          AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_owner,
          "Vehicle ownership",
          OwnershipNumber.value.text.toString(),
          OwnershipFrontImage.toString(),
          OwnershipBackImage.toString(),
          "",
          "");
    }, time: const Duration(seconds: 1));

    debounce(insurancenumber, (_) {
      print("text on execute debounce...  for insurancenumber ");
      DriverDocumentUpload(
          AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_insur,
          "Vehicle Insurance",
          InsuranceNumber.value.text.toString(),
          InsuranceFrontImage.toString(),
          "",
          "",
          "");
    }, time: const Duration(seconds: 1));

    super.onInit();
  }

  Future<void> city() async {
    try {
      var response = await networkServices
          .getCity(authController.selectedCountryCode.value);
      var jsonData = (response['ResponseBody']['list']);
      print("Citu jsonData...  " + jsonData.toString());
      cityList.addAll(jsonData);
      print("Citu list...  " + cityList.toString());
    } catch (e) {
      print("error.  " + e.toString());
    }
  }

  Future<void> updateGender() async {
    update();
    try {
      var response = await networkServices.updateProfileCall(
          UpdateProfileRequestModel(name: "", email: "", gender: genderType()));

      if (response.responseCode == 200) {
      } else {
        showFlutterToast(message: response.responseMessage.toString());
      }
    } catch (e) {
      showFlutterToast(message: e.toString());
    }
  }

  Future<void> updateRideType() async {
    update();
    try {
      var response = await networkServices.updateProfileCall(
          UpdateProfileRequestModel(
              name: "", email: "", gender: genderType(), rideType: "0"));
      if (response.responseCode == 200) {
      } else {
        showFlutterToast(message: response.responseMessage.toString());
      }
    } catch (e) {
      showFlutterToast(message: e.toString());
    }
  }

  genderType() {
    if (yourGender.value == AppConstents().txtMale) {
      return "0";
    } else if (yourGender.value == AppConstents().txtFemale) {
      return "1";
    } else if (yourGender.value == AppConstents().txtOther) {
      return "2";
    }
  }

  Future<void> updateSecurityDeposit(Map map, String securityDep) async {
    try {
      print("...   updateSecurityDeposit  ..   ");
      print(" updateSecurityDeposit map ... " + map.toString());
      final response = await networkServices.securityDeposit(map);
      print("...   updateSecurityDeposit  ..   " + response.toString());

      print(".. updateSecurityDeposit.   " +
          (response['ResponseCode'].toString()));
      if (response['ResponseCode'] == 200) {
        isLoading.value = false;
        DriverDocumentUpload(AppConstents().securityDeposit, "Security Deposit",
            securityDep, "", "", "", "");
        showFlutterToast(message: response['ResponseMessage']);
      } else {
        isLoading.value = false;
        showFlutterToast(message: response['ResponseMessage']);
      }
    } catch (e) {
      showFlutterToast(message: e.toString());
      print(e.toString());
    }
  }

  Future<void> getMpesaDetail() async {
    // isLoading.value = true;
    isMpesaLoading.value = true;
    var response = await networkServices.mpesaDetail();
    print("reeepooo.. getMpesaDetail   " + response.toString());

    try {
      if (response['ResponseCode'] == 200) {
        print("reeepooo..rest  getMpesaDetail  " + response.toString());
        publicKey = response['ResponseBody']['publicKey'];
        apiKey = response['ResponseBody']['apiKey'];
        urlMpesa = response['ResponseBody']['url'];
        transactionReference =
            response['ResponseBody']['input_TransactionReference'];
        serviceProvider = response['ResponseBody']['input_ServiceProviderCode'];
        await encryptString();
      } else {
        isMpesaLoading.value = false;
        isLoading.value = false;
        print('<<<<<<<<<<<<LotteryApp>>>>>>>>>' + response.toString());
      }
    } catch (e) {
      isMpesaLoading.value = false;
      isLoading.value = false;
      showFlutterToast(message: e.toString());
      print(" ... getMpesaDetail excep ..... " + e.toString());
    }
  }

  mpesaPayment(String accessToken) async {
    try {
      print("mpesaPayment.. response    ");
      var headers = {
        'Content-Type': 'application/json',
        'Origin': 'developer.mpesa.vm.co.mz',
        'Authorization': 'Bearer $accessToken',
      };
      var request = http.Request('POST', Uri.parse(urlMpesa));
      var reference = get6DigitNumber();
      String countryCode =
          UserSession.getStringFromSession(UserSession.keyUserCountryCode)
              .toString();
      var code = countryCode.replaceAll(('+'), '');

      request.body = json.encode({
        "input_TransactionReference": transactionReference,
        "input_CustomerMSISDN":
            "${code}${UserSession.getStringFromSession(UserSession.keyUserMobile)}",
        "input_Amount":
            UserSession.getStringFromSession(UserSession.keySecurityAmt),
        "input_ThirdPartyReference": reference,
        "input_ServiceProviderCode": serviceProvider
      });
      request.headers.addAll(headers);
      print(" " + request.body.toString());
      print(
        "${UserSession.getStringFromSession(UserSession.keyUserCountryCode)} ${UserSession.getStringFromSession(UserSession.keyUserMobile)}",
      );
      http.StreamedResponse response = await request.send();
      var responseData = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseData);
      print("mpesaPayment.. response    " + responseJson.toString());
      print("mpesaPayment.. response    " + response.statusCode.toString());

      if (responseJson["output_ResponseCode"] == "INS-0") {
        isMpesaLoading.value = false;
        isLoading.value = false;
        print("  response 200   " + responseJson.toString());

        Map map = {
          "security_deposit": "1",
          "payment_method": "Mpesa",
          "payment_mode": "Online",
          "transection_id": reference,
          "amount": UserSession.getStringFromSession(UserSession.keySecurityAmt)
        };
        onlinepaymentDone = true;
        securityDeposit = true;
        updateSecurityDeposit(map, "1");
      } else {
        isMpesaLoading.value = false;
        isLoading.value = false;
        print("  response else " +
            responseJson['output_ResponseDesc'].toString());
        showFlutterToast(message: responseJson['output_ResponseDesc']);
        // isMpesaLoading.value = false;
      }
    } catch (e) {
      isMpesaLoading.value = false;
      isLoading.value = false;
      showFlutterToast(message: e.toString());
      print(" ... mpesaPayment excep ..... " + e.toString());
    }
  }

  String get6DigitNumber() {
    Random random = Random();
    String number = '';
    for (int i = 0; i < 6; i++) {
      number = number + random.nextInt(9).toString();
    }
    return number;
  }

  Future<void> encryptString() async {
    // isLoading.value = true;
    try {
      print("encrypted.. " + publicKey);

      var modulusBytes = base64.decode(publicKey);
      print("encrypted..  modulusBytes  " + modulusBytes.toString());
      final key = CryptoUtils.rsaPublicKeyFromDERBytes(
          Uint8List.fromList(modulusBytes));
      print("encrypted..  key  " + key.toString());
      final pem = CryptoUtils.encodeRSAPublicKeyToPemPkcs1(key);
      print("encrypted..  pem  " + pem.toString());
      final RsaPublicKey = RSAKeyParser().parse(pem) as RSAPublicKey;
      print("encrypted..  publicKey  " + publicKey.toString());

      final encrypter = Encrypter(
        RSA(publicKey: RsaPublicKey, encoding: RSAEncoding.PKCS1),
      );

      print("encrypted..  encrypter  " + encrypter.toString());
      print("encrypted..  encrypter1  11  ");
      // final initVector = IV.fromUtf8(publicKey.value.substring(0, 0));
      final encrypted = encrypter.encrypt(apiKey);

      // log("encrypted..  ${encrypted.bytes}");
      print("encrypted..  ${encrypted.base64}");
      mpesaPayment(encrypted.base64);
      // log("encrypted..base64  ${encrypted.base64}");
    } catch (e) {
      isMpesaLoading.value = false;
      isLoading.value = false;
      showFlutterToast(message: e.toString());
      print(" ... encryptString excep ..... " + e.toString());
      // return "";
    }

    //
  }

  Future<void> getPaymentDetail() async {
    // isLoading.value = true;
    var response = await networkServices.openPayDetail();
    print("reeepooo.. openPayDetail   " + response.toString());

    try {
      if (response['ResponseCode'] == 200) {
        print("reeepooo..rest  openPayDetail  " + response.toString());
        publicKey = response['ResponseBody']['public_key'];
        merchantId = response['ResponseBody']['merchant_id'];
        paymentUrl = response['ResponseBody']['endpoint'];
        secretKey = response['ResponseBody']['secret_key'];
      } else {
        print('<<<<<<<<<<<<openPayDetail>>>>>>>>>' + response.toString());
      }
    } catch (e) {
      //  isLoading.value = false;
      print(" ... getMpesaDetail excep ..... " + e.toString());
    }
  }

  checkoutApi() async {
    try {
      isLoading.value = true;
      print("mpesaPayment.. response    ");
      String username = secretKey;
      String password = '-H';
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$username:$password'));
      print("basicAuth..   " + basicAuth);
      var headers = {
        'Content-Type': 'application/json',
        // 'Origin': 'developer.mpesa.vm.co.mz',
        'Authorization': basicAuth,
      };
      var request =
          http.Request('POST', Uri.parse("$paymentUrl$merchantId/checkouts"));

      print("rideData['mobile'].... " +
          "258" +
          UserSession.getStringFromSession(UserSession.keyUserMobile)
              .toString());
      print("request..  " + request.toString());
      var email =
          UserSession.getStringFromSession(UserSession.keyUserEmail) ?? "";

      request.body = json.encode({
        "amount": UserSession.getStringFromSession(UserSession.keySecurityAmt),
        "currency": "USD",
        "description": "Cargo cobro con link",
        "redirect_url": "http://52.22.241.165:10008/",
        "order_id": get6DigitNumber(),
        "expiration_date": DateTime.now().add(Duration(days: 1)).toString(),
        "send_email": "true",
        "customer": {
          "name": paymentNameController.value.text.trim() == ""
              ? UserSession.getStringFromSession(UserSession.keyUserName)
              : paymentNameController.value.text.trim(),
          "phone_number":
              UserSession.getStringFromSession(UserSession.keyUserMobile)
                  .toString(),
          "email": paymentEmailController.value.text.trim() == ""
              ? email
              : paymentEmailController.value.text.trim()
        }
      });
      print("response. request.body..  " + request.body.toString());
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var responseData = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseData);
      print("response. json..  " + responseJson.toString());
      responseDescription = responseJson['description'];
      var checkoutLink = responseJson['checkout_link'];
      if (checkoutLink != null) {
        Get.toNamed("WebViewScreen", arguments: {
          "checkoutLink": checkoutLink,
        });
        isLoading.value = false;
      } else {
        isLoading.value = false;
        //  Get.back();
        // showFlutterToast(message: responseDescription);
        if (responseDescription == "Attribute customer.name is required") {
          Get.bottomSheet(Container(
            decoration: BoxDecoration(
                color: ConstColor.accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      padding: EdgeInsetsDirectional.only(
                          top: 40, bottom: 20, start: 30),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text("Name is required")),
                  Container(
                    margin: EdgeInsetsDirectional.only(start: 30, end: 30),
                    height: 40,
                    child: TextField(
                      controller: paymentNameController.value,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      maxLength: 50,
                      decoration: InputDecoration(
                          counterText: "",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText:
                              AppLocalizations.of(Get.key.currentContext!)!
                                  .txt_name,
                          floatingLabelStyle: const TextStyle(
                              color: ConstColor.codeBackgroundColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          labelStyle: const TextStyle(
                              color: ConstColor.codeBackgroundColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          hintStyle: const TextStyle(
                              color: ConstColor.codeBackgroundColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          fillColor: ConstColor.accentColor,
                          filled: true,
                          // border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                                color: ConstColor.codeBackgroundColor,
                                width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                                color: ConstColor.codeBackgroundColor,
                                width: 1),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                  color: ConstColor.codeBackgroundColor,
                                  width: 1))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                      onTap: () {
                        String emailErrorMessage = AppValidation()
                            .fullNameValidator(
                                paymentNameController.value.text.trim());

                        if (paymentNameController.value.text.trim().isEmpty) {
                          showFlutterToast(message: "Please enter name");
                        } else if (emailErrorMessage.toString().isNotEmpty) {
                          showFlutterToast(message: emailErrorMessage);
                        } else {
                          Get.back();
                          checkoutApi();
                        }
                      },
                      child: Container(
                          height: 35,
                          width: 120,
                          // padding: EdgeInsetsDirectional.only(start: 25, end: 25),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                ConstColor.codeBackgroundColor,
                                ConstColor.codeBackgroundColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: white16Normal400,
                          ))),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
          ));
        } else if (responseDescription ==
                "Attribute customer.email is required" ||
            responseDescription.contains("valid email address")) {
          if (responseDescription.contains("valid email address")) {
            showFlutterToast(message: responseDescription);
          }
          Get.bottomSheet(Container(
            decoration: const BoxDecoration(
                color: ConstColor.accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      padding: const EdgeInsetsDirectional.only(
                          top: 40, bottom: 20, start: 30),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text("Email is required")),
                  Container(
                    margin: EdgeInsetsDirectional.only(start: 30, end: 30),
                    height: 40,
                    child: TextField(
                      controller: paymentEmailController.value,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      maxLength: 50,
                      decoration: InputDecoration(
                          counterText: "",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText:
                              AppLocalizations.of(Get.key.currentContext!)!
                                  .txt_email,
                          floatingLabelStyle: const TextStyle(
                              color: ConstColor.codeBackgroundColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          labelStyle: const TextStyle(
                              color: ConstColor.codeBackgroundColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          hintStyle: const TextStyle(
                              color: ConstColor.codeBackgroundColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          fillColor: ConstColor.accentColor,
                          filled: true,
                          // border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                                color: ConstColor.codeBackgroundColor,
                                width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                                color: ConstColor.codeBackgroundColor,
                                width: 1),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                  color: ConstColor.codeBackgroundColor,
                                  width: 1))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                      onTap: () {
                        String emailErrorMessage = AppValidation()
                            .emailValidator(
                                paymentEmailController.value.text.trim());

                        if (paymentEmailController.value.text.trim().isEmpty) {
                          showFlutterToast(message: "Please enter email id");
                        } else if (emailErrorMessage.toString().isNotEmpty) {
                          showFlutterToast(message: emailErrorMessage);
                        } else {
                          Get.back();
                          checkoutApi();
                        }
                      },
                      child: Container(
                          height: 35,
                          width: 120,
                          // padding: EdgeInsetsDirectional.only(start: 25, end: 25),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                ConstColor.codeBackgroundColor,
                                ConstColor.codeBackgroundColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: white16Normal400,
                          ))),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
          ));
        }
      }

      print("checkout_link..   " + checkoutLink.toString());
    } catch (e) {
      isLoading.value = false;
      print("response. " + responseDescription.toString());
    }
  }

  save(DocumentUploadController documentUploadController) async {
    // String idCardError =
    //     AppValidation().validateIdCard(IdNumber.value.text.toString());

    // String driverLicenseError = AppValidation()
    //     .validateDrivingLicense(LicenseNumber.value.text.toString());
    String ownerShipError = AppValidation()
        .nameLengthValidate(OwnershipNumber.value.text.toString());
    print("ownership ... length..   $ownerShipError");
    print("gender preference save..   ${genderTxt.value}");

    // var validMaker = AppValidation().AlphaNumericName(
    //     documentUploadController.CarMaker.value.text.toString());
    // var validColor = AppValidation().AlphaNumericName(
    //     documentUploadController.CarColor.value.text.toString());
    // var validOwnerName = AppValidation().AlphaNumericName(
    //     documentUploadController.OwnershipNumber.value.text.toString());

    // if (CarMaker.value.text.trim() == "") {
    //   showFlutterToast(
    //       message:
    //           AppLocalizations.of(Get.key.currentContext!)!.txt_maker_name);
    // } else
    //  if (validMaker.isNotEmpty) {
    //   showFlutterToast(message: AppConstents().ValidMakerName);
    // }
    // else if (CarModel.value.text.trim() == "") {
    //   showFlutterToast(
    //       message:
    //           AppLocalizations.of(Get.key.currentContext!)!.txt_model_name);
    // }
    //  else if (CarColor.value.text.trim() == "") {
    //   showFlutterToast(
    //       message:
    //           AppLocalizations.of(Get.key.currentContext!)!.txt_color_name);
    // }
    // else if (validColor.isNotEmpty) {
    //   showFlutterToast(message: AppConstents().ValidColorName);
    // }
    // else
    //  if (PassengerNo.value == "" ||
    //     PassengerNo.value ==
    //         AppLocalizations.of(Get.key.currentContext!)!.txt_select) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .txt_select_passenger);
    // }

    // else if (isVehicleFrontUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .txt_select_vehicle_pic);
    // }

    // else if (IdNumber.value.text.trim() == "") {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_enter_id_number);
    // }

    // else if (isIdFrontUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_upload_id_front_img);
    // } else if (isIdBackUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_upload_id_back_img);
    // }

    // else if (LicenseNumber.value.text.trim() == "") {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_enter_license_num);
    // }

    // else if (isLicenseFrontUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_upload_license_front_img);
    // } else if (isLicenseBackUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_upload_license_back_img);
    // }

    // else if (RegistrationNumber.value.text.trim() == "") {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_enter_vehicle_reg_num);
    // }

    // else if (isRegistrationFrontUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_upload_reg_front_img);
    // } else if (isRegistrationBackUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_upload_reg_back_img);
    // }

    // else if (OwnershipNumber.value.text.trim() == "") {
    //   showFlutterToast(message: AppConstents().EnterOwnerName);
    // } else if (validOwnerName.isNotEmpty) {
    //   showFlutterToast(message: AppConstents().ValidOwnerName);
    // }

    // else if (isOwnershipFrontUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_upload_owner_front_img);
    // } else if (isOwnershipBackUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_upload_owner_back_img);
    // }

    // else if (InsuranceNumber.value.text.trim() == "") {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_enter_insurance_num);
    // } else if (InsuranceNumber.value.text.length > 30) {
    //   showFlutterToast(
    //       message:
    //           AppLocalizations.of(Get.key.currentContext!)!.txt_insurance_len);
    // } else if (isInsuranceFrontUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_upload_insurance_front_img);
    // }

    // else if (isInspectionFrontUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_inspection_front_img);
    // }

    // else if (InspectionFrom.value == "") {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_inspection_start_date);
    // }

    // else if (isManifestFrontUpload.value == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_manifest_front_img);
    // } else if (ManifestFrom.value == "") {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_manifest_start_date);
    // }

    // else if (isRadioTaxFrontUpload == false) {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_radio_front_img);
    // }

    // else if (RadioTaxFrom == "") {
    //   showFlutterToast(
    //       message: AppLocalizations.of(Get.key.currentContext!)!
    //           .val_radio_start_date);
    // }
    // else
    if (yourGender.isEmpty) {
      showFlutterToast(message: AppConstents().txtSelectGender);
    }
    //  else if (genderTxt.isEmpty) {
    //   showFlutterToast(message: AppConstents().txtSelectGenderPreference);
    // }
    // else if (rideTypeTxt.isEmpty) {
    //   showFlutterToast(message: AppConstents().txtRideTypeSelection);
    // }
    else if (securityDeposit == false) {
      showFlutterToast(message: AppConstents().txtCompleteSecurityDeposit);
    } else if (isAccept.value == false) {
      showFlutterToast(message: AppConstents().txtCheckTerms);
    } else {
      // DriverDocumentUpload();
      //dispose();
      if (CirminalRecordImage.value == "") {
        DriverDocumentUpload(AppConstents().txtCriminalRecord,
            "Criminal Record", "", "", "", "", "");
      }
      uploadDocSuccessfully(documentUploadController);
    }
  }

  Future DriverDocumentList() async {
    try {
      documentListModel.value = [];
      documentListModel.clear();
      documentListLoader.value = true;
      print(" DriverDocumentList  length   ${documentListModel.length}");
      final response = await networkServices.documentList();

      final jsonData = jsonDecode(response.toString());

      if (jsonData['ResponseCode'] == 200) {
        var rest = jsonData['ResponseBody']['driverDocuments'] as List;
        print(" DriverDocumentList  length   ${rest.length}");
        documentListModel.value = (rest
            .map<DriverDocuments>((json) => DriverDocuments.fromJson(json))
            .toList());
        documentListLoader.value = false;
        print(" DriverDocumentList  length   ${documentListModel..length}");
      }
    } catch (e) {
      showFlutterToast(message: e.toString());
      documentListLoader.value = false;
    }
  }

  Future uploadDocSuccessfully(
      DocumentUploadController documentUploadController) async {
    try {
      final response = await networkServices.docupload();

      final jsonData = jsonDecode(response.toString());
      print(" doc uploadd..jsonData  $jsonData");
      if (jsonData['ResponseCode'] == 200) {
        disposeData();
        Get.delete<DocumentUploadController>();
        Get.offAndToNamed("LivePhotoScreen");
      }
    } catch (e) {
      showFlutterToast(message: e.toString());
    }
  }

  Future updateDocument() async {
    isDocumentLoading.value = true;
    try {
      documentListModel.value = [];
      documentListModel.clear();
      print(" DriverDocumentList  length   ${documentListModel.length}");
      final response = await networkServices.documentList();

      final jsonData = jsonDecode(response.toString());

      if (jsonData['ResponseCode'] == 200) {
        termsUrl.value = jsonData['ResponseBody']['terms_url'];
        privacyUrl.value = jsonData['ResponseBody']['privacy_policy_url'];
        var rest = jsonData['ResponseBody']['driverDocuments'] as List;
        print(" DriverDocumentList rest   $rest");
        documentListModel.value = (rest
            .map<DriverDocuments>((json) => DriverDocuments.fromJson(json))
            .toList());
        print(" DriverDocumentList  length   ${documentListModel.length}");

        for (int i = 0; i < documentListModel.length; i++) {
          print("documentListModel[i].type...   ${documentListModel[i].type}");
          if (documentListModel[i].type == "Car Maker") {
            CarMaker.value.text = documentListModel[i].value!;
          } else if (documentListModel[i].type == "Car Model") {
            CarModel.value.text = documentListModel[i].value!;
          } else if (documentListModel[i].type == "Car Color") {
            CarColor.value.text = documentListModel[i].value!;
          } else if (documentListModel[i].type == "No. Of Passenger") {
            PassengerNo.value = documentListModel[i].value!;
          } else if (documentListModel[i].type == "Vehicle Picture") {
            var vehiclePicListData = documentListModel[i].frontImg;

            print("ab..   vehiclePicListData  $vehiclePicListData");
            var vehiclePicList = json.encode(vehiclePicListData!);
            print("ab..  vehiclePicList   $vehiclePicList");
            for (int i = 0; i < vehiclePicList.length; i++) {
              VehicleFrontImage.add(vehiclePicList[i]);
            }

            if (documentListModel[i].frontImg!.isEmpty ||
                documentListModel[i].frontImg == "" ||
                documentListModel[i].frontImg == null ||
                documentListModel[i].frontImg == "null") {
              isVehicleFrontUpload.value = false;
            } else {
              isVehicleFrontUpload.value = true;
            }
          } else if (documentListModel[i].type ==
              "Driver Identification card") {
            IdNumber.value.text = documentListModel[i].value!;
            IdFrontImage = documentListModel[i].frontImg;
            IdBackImage = documentListModel[i].backImg;
            print("back imh...   " +
                IdBackImage +
                "  " +
                documentListModel[i].backImg.toString());
            if (documentListModel[i].frontImg!.isEmpty ||
                documentListModel[i].frontImg == "" ||
                documentListModel[i].frontImg == null ||
                documentListModel[i].frontImg == "null") {
              isIdFrontUpload.value = false;
            } else {
              isIdFrontUpload.value = true;
            }

            if (documentListModel[i].backImg == "" ||
                documentListModel[i].backImg == "null" ||
                documentListModel[i].backImg == null) {
              isIdBackUpload.value = false;
            } else {
              isIdBackUpload.value = true;
            }
            print("isIdBackUpload . .  " +
                (documentListModel[i].backImg!.isEmpty ||
                        documentListModel[i].backImg == "" ||
                        documentListModel[i].backImg == null)
                    .toString() +
                isIdBackUpload.value.toString());

            // IdNumber.value
          } else if (documentListModel[i].type == "Driver driving license") {
            LicenseNumber.value.text = documentListModel[i].value!;
            LicenseFrontImage = documentListModel[i].frontImg;
            LicenseBackImage = documentListModel[i].backImg;
            if (documentListModel[i].frontImg!.isEmpty ||
                documentListModel[i].frontImg == "" ||
                documentListModel[i].frontImg == null ||
                documentListModel[i].frontImg == "null") {
              isLicenseFrontUpload.value = false;
            } else {
              isLicenseFrontUpload.value = true;
            }
            if (documentListModel[i].backImg!.isEmpty ||
                documentListModel[i].backImg == "" ||
                documentListModel[i].backImg == null ||
                documentListModel[i].backImg == "null") {
              isLicenseBackUpload.value = false;
            } else {
              isLicenseBackUpload.value = true;
            }
          } else if (documentListModel[i].type == "Vehicle registration") {
            RegistrationNumber.value.text = documentListModel[i].value!;
            RegistrationFrontImage = documentListModel[i].frontImg;
            RegistrationBackImage = documentListModel[i].backImg;
            if (documentListModel[i].frontImg!.isEmpty ||
                documentListModel[i].frontImg == "" ||
                documentListModel[i].frontImg == null ||
                documentListModel[i].frontImg == "null") {
              isRegistrationFrontUpload.value = false;
            } else {
              isRegistrationFrontUpload.value = true;
            }
            if (documentListModel[i].backImg!.isEmpty ||
                documentListModel[i].backImg == "" ||
                documentListModel[i].backImg == null ||
                documentListModel[i].backImg == "null") {
              isRegistrationBackUpload.value = false;
            } else {
              isRegistrationBackUpload.value = true;
            }
          } else if (documentListModel[i].type == "Vehicle ownership") {
            OwnershipNumber.value.text = documentListModel[i].value!;
            OwnershipFrontImage = documentListModel[i].frontImg;
            OwnershipBackImage = documentListModel[i].backImg;
            if (documentListModel[i].frontImg!.isEmpty ||
                documentListModel[i].frontImg == "" ||
                documentListModel[i].frontImg == null ||
                documentListModel[i].frontImg == "null") {
              isOwnershipFrontUpload.value = false;
            } else {
              isOwnershipFrontUpload.value = true;
            }
            if (documentListModel[i].backImg!.isEmpty ||
                documentListModel[i].backImg == "" ||
                documentListModel[i].backImg == null ||
                documentListModel[i].backImg == "null") {
              isOwnershipBackUpload.value = false;
            } else {
              isOwnershipBackUpload.value = true;
            }
          } else if (documentListModel[i].type == "Vehicle Insurance") {
            InsuranceNumber.value.text = documentListModel[i].value!;
            InsuranceFrontImage = documentListModel[i].frontImg;
            InsuranceUntil.value = documentListModel[i].until!;
            print("vehicle insurance..   ${documentListModel[i].frontImg}");
            if (documentListModel[i].frontImg!.isEmpty ||
                documentListModel[i].frontImg == "" ||
                documentListModel[i].frontImg == null ||
                documentListModel[i].frontImg == "null") {
              print(
                  "vehicle insurance..  is null   ${documentListModel[i].frontImg}");
              isInsuranceFrontUpload.value = false;
            } else {
              print(
                  "vehicle insurance..  have val   ${documentListModel[i].frontImg}");
              isInsuranceFrontUpload.value = true;
            }
          } else if (documentListModel[i].type == "Vehicle Inspection") {
            InspectionFrontImage = documentListModel[i].frontImg;
            InspectionFrom.value = documentListModel[i].from!;
            if (documentListModel[i].frontImg!.isEmpty ||
                documentListModel[i].frontImg == "" ||
                documentListModel[i].frontImg == null ||
                documentListModel[i].frontImg == "null") {
              isInspectionFrontUpload.value = false;
            } else {
              isInspectionFrontUpload.value = true;
            }
          } else if (documentListModel[i].type == "Vehicle manifest") {
            ManifestFrontImage = documentListModel[i].frontImg;
            ManifestFrom.value = documentListModel[i].from!;
            if (documentListModel[i].frontImg!.isEmpty ||
                documentListModel[i].frontImg == "" ||
                documentListModel[i].frontImg == null ||
                documentListModel[i].frontImg == "null") {
              isManifestFrontUpload.value = false;
            } else {
              isManifestFrontUpload.value = true;
            }
          } else if (documentListModel[i].type == "Vehicle radio tax") {
            RadioTaxFrontImage = documentListModel[i].frontImg;
            RadioTaxFrom.value = documentListModel[i].from!;
            if (documentListModel[i].frontImg!.isEmpty ||
                documentListModel[i].frontImg == "" ||
                documentListModel[i].frontImg == null ||
                documentListModel[i].frontImg == "null") {
              isRadioTaxFrontUpload.value = false;
            } else {
              isRadioTaxFrontUpload.value = true;
            }
          } else if (documentListModel[i].type == "Criminal Record") {
            CirminalRecordImage.value = documentListModel[i].frontImg!;
          } else if (documentListModel[i].type == "Security Deposit") {
            var depVal = documentListModel[i].value;
            if (depVal == "0") {
              depositCheck.value = false;
              securityDeposit = false;
              onlinepaymentDone = false;
            } else if (depVal == "1") {
              depositCheck.value = false;
              securityDeposit = true;
              onlinepaymentDone = true;
            } else if (depVal == "2") {
              depositCheck.value = true;
              securityDeposit = true;
              onlinepaymentDone = false;
            }
          }
        }
        isDocumentLoading.value = false;
      }
    } catch (e) {
      isDocumentLoading.value = false;
      showFlutterToast(message: e.toString());
      print("document list exception ..    $e");
    }
  }

  Future<Map<String, dynamic>> DriverDocumentMedia(
      var file, String type) async {
    var response;
    try {
      isLoading.value = true;
      print("file..  $file");
      response = await networkServices.uploadDriverMedia(file, type);
      print("response..  $response");
      if (response['ResponseCode'] == 200) {
        isLoading.value = false;
        print("response..  $response");
      } else {
        isLoading.value = false;
        // log("updateMedia else");
        showFlutterToast(message: response['ResponseMessage']);
      }
    } catch (e) {
      // log(e.toString());
      showFlutterToast(message: response['ResponseMessage']);
    }
    return response;
  }

  Future<void> DriverDocumentUpload(
      name, type, value, frontImg, backImg, from, until) async {
    try {
      isLoading.value = true;
      Map map = {
        "documents": [
          {
            "name": name,
            "type": type,
            "value": value,
            "front_img": frontImg,
            "back_img": backImg,
            "from": from,
            "until": until
          },
          //   {
          //     "name": AppLocalizations.of(Get.key.currentContext!)!.txt_car_model,
          //     "type": "Car Model",
          //     "value": CarModel.text.toString(),
          //     "front_img": "",
          //     "back_img": "",
          //     "from": "",
          //     "until": ""
          //   },
          //   {
          //     "name": AppLocalizations.of(Get.key.currentContext!)!.txt_car_color,
          //     "type": "Car Color",
          //     "value": CarColor.text.toString(),
          //     "front_img": "",
          //     "back_img": "",
          //     "from": "",
          //     "until": ""
          //   },
          //   {
          //     "name": AppLocalizations.of(Get.key.currentContext!)!.txt_no_pass,
          //     "type": "No. Of Passenger",
          //     "value": PassengerNo.value.toString(),
          //     "front_img": "",
          //     "back_img": "",
          //     "from": "",
          //     "until": ""
          //   },
          //   {
          //     "name":
          //         AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_pic,
          //     "type": "Vehicle Picture",
          //     "value": "",
          //     "front_img": VehicleFrontImage.toString(),
          //     "back_img": "",
          //     "from": "",
          //     "until": ""
          //   },
          //   {
          //     "name": AppLocalizations.of(Get.key.currentContext!)!.txt_driver_id,
          //     "type": "Driver Identification card",
          //     "value": IdNumber.text.toString(),
          //     "front_img": IdFrontImage.toString(),
          //     "back_img": IdBackImage.toString(),
          //     "from": "",
          //     "until": ""
          //   },
          //   {
          //     "name": AppLocalizations.of(Get.key.currentContext!)!
          //         .txt_driver_driving,
          //     "type": "Driver driving license",
          //     "value": LicenseNumber.text.toString(),
          //     "front_img": LicenseFrontImage.toString(),
          //     "back_img": LicenseBackImage.toString(),
          //     "from": "",
          //     "until": ""
          //   },
          //   {
          //     "name":
          //         AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_reg,
          //     "type": "Vehicle registration",
          //     "value": RegistrationNumber.text.toString(),
          //     "front_img": RegistrationFrontImage.toString(),
          //     "back_img": RegistrationBackImage.toString(),
          //     "from": "",
          //     "until": ""
          //   },
          //   {
          //     "name":
          //         AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_owner,
          //     "type": "Vehicle ownership",
          //     "value": OwnershipNumber.text.toString(),
          //     "front_img": OwnershipFrontImage.toString(),
          //     "back_img": OwnershipBackImage.toString(),
          //     "from": "",
          //     "until": ""
          //   },
          //   {
          //     "name":
          //         AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_insur,
          //     "type": "Vehicle Insurance",
          //     "value": InsuranceNumber.text.toString(),
          //     "front_img": InsuranceFrontImage.toString(),
          //     "back_img": "",
          //     "from": "",
          //     "until": ""
          //   },
          //   {
          //     "name": AppLocalizations.of(Get.key.currentContext!)!
          //         .txt_vehicle_inspec,
          //     "type": "Vehicle Inspection",
          //     "value": "",
          //     "front_img": InspectionFrontImage.toString(),
          //     "back_img": "",
          //     "from": InspectionFrom.toString(),
          //     "until": ""
          //   },
          //   {
          //     "name":
          //         AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_mani,
          //     "type": "Vehicle manifest",
          //     "value": "",
          //     "front_img": ManifestFrontImage.toString(),
          //     "back_img": "",
          //     "from": ManifestFrom.toString(),
          //     "until": ""
          //   },
          //   {
          //     "name":
          //         AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_radio,
          //     "type": "Vehicle radio tax",
          //     "value": "",
          //     "front_img": RadioTaxFrontImage.toString(),
          //     "back_img": "",
          //     "from": RadioTaxFrom.toString(),
          //     "until": ""
          //   }
        ]
      };
      print("document uploadd...  $map");
      final response = await networkServices.documentUpload(map);
      final jsonData = jsonDecode(response.toString());
      print("responsee...  $jsonData");
      if (jsonData['ResponseCode'] == 200) {
        isLoading.value = false;
        //disposeData();
        // Get.offUntil(const ThankYouScreen(), (route) => true);
        //Get.offAndToNamed("ThankYouScreen");
      } else {
        isLoading.value = false;
        showFlutterToast(message: jsonData['ResponseMessage']);
      }
    } catch (e) {
      isLoading.value = false;
      showFlutterToast(message: e.toString());
      // log("booking status exception..  $e");
    }
  }

  Future<void> DriverDocumentEdit(
      id, name, type, value, frontImg, backImg, from, until) async {
    try {
      isLoading.value = true;
      Map map = {
        "documentId": id,
        "document": {
          "name": name,
          "type": type,
          "value": value,
          "front_img": frontImg.toString(),
          "back_img": backImg.toString(),
          "from": from,
          "until": until
        }
      };
      // log("map..  " + map.toString());
      final response = await networkServices.documentEdit(map);
      final jsonData = jsonDecode(response.toString());
      // log("json..  " + jsonData.toString());
      if (jsonData['ResponseCode'] == 200) {
        isLoading.value = false;
        showFlutterToast(message: jsonData['ResponseMessage'].toString());
        Get.back();
      }
    } catch (e) {
      isLoading.value = false;
      showFlutterToast(message: e.toString());
      // log("booking status exception..  " + e.toString());
    }
  }

  // selectDate(BuildContext context, var dateType, String insp) async {
  //   DateTime? newSelectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now().subtract(Duration(days: 365)),
  //     lastDate: DateTime.now(),
  //   );

  //   var _selectedDate = "";
  //   if (newSelectedDate != null) {
  //     if (insp == "inspection") {
  //       _selectedDate = DateFormat.yMd().format(newSelectedDate);
  //     } else {
  //       _selectedDate = DateFormat.yMd().format(newSelectedDate);
  //     }
  //   }
  //   FocusScope.of(context).unfocus();
  //   print("selected date..  " + _selectedDate.toString());
  //   return _selectedDate.toString();
  // }

  Future selectDate(
      BuildContext context, var dateType, String insurance) async {
    var _selectedDate = "";

    await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.only(
                        start: 22, end: 22, top: 14, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            // return _selectedDate;
                            _selectedDate = '';
                          },
                          child: Text(
                            AppConstents().Cancel,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              // return _selectedDate;
                              if (_selectedDate.isEmpty ||
                                  _selectedDate == '') {
                                var date =
                                    DateFormat.d().format(DateTime.now());
                                var month =
                                    DateFormat.M().format(DateTime.now());
                                var year =
                                    DateFormat.y().format(DateTime.now());
                                _selectedDate = "$date-$month-$year";
                              }
                            },
                            child: Text(
                              AppConstents().Confirm,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                      child: CupertinoDatePicker(
                    // context: context,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    minimumDate: insurance == "insurance"
                        ? DateTime.now()
                        : DateTime.now().subtract(Duration(days: 365 * 100)),
                    initialDateTime: DateTime.now(),
                    maximumDate: insurance == "insurance"
                        ? DateTime.now().add(Duration(days: 365 * 100))
                        : DateTime.now(),

                    onDateTimeChanged: (DateTime value) {
                      if (insurance == "insurance") {
                        var date = DateFormat.d().format(value);
                        var month = DateFormat.M().format(value);
                        var year = DateFormat.y().format(value);
                        _selectedDate = "$date-$month-$year";
                        print(
                            "select date through ios picker...     $_selectedDate");
                      } else {
                        var date = DateFormat.d().format(value);
                        var month = DateFormat.M().format(value);
                        var year = DateFormat.y().format(value);
                        _selectedDate = "$date-$month-$year";
                        print(
                            "select date through ios picker...     $_selectedDate");
                      }
                    },
                  ))
                ],
              ));
        });
    print("selected date test ..  $_selectedDate");
    return _selectedDate;

    // var _selectedDate = "";
    // await CupertinoDatePicker(
    //   // context: context,
    //   initialDateTime: DateTime.now(),
    //   minimumDate: DateTime.now().subtract(const Duration(days: 365)),
    //   maximumDate: DateTime.now(),
    //   onDateTimeChanged: (DateTime value) {
    //     if (value != null) {
    //       if (insp == "inspection") {
    //         _selectedDate = DateFormat.yMd().format(value);
    //       } else {
    //         _selectedDate = DateFormat.yMd().format(value);
    //       }
    //     }
    //   },
    // );

    // FocusScope.of(context).unfocus();

    // print("selected date.selectt.  " + selectt.toString());

    // selectt.then((value) {
    //   return value;
    // });
  }

  Future<String> compressAndSendPath(File originalImagePath,
      {int quality = 80}) async {
    try {
      // Read the original image file as bytes
      // File originalFile = File(originalImagePath);
      Uint8List originalBytes = await originalImagePath.readAsBytes();

      // Compress the image
      List<int> compressedData = await FlutterImageCompress.compressWithList(
        originalBytes,
        minHeight: 1920,
        minWidth: 1080,
        quality: quality,
      );

      // Create a new file for the compressed image
      String compressedImagePath =
          originalImagePath.path.replaceAll('.jpg', '_compressed.jpg');
      File compressedFile = File(compressedImagePath);

      // Write the compressed data to the new file
      await compressedFile.writeAsBytes(compressedData);

      // Return the path to the compressed image file
      return compressedImagePath;
    } catch (e) {
      print("camera.  erroe..  " + e.toString());
      return "";
    }
  }

  Future<String?> pickFile() async {
    String? valFile;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      // allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      String compressedImagePath =
          await compressAndSendPath(File(file.path.toString()));

      await DriverDocumentMedia(compressedImagePath.toString(), "single")
          .then((value) {
        print(
            "media upload response..  ${value['ResponseBody']['mediaUrl'][0]['path']}");
        valFile = (value['ResponseBody']['mediaUrl'][0]['path'].toString());
        print("val..  " + valFile.toString());
        showFlutterToast(
            message: AppLocalizations.of(Get.key.currentContext!)!
                .txt_file_selected);
        return valFile;
      });
    } else {
      print('No file selected');
      showFlutterToast(
          message: AppLocalizations.of(Get.key.currentContext!)!
              .txt_nofile_selected);
      return ('');
    }
    return valFile;
    // PermissionStatus permissionStatus = await Permission.storage.request();
    // // log("permissionStatus..222  " + permissionStatus.toString());
    // if (permissionStatus.isLimited ||
    //     permissionStatus.isDenied ||
    //     permissionStatus.isRestricted) {
    //   // Get.back();
    //   FocusManager.instance.primaryFocus?.unfocus();
    //   showDialog(
    //       context: Get.key.currentContext!,
    //       barrierDismissible: false,
    //       builder: (BuildContext context) => AlertDialog(
    //           title: Text(AppLocalizations.of(Get.key.currentContext!)!
    //               .txt_gallery_permission),
    //           content: Container(
    //               color: Colors.white,
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   Container(
    //                       child: Text(
    //                     AppLocalizations.of(Get.key.currentContext!)!
    //                         .txt_permision_gallery,
    //                     style: const TextStyle(
    //                         fontSize: 16, fontWeight: FontWeight.w400),
    //                   )),
    //                   InkWell(
    //                     onTap: () {
    //                       Get.back();
    //                       FocusManager.instance.primaryFocus?.unfocus();
    //                       Permission.storage.request();
    //                     },
    //                     child: Container(
    //                         decoration: linearColorDecoration,
    //                         margin: const EdgeInsetsDirectional.only(
    //                             top: 15, bottom: 10),
    //                         padding: const EdgeInsetsDirectional.only(
    //                             start: 55, end: 55, top: 8, bottom: 8),
    //                         child: Text(
    //                             AppLocalizations.of(Get.key.currentContext!)!
    //                                 .txt_retry,
    //                             style: const TextStyle(
    //                                 fontSize: 16,
    //                                 fontWeight: FontWeight.w600,
    //                                 color: Colors.white))),
    //                   ),
    //                   InkWell(
    //                       onTap: () {
    //                         Get.back();
    //                         FocusManager.instance.primaryFocus?.unfocus();
    //                       },
    //                       child: Text(
    //                           AppLocalizations.of(Get.key.currentContext!)!
    //                               .txt_im_sure,
    //                           style: const TextStyle(
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w600,
    //                           )))
    //                 ],
    //               ))));
    // } else if (permissionStatus.isGranted) {
    //   FilePickerResult? result = await FilePicker.platform.pickFiles(
    //     type: FileType.image,
    //     // allowedExtensions: ['jpg', 'pdf', 'doc'],
    //   );

    //   if (result != null) {
    //     PlatformFile file = result.files.first;

    //     showFlutterToast(
    //         message: AppLocalizations.of(Get.key.currentContext!)!
    //             .txt_file_selected);
    //     await DriverDocumentMedia(file.path.toString(), "single").then((value) {
    //       print(
    //           "media upload response..  ${value['ResponseBody']['mediaUrl'][0]['path']}");
    //       valFile = (value['ResponseBody']['mediaUrl'][0]['path'].toString());
    //       print("val..  " + valFile.toString());
    //       return valFile;
    //     });
    //   } else {
    //     print('No file selected');
    //     showFlutterToast(
    //         message: AppLocalizations.of(Get.key.currentContext!)!
    //             .txt_nofile_selected);
    //     return ('');
    //   }
    //   return valFile;
    // } else if (permissionStatus.isPermanentlyDenied) {
    //   openAppSettings();
    //   // return File('');
    // }
    // return null;
  }

  Future<dynamic> multipleImagePicker() async {
    var retVal;
    isLoading.value = true;

    await ImagePicker()
        .pickMultiImage(
      requestFullMetadata: false,
      maxWidth: 1500,
      maxHeight: 1500,
      imageQuality: 70,
    )
        .then((value) async {
      print("image ,...   $value");
      // ignore: unnecessary_null_comparison
      if (value != null) {
        //  PlatformFile file = resultList as PlatformFile;
        if (value.length > 10 || value.isEmpty) {
          isLoading.value = false;
          showFlutterToast(
              message:
                  AppLocalizations.of(Get.key.currentContext!)!.txt_select_max);
          if (value.length > 10 || value.isEmpty) {
            isVehicleFrontUpload.value = false;
          } else {
            isVehicleFrontUpload.value = true;
          }
          // retVal = [];
          // return (retVal);
        } else {
          isLoading.value = false;

          // retVal.clear();
          if (value.length > 10 || value.isEmpty) {
            isVehicleFrontUpload.value = false;
          } else {
            isVehicleFrontUpload.value = true;
          }

          await DriverDocumentMedia(value, "multiple").then((value) {
            print("media upload response..  $value");
            print("return..  ee ${value['ResponseBody']['mediaUrl']}");
            retVal = jsonEncode(value['ResponseBody']['mediaUrl']);
            print("return..  ee $retVal");
            showFlutterToast(
                message: AppLocalizations.of(Get.key.currentContext!)!
                    .txt_file_selected);
            // return retVal;
            return (retVal);
          });
        }
        //  return (retVal['ResponseBody']['mediaUrl']);
      } else {
        print('No file selected');
        isLoading.value = false;
        showFlutterToast(
            message: AppLocalizations.of(Get.key.currentContext!)!
                .txt_nofile_selected);
        return retVal;
      }
      print("return..  retVal $retVal");
      return (retVal);
    });

    // PermissionStatus permissionStatus = await Permission.storage.request();
    // // log("permissionStatus..222  " + permissionStatus.toString());
    // if (permissionStatus.isLimited ||
    //     permissionStatus.isDenied ||
    //     permissionStatus.isRestricted) {
    //   // Get.back();
    //   FocusManager.instance.primaryFocus?.unfocus();
    //   isLoading.value = false;
    //   showDialog(
    //       context: Get.key.currentContext!,
    //       barrierDismissible: false,
    //       builder: (BuildContext context) => AlertDialog(
    //           title: Text(AppLocalizations.of(Get.key.currentContext!)!
    //               .txt_gallery_permission),
    //           content: Container(
    //               // height: 160,
    //               color: Colors.white,
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   Container(
    //                       child: Text(
    //                     AppLocalizations.of(Get.key.currentContext!)!
    //                         .txt_permision_gallery,
    //                     style: TextStyle(
    //                         fontSize: 16, fontWeight: FontWeight.w400),
    //                   )),
    //                   InkWell(
    //                     onTap: () {
    //                       Get.back();
    //                       FocusManager.instance.primaryFocus?.unfocus();
    //                       Permission.storage.request();
    //                     },
    //                     child: Container(
    //                         decoration: linearColorDecoration,
    //                         margin: const EdgeInsetsDirectional.only(
    //                             top: 15, bottom: 10),
    //                         padding: const EdgeInsetsDirectional.only(
    //                             start: 55, end: 55, top: 8, bottom: 8),
    //                         child: Text(
    //                             AppLocalizations.of(Get.key.currentContext!)!
    //                                 .txt_retry,
    //                             style: TextStyle(
    //                                 fontSize: 16,
    //                                 fontWeight: FontWeight.w600,
    //                                 color: Colors.white))),
    //                   ),
    //                   InkWell(
    //                       onTap: () {
    //                         Get.back();
    //                         FocusManager.instance.primaryFocus?.unfocus();
    //                       },
    //                       child: Container(
    //                         child: Text(
    //                             AppLocalizations.of(Get.key.currentContext!)!
    //                                 .txt_im_sure,
    //                             style: TextStyle(
    //                               fontSize: 14,
    //                               fontWeight: FontWeight.w600,
    //                             )),
    //                       ))
    //                 ],
    //               ))));
    // } else if (permissionStatus.isGranted) {
    //   await ImagePicker()
    //       .pickMultiImage(requestFullMetadata: false)
    //       .then((value) async {
    //     print("image ,...   $value");
    //     // ignore: unnecessary_null_comparison
    //     if (value != null) {
    //       //  PlatformFile file = resultList as PlatformFile;
    //       if (value.length > 10 || value.isEmpty) {
    //         isLoading.value = false;
    //         showFlutterToast(
    //             message: AppLocalizations.of(Get.key.currentContext!)!
    //                 .txt_select_max);
    //         if (value.length > 10 || value.isEmpty) {
    //           isVehicleFrontUpload.value = false;
    //         } else {
    //           isVehicleFrontUpload.value = true;
    //         }
    //         // retVal = [];
    //         // return (retVal);
    //       } else {
    //         isLoading.value = false;
    //         showFlutterToast(
    //             message: AppLocalizations.of(Get.key.currentContext!)!
    //                 .txt_file_selected);
    //         // retVal.clear();
    //         if (value.length > 10 || value.isEmpty) {
    //           isVehicleFrontUpload.value = false;
    //         } else {
    //           isVehicleFrontUpload.value = true;
    //         }

    //         await DriverDocumentMedia(value, "multiple").then((value) {
    //           print("media upload response..  $value");
    //           print("return..  ee ${value['ResponseBody']['mediaUrl']}");
    //           retVal = jsonEncode(value['ResponseBody']['mediaUrl']);
    //           print("return..  ee $retVal");
    //           // return retVal;
    //           return (retVal);
    //         });
    //       }
    //       //  return (retVal['ResponseBody']['mediaUrl']);
    //     } else {
    //       print('No file selected');
    //       isLoading.value = false;
    //       showFlutterToast(
    //           message: AppLocalizations.of(Get.key.currentContext!)!
    //               .txt_nofile_selected);
    //       return retVal;
    //     }
    //     print("return..  retVal $retVal");
    //     return (retVal);
    //   });
    // } else if (permissionStatus.isPermanentlyDenied) {
    //   isLoading.value = false;
    //   openAppSettings();
    //   // retVal = [];
    // }
    return (retVal);
    //return retVal;
  }

  // Future<List<File?>?> multipleImagePicker() async {
  //   List<File?> resultList = [];
  //   // try {
  //   resultList = (await MultiImagePicker.pickImages(
  //     maxImages: 300,
  //     enableCamera: true,
  //   ))
  //       .cast<File>();

  //   //} on Exception catch (e) {
  //   // print(e);
  //   //}

  //   if (resultList != null) {
  //     //  PlatformFile file = resultList as PlatformFile;

  //     showFlutterToast(
  //         message:
  //             AppLocalizations.of(Get.key.currentContext!)!.txt_file_selected);
  //     // DriverDocumentMedia(file.path.toString());
  //     return resultList;
  //   } else {
  //     print('No file selected');
  //     showFlutterToast(
  //         message: AppLocalizations.of(Get.key.currentContext!)!
  //             .txt_nofile_selected);
  //     return null;
  //   }
  // }

  Future<String?> EditPickFile(var type) async {
    String? valfile;
    isLoading.value = true;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      //  allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      isLoading.value = false;
      PlatformFile file = result.files.first;

      String compressedImagePath =
          await compressAndSendPath(File(file.path.toString()));

      // var resp;

      await DriverDocumentMedia(compressedImagePath.toString(), "single")
          .then((value) {
        print(
            "media upload response..  ${value['ResponseBody']['mediaUrl'][0]['path']}");
        // resp = value;
        if (type == "front") {
          bitmapFront.value = file.path.toString();
          FrontFileType.value = file.extension.toString();
        } else {
          bitmapBack.value = file.path.toString();
          BackFileType.value = file.extension.toString();
        }
        valfile = jsonEncode(value['ResponseBody']['mediaUrl'][0]['path']);
        showFlutterToast(
            message: AppLocalizations.of(Get.key.currentContext!)!
                .txt_file_selected);
        print("val...   file.. $valfile");
      });
      return valfile;
    } else {
      isLoading.value = false;
      print('No file selected');
      showFlutterToast(
          message: AppLocalizations.of(Get.key.currentContext!)!
              .txt_nofile_selected);
      //return File('');
    }
    return null;
  }

  disposeData() {
    //  dispose();
    // maker.value = '';
    // model.value = '';
    // color.value = '';
    // idnumber.value = '';
    // regnumber.value = '';
    // ownernumber.value = '';
    // insurancenumber.value = '';
    CarMaker.value.clear();
    CarModel.value.clear();
    CarColor.value.clear();
    PassengerNo.value = "";
    bitmapBack.value = "";
    bitmapFront.value = "";
    VehicleNumber.value.clear();
    IdNumber.value.clear();
    LicenseNumber.value.clear();
    RegistrationNumber.value.clear();
    OwnershipNumber.value.clear();
    InsuranceNumber.value.clear();
    InspectionNumber.value.clear();
    ManifestNumber.value.clear();
    RadioTaxNumber.value.clear();
    VehicleFrontImage = [];
    VehicleBackImage = null;
    IdFrontImage = null;
    IdBackImage = null;
    LicenseFrontImage = null;
    LicenseBackImage = null;
    RegistrationFrontImage = null;
    RegistrationBackImage = null;
    OwnershipFrontImage = null;
    OwnershipBackImage = null;
    InsuranceFrontImage = null;
    InsuranceBackImage = null;
    InspectionFrontImage = null;
    InspectionBackImage = null;
    ManifestFrontImage = null;
    ManifestBackImage = null;
    RadioTaxFrontImage = null;
    RadioTaxBackImage = null;

    isVehicleFrontUpload.value = false;
    isVehicleBackUpload.value = false;

    isIdFrontUpload.value = false;
    isIdBackUpload.value = false;

    isLicenseFrontUpload.value = false;
    isLicenseBackUpload.value = false;

    isRegistrationFrontUpload.value = false;
    isRegistrationBackUpload.value = false;

    isOwnershipFrontUpload.value = false;
    isOwnershipBackUpload.value = false;

    isInsuranceFrontUpload.value = false;
    isInsuranceBackUpload.value = false;

    isInspectionFrontUpload.value = false;
    isInspectionBackUpload.value = false;

    isManifestFrontUpload.value = false;
    isManifestBackUpload.value = false;

    isRadioTaxFrontUpload.value = false;
    isRadioTaxBackUpload.value = false;

    IdFrom.value = "";
    IdUntil.value = "";
    LicenseFrom.value = "";
    LicenseUntil.value = "";
    RegistrationFrom.value = "";
    RegistrationUntil.value = "";
    OwnershipFrom.value = "";
    OwnershipUntil.value = "";
    InsuranceFrom.value = "";
    InsuranceUntil.value = "";
    InspectionFrom.value = "";
    InspectionUntil.value = "";
    ManifestFrom.value = "";
    ManifestUntil.value = "";
    RadioTaxFrom.value = "";
    RadioTaxiUntil.value = "";
    documentListModel.clear();
    isLoading.value = false;
    isDocumentLoading.value = false;
    depositCheck.value = false;
    publicKey = "";
    apiKey = "";
    urlMpesa = "";
    transactionReference = "";
    serviceProvider = "";
    onlinepaymentDone = false;
    securityDeposit = false;
    yourGender.value = "";
    genderTxt.value = "";
    rideTypeTxt.value = "0";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<dynamic> cameraGallery(bool isMultiple,
      {bool? isEdit, String? imgType}) async {
    // Use a Completer to capture the result from the bottom sheet
    final Completer<dynamic> completer = Completer<dynamic>();

    showModalBottomSheet(
      context: Get.key.currentContext!,
      isDismissible:
          false, // Prevent dismissing the bottom sheet by tapping outside
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo),
                title: Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_gallery),
                onTap: () async {
                  Get.back();
                  final returnVal = await getFtyeImage(
                      ImageSource.gallery, isMultiple, isEdit, imgType);
                  completer
                      .complete(returnVal); // Complete the completer with data
                  // Dismiss the bottom sheet
                },
              ),
              isMultiple == false
                  ? ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: Text(AppLocalizations.of(Get.key.currentContext!)!
                          .txt_camera),
                      onTap: () async {
                        Get.back();
                        final returnVal = await getFtyeImage(
                            ImageSource.camera, isMultiple, isEdit, imgType);
                        completer.complete(
                            returnVal); // Complete the completer with data
                        // Get.back(); // Dismiss the bottom sheet
                      },
                    )
                  : Container(),
            ],
          ),
        );
      },
    );

    // Wait for the completer to be completed and return the result
    return completer.future;
  }

  Future<dynamic> getFtyeImage(
      ImageSource type, bool isMultiple, bool? isEdit, String? imgType) async {
    try {
      late var data;
      print("isEdit..  " + isEdit.toString());
      // var data;
      if (type == ImageSource.camera) {
        PermissionStatus permissionStatus = await Permission.camera.status;
        print("permissionStatus.. 11 " + permissionStatus.toString());
        if (permissionStatus.isLimited ||
            permissionStatus.isPermanentlyDenied ||
            permissionStatus.isRestricted) {
          print("permissionStatus.. denied ");
          Get.back();
          showFlutterToast(message: AppConstents().cameraSettingPermission);
        } else if (permissionStatus.isGranted) {
          print(type.toString());
          // FocusManager.instance.primaryFocus?.unfocus();
          // Use camera to take a picture
          // Replace the following line with actual image capture code
          if (isEdit == true) {
            await ImagePicker()
                .pickImage(source: ImageSource.camera)
                .then((value) async {
              PlatformFile file = PlatformFile(
                name: value!.name,
                path: value.path,
                size: await value.length(),
              );
              print("camera file..     " + file.toString());
              String compressedImagePath =
                  await compressAndSendPath(File(file.path.toString()));
              print("camera file..   " + compressedImagePath.toString());
              await DriverDocumentMedia(
                      compressedImagePath.toString(), "single")
                  .then((val) {
                print(
                    "media upload response..  ${val['ResponseBody']['mediaUrl'][0]['path']}");
                // resp = value;
                if (imgType == "front") {
                  bitmapFront.value = file.path.toString();
                  FrontFileType.value = file.extension.toString();
                } else {
                  bitmapBack.value = file.path.toString();
                  BackFileType.value = file.extension.toString();
                }
                data = jsonEncode(val['ResponseBody']['mediaUrl'][0]['path']);
                print("val...   file.. $data");
                return data;
              });
            });
          } else {
            await ImagePicker()
                .pickImage(source: ImageSource.camera)
                .then((value) async {
              // data = value!.path;
              print(":data ..   " + value.toString());

              PlatformFile file = PlatformFile(
                name: value!.name,
                path: value.path,
                size: await value.length(),
              );
              print(":data ..file   " + file.toString());
              String compressedImagePath =
                  await compressAndSendPath(File(file.path.toString()));
              print(":data ..  compressedImagePath  " +
                  compressedImagePath.toString());

              await DriverDocumentMedia(
                      compressedImagePath.toString(), "single")
                  .then((value) {
                print(
                    "media upload response..  ${value['ResponseBody']['mediaUrl'][0]['path']}");
                data =
                    (value['ResponseBody']['mediaUrl'][0]['path'].toString());
                print("val..  " + data.toString());
                showFlutterToast(
                    message: AppLocalizations.of(Get.key.currentContext!)!
                        .txt_file_selected);
                return data;
              });
            });
          }
        } else if (permissionStatus.isDenied) {
          // Get.back();
          FocusManager.instance.primaryFocus?.unfocus();
          var requestResult = await Permission.camera.request();
          if (requestResult == PermissionStatus.granted) {
            // Use camera to take a picture
            // Replace the following line with actual image capture code
            if (isEdit == true) {
              await ImagePicker()
                  .pickImage(source: ImageSource.camera)
                  .then((value) async {
                PlatformFile file = PlatformFile(
                  name: value!.name,
                  path: value.path,
                  size: await value.length(),
                );
                String compressedImagePath =
                    await compressAndSendPath(File(file.path.toString()));

                await DriverDocumentMedia(
                        compressedImagePath.toString(), "single")
                    .then((val) {
                  print(
                      "media upload response..  ${val['ResponseBody']['mediaUrl'][0]['path']}");
                  // resp = value;
                  if (imgType == "front") {
                    bitmapFront.value = file.path.toString();
                    FrontFileType.value = file.extension.toString();
                  } else {
                    bitmapBack.value = file.path.toString();
                    BackFileType.value = file.extension.toString();
                  }
                  data = jsonEncode(val['ResponseBody']['mediaUrl'][0]['path']);
                  print("val...   file.. $data");
                  return data;
                });
              });
            } else {
              await ImagePicker()
                  .pickImage(source: ImageSource.camera)
                  .then((value) async {
                //var data = value!.path;

                PlatformFile file = PlatformFile(
                  name: value!.name,
                  path: value.path,
                  size: await value.length(),
                );
                String compressedImagePath =
                    await compressAndSendPath(File(file.path.toString()));

                await DriverDocumentMedia(
                        compressedImagePath.toString(), "single")
                    .then((value) {
                  print(
                      "media upload response..  ${value['ResponseBody']['mediaUrl'][0]['path']}");
                  data =
                      (value['ResponseBody']['mediaUrl'][0]['path'].toString());
                  showFlutterToast(
                      message: AppLocalizations.of(Get.key.currentContext!)!
                          .txt_file_selected);
                  print("val..  " + data.toString());
                  return data;
                });
              });
            }
          } else {
            showFlutterToast(message: AppConstents().cameraSettingPermission);
          }
        }
      } else if (type == ImageSource.gallery) {
        if (Platform.isIOS || Platform.isAndroid) {
          if (isMultiple) {
            data = await multipleImagePicker();
            return data;
          } else {
            if (isEdit == true) {
              data = await EditPickFile(imgType);
              return data;
            } else {
              data = await pickFile();
              return data;
            }
          }
        } else {
          PermissionStatus permissionStatus =
              await Permission.storage.request();
          print("permissionStatus..222  " + permissionStatus.toString());
          if (permissionStatus.isLimited ||
              permissionStatus.isDenied ||
              permissionStatus.isRestricted) {
            showFlutterToast(message: AppConstents().cameraSettingPermission);
          } else if (permissionStatus.isGranted) {
            if (isMultiple) {
              data = await multipleImagePicker();
              return data;
            } else {
              if (isEdit == true) {
                data = await EditPickFile(imgType);
                return data;
              } else {
                data = await pickFile();
                return data;
              }
            }
          } else if (permissionStatus.isPermanentlyDenied) {
            showFlutterToast(message: AppConstents().gallerySettingPermission);
          }
        }
      }
      return data;
    } catch (e) {
      Get.back();
      print("Exception - profile_picture.dart - selectImageFromGallery()" +
          e.toString());
      return null; // Return null or an appropriate error value
    }
  }

  // multipleVehicleDoc() async {
  //   // FocusScope.of(context).unfocus();
  //                                         await multipleImagePicker()
  //                                             .then((value) {
  //                                           VehicleFrontImage.clear();
  //                                           var returnVal = jsonDecode(value);
  //                                           print(
  //                                               " multiple .. upload.. $returnVal");
  //                                           if (returnVal != null) {
  //                                             for (int i = 0;
  //                                                 i < returnVal.length;
  //                                                 i++) {
  //                                               print(
  //                                                   "value.  path..  ${returnVal[i]['path']}");

  //                                                       VehicleFrontImage
  //                                                   .add(
  //                                                       (returnVal[i]['path']));
  //                                               print(
  //                                                   "multi image picker..   ${VehicleFrontImage}");
  //                                             }
  //                                             //

  //                                             print(
  //                                                 "text on submit   ${CarMaker.value.text}");

  //                                                 DriverDocumentUpload(
  //                                                     AppLocalizations.of(Get
  //                                                             .key
  //                                                             .currentContext!)!
  //                                                         .txt_vehicle_pic,
  //                                                     "Vehicle Picture",
  //                                                     "",

  //                                                           VehicleFrontImage
  //                                                         .toString(),
  //                                                     "",
  //                                                     "",
  //                                                     "");
  //                                           }
  //                                         });

  // }
}

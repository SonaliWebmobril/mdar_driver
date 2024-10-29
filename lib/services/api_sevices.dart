import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:madr_driver/design/auth_design/auth_model/country_model.dart';
import 'package:madr_driver/design/dashboard/model/driver_status_model.dart';
import 'package:madr_driver/design/settings/model/update_profile_model.dart';

import 'package:http/http.dart' as http;
import 'package:madr_driver/design/settings/model/wallet_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../utils/app_constents.dart';
import '../design/auth_design/auth_model/login_model.dart';
import '../design/auth_design/auth_model/verify_otp_model.dart';
import '../design/dashboard/model/waiting_booking_list.dart';
import '../design/settings/model/get_profile.dart';
import '../design/settings/model/my_trip_details_response_model.dart';
import '../design/settings/model/my_trip_response_model.dart';
import '../design/settings/model/transaction_history_model.dart';

import '../utils/user_session.dart';
import 'custom_interceptor.dart';

class NetworkServices extends GetConnect {
  var dio = Dio();

  static String loginUrlEndpoint = 'user/login_register';
  static String signupUrlEndPont = "user/register";
  static String resendOtpUrlEndpoint = "user/resend_otp";
  static String verifyOptUrlEndpoint = "user/verify_otp";
  static String getProfileUrlEndPoint = "driver/get_profile";
  static String logoutUserUrlEndPoint = "user/logout";
  static String updateProfileEndPoint = "driver/update_profile";
  static String deiverStatusEndPoint = "driver/changeStatus";
  static String myTripUserEndPoint = "driver/getBookingList";
  static String myTripDetailsEndPint = "driver/getBookingDetail/";
  static String myTripTransactionHistoryEndPoint = "driver/getPaymentSummary";
  static String driverBookingStatus = "booking/inProgressBooking";
  static String driverImageUpload = "driver/update_profile_pic";
  static String ChatHistory = "chat/chat_history";
  static String ChatMediaUpload = "chat/media_upload";
  static String driverMedia = "driver/driverMediaUpload";
  static String driverDocument = "driver/driverDocumentUpload";
  static String driverDocumentList = "driver/driverDocumentList";
  static String driverDocumentEdit = "driver/driverDocumentEdit";
  static String driverDocUpload = "driver/driverDocumentUploadDone";
  static String SocialLoginUrlEndpoint = 'user/social_login';
  static String SocialMobileUpdateUrlEndpoint = 'user/social_mobile_update';
  static String updateLanguageEndPoint = 'driver/update_language';
  static String scheduleRideList = 'booking/get-scheduled-ride';
  static String acceptScheduleRideEndpoint = 'booking/accept-scheduled-ride';
  static String cancelScheduleRideEndpoint = 'booking/cancel-scheduled-ride';
  static String waitingBookingEndpoint = 'booking/waitingBooking';
  static String inProgressBookingEndpoints = 'booking/inProgressBooking';
  static String countryListEndPoint = 'country-list';
  static String termsConditionEndPoint = 'terms-and-conditions';
  static String deleteEndPoint = "/driver/delete";
  static String rateUserEndPoint = "/booking/user-rating";
  static String cityEndPoint = "city-list";
  static String logoutEndPoint = "/logout";

  NetworkServices() {
    // if (UserSession.getBoolFromSession(UserSession.keyIsLoggedIn) == true) {
    //   dio.options.headers.addAll({
    //     "Authorization":
    //         "Bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}",
    //     'accept-language': UserSession.getLng(UserSession.keyLocalLng)
    //   });
    // }
    //dio.options.sendTimeout = const Duration(seconds: 5);
    // dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.baseUrl = AppConstents.baseUrl;
    dio.interceptors.addAll(
        [CustomInterceptor(), PrettyDioLogger(), ChuckerDioInterceptor()]);
  }

  Future<dynamic> bookingStatusMethod() async {
    dio.options.headers['accept-language'] =
        "${UserSession.getLng(UserSession.keyLocalLng)} ";
    dio.options.headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    print(
        " user token..  ${UserSession.getStringFromSession(UserSession.keyUserToken)}");
    final response = await dio.get(inProgressBookingEndpoints);

    print("<<<<<< booking/inProgressBookingEndpoints >>>>${response.data}");

    return json.encode(response.data);
  }

  Future<WaitingBookingList> waitingBookings() async {
    dio.options.headers['accept-language'] =
        "${UserSession.getLng(UserSession.keyLocalLng)} ";
    dio.options.headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    final response = await dio.get(waitingBookingEndpoint);

    print("<<<<<< booking/waitingBookings >>>>${response.data}");

    return WaitingBookingList.fromJson(response.data);
  }

  Future<CountryModel> countryListMethod() async {
    final response = await dio.get(countryListEndPoint);

    print("<<<<<< booking/countryListEndPoint >>>>${response.data}");

    return CountryModel.fromJson(response.data);
  }

  Future<dynamic> termsConditionMethod() async {
    final response = await dio.get(termsConditionEndPoint);

    print("<<<<<< booking/termsConditionEndPoint >>>>${response.data}");

    return json.encode(response.data);
  }

  Future<dynamic> rateUser(map) async {
    dio.options.headers['accept-language'] =
        "${UserSession.getLng(UserSession.keyLocalLng)} ";
    dio.options.headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    final response = await dio.post(rateUserEndPoint, data: map);

    print("<<<<<< booking/rate user >>>>${response.data}");

    return (response.data);
  }

  Future<dynamic> getCity(country) async {
    dio.options.headers['accept-language'] =
        "${UserSession.getLng(UserSession.keyLocalLng)} ";
    dio.options.headers['content-type'] = "application/json";
    final response = await dio.get("$cityEndPoint?country_code=$country");

    print("<<<<<< booking/getCity >>>>${response.data}");

    return (response.data);
  }

//********* Login **********//
  Future<LoginResponseModel> loginSevices(
      LoginRequestModel loginRequestModel) async {
    log(" login ,...  ${loginRequestModel.toJson()}");

    dio.options.headers['content-type'] = "application/json";
    dio.options.headers['accept-language'] =
        UserSession.getLng(UserSession.keyLocalLng);
    final response = await dio.post(loginUrlEndpoint, data: loginRequestModel);

    log(" login ,...  ${response.data}");

    return LoginResponseModel.fromJson(response.data);
  }

  //********* Social login **********//
  Future<ResponseModelVerifyOtp> socialLoginSevices(var data) async {
    dio.options.headers['accept-language'] =
        UserSession.getLng(UserSession.keyLocalLng);
    final response = await dio.post(SocialLoginUrlEndpoint, data: data);

    print("response..  $response");
    return ResponseModelVerifyOtp.fromJson(response.data);
  }

  //********* Social mobile update **********//
  Future<LoginResponseModel> socialMobileUpdateService(
      var data, String socialToken) async {
    dio.options.headers['authorization'] = "bearer $socialToken";

    dio.options.headers['accept-language'] =
        UserSession.getLng(UserSession.keyLocalLng);
    final response = await dio.post(SocialMobileUpdateUrlEndpoint, data: data);

    print("response..  $response");
    return LoginResponseModel.fromJson(response.data);
  }

// //************* Resend otp **********//
  Future<ResendOtpResponse> resendOtpRequest() async {
    dio.options.headers['authorization'] =
        "bearer ${Get.arguments['tempToken']}";

    dio.options.headers['accept-language'] =
        UserSession.getLng(UserSession.keyLocalLng);
    final response = await dio.post(resendOtpUrlEndpoint, data: {});
    log(response.statusCode.toString());
    return ResendOtpResponse.fromJson(response.data);
  }

// //******** verify otp *************//
  Future<ResponseModelVerifyOtp> verifyOtp(Map<String, String> map) async {
    print("get.argumnet ${map['country'].toString()}");
    print("get.argumnet ${map['otp'].toString()}");
    // print("get.argumnet ${model..toString()}");
    // return;
    dio.options.headers['authorization'] =
        "bearer ${Get.arguments['tempToken']}";

    dio.options.headers['accept-language'] =
        UserSession.getLng(UserSession.keyLocalLng);
    final response = await dio.post(verifyOptUrlEndpoint, data: map);
    print(" verifyOtp...   $response");
    return ResponseModelVerifyOtp.fromJson(response.data);
  }

  //************** update profile *****************//
  Future<UpdateProfileResponseModel> updateProfileCall(
      UpdateProfileRequestModel updateProfileRequestModel) async {
    dio.options.headers['content-type'] = "application/json";
    dio.options.headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    dio.options.headers['accept-language'] =
        UserSession.getLng(UserSession.keyLocalLng);
    print("");
    final response =
        await dio.post(updateProfileEndPoint, data: updateProfileRequestModel);
    return UpdateProfileResponseModel.fromJson(response.data);
  }

  // //************** upload Media *****************//
  // Future<MediaUpload> uploadMedia(File media) async {
  //   print("usertoken,..uploadMedia     " + userToken.toString());
  //   dio.options.headers['authorization'] = "bearer $userToken";
  //   print("response...  ");
  //   final response = await dio.post(AppConstents.baseUrl + driverMedia,
  //       data: http.MultipartFile.fromPath("media", media.path));
  //   print("response...  " + response.toString());
  //   return MediaUpload.fromJson(response.data);
  // }

  //************** upload Document *****************//
  Future documentUpload(var body) async {
    Map<String, String> headers = {
      "authorization":
          "Bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}"
    };
    final response = await dio.post(driverDocument,
        data: body, options: Options(headers: headers));

    return response;
  }

  //************** upload Document *****************//
  Future documentList() async {
    print("userToken.. userToken ${{
      UserSession.getStringFromSession(UserSession.keyUserToken)
    }}");
    Map<String, String> headers = {
      "authorization":
          "Bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}"
    };
    final response =
        await dio.get(driverDocumentList, options: Options(headers: headers));
    print(" list..  $response");
    return response;
  }

  Future docupload() async {
    print("userToken.. userToken ${{
      UserSession.getStringFromSession(UserSession.keyUserToken)
    }}");
    Map<String, String> headers = {
      "authorization":
          "Bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}"
    };
    final response =
        await dio.get(driverDocUpload, options: Options(headers: headers));
    print(" doc uploadd..  $response");
    return response;
  }

  //************** upload Document *****************//
  Future documentEdit(var body) async {
    print("userToken.. userToken ${{
      UserSession.getStringFromSession(UserSession.keyUserToken)
    }}");
    Map<String, String> headers = {
      "authorization":
          "Bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}"
    };
    final response = await dio.post(driverDocumentEdit,
        data: body, options: Options(headers: headers));
    print(" list..  $response");
    return response;
  }

  //************** update profile pic *****************/

  Future<Map<String, dynamic>> udateProfilePick(file, filename) async {
    var headers = <String, String>{};
    headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    print("update image,..ii ");
    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConstents.baseUrl + driverImageUpload));
    print("reuest..   " + request.toString());
    request.files.add(await http.MultipartFile.fromPath('image', file));
    request.headers.addAll(headers);
    print("reuest..   " + request.toString());
    http.StreamedResponse response = await request.send();
    print("reuest.. response  " + response.toString());
    var responseData = await response.stream.bytesToString();
    print("reuest.. responseData  " + responseData.toString());
    final responseJson = jsonDecode(responseData);
    print("reuest.. responseJson  " + responseJson.toString());
    return responseJson;
  }

  //************ Security Deposit ***********//

  Future<Map<String, dynamic>> securityDeposit(Map map) async {
    Map<String, String> headers = {
      "authorization":
          "Bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}"
    };
    print(
        "...   updateSecurityDeposit userToken ..   ${UserSession.getStringFromSession(UserSession.keyUserToken)}");
    final response = await dio.post("driver/security-deposit",
        data: map, options: Options(headers: headers));
    log("acceptScheduleRide..   $response");

    return response.data;
  }

  //************** update langugae *****************/

  Future<Map<String, dynamic>> updateLanguage(String locale) async {
    Map<String, String> headers = {
      "authorization":
          "Bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}"
    };
    Map map = {"language_id": locale};
    final response = await dio.post(updateLanguageEndPoint,
        data: map, options: Options(headers: headers));
    log("update language...   $response");

    return response.data;
  }

//************* get driver Profile **************//
  Future<GetProfileResponseModel> getProfileCall() async {
    print("user token on profile .. ${{
      UserSession.getStringFromSession(UserSession.keyUserToken)
    }}");
    dio.options.headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    final response = await dio.get(
      getProfileUrlEndPoint,
    );
    print("response get profile..  ${response.data}");
    return GetProfileResponseModel.fromJson(response.data);
  }

//************ driver status manage ***********//

  Future<DriverStatusResponseModel> driverStatus(Map map) async {
    print("driver status..   ${map.toString()}");
    dio.options.headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";

    final response = await dio.post(deiverStatusEndPoint, data: map);
    log("::::::::::::::>>>>>>>>>>>>>> response data${response.data}");

    return DriverStatusResponseModel.fromJson(response.data);
  }

  //************ Booking status manage ***********//

  bookingStatus() async {
    dio.options.headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    print("booking status..api  ");
    final response = await dio.get(driverBookingStatus);
    log("::::::::::::::>>>>>>>>>>>>>> response data${response.data}");
    Map<String, dynamic> data = json.decode(response.data);
    log("::::::::::::::>>>>>>>>>>>>>> response data$data");
    return data;
  }

  //************ List of schedule ride ***********//

  Future<MyTripResponseModel> getScheduleRide(
      MyTripRequestModel requestModel) async {
    dio.options.headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    dio.options.headers['Content-Type'] = "application/json";
    print("booking getScheduleRide..api .. ${requestModel.toJson()}");
    final response =
        await dio.post(scheduleRideList, data: requestModel.toJson());
    log("::::::::::::::>>>>>>>>>>>>>> response getScheduleRide  ${response.data}");
    // Map<String, dynamic> data = json.decode(response.data.toString());
    //log("::::::::::::::>>>>>>>>>>>>>> getScheduleRide response data" +
    //   data.toString());
    return MyTripResponseModel.fromJson(response.data);
  }

  //************ Accept schedule ride ***********//

  Future<Map<String, dynamic>> acceptScheduleRide(String id) async {
    Map<String, String> headers = {
      "authorization":
          "Bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}"
    };
    Map map = {"booking_id": id};
    final response = await dio.post(acceptScheduleRideEndpoint,
        data: map, options: Options(headers: headers));
    log("acceptScheduleRide..   $response");

    return response.data;
  }

  //************ Cancel schedule ride ***********//

  Future<Map<String, dynamic>> cancelScheduleRide(String id) async {
    Map<String, String> headers = {
      "authorization":
          "Bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}"
    };
    Map map = {"booking_id": id};
    final response = await dio.post(cancelScheduleRideEndpoint,
        data: map, options: Options(headers: headers));
    log("cancelScheduleRideEndpoint..   $response");

    return response.data;
  }

//*************** Wallet History List *******************/
  Future<WalletModel> getWalletHistory(
      var record, var page, var userTokenGet) async {
    var headers = <String, String>{};
    headers['authorization'] = "bearer $userTokenGet";
    final response = await dio.get('driver/wallet?page=$page&recode=$record',
        options: Options(headers: headers));

    Get.log(response.data.toString());
    return WalletModel.fromJson(response.data ?? []);
  }

  //*************** Wallet Amt Request *******************/
  FutureOr<Map<String, dynamic>> sendAmtRequest(var map) async {
    print(" map sendAmtRequest $map");
    var headers = <String, String>{};
    headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    final response = await dio.post("driver/wallet-request",
        data: map, options: Options(headers: headers));
    Get.log(response.data.toString());
    return response.data;
  }

  //************************  Booking Action  */

  Future<Map<String, dynamic>> actionOnBooking(Map map) async {
    Map<String, String> headers = {
      "authorization":
          "Bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}"
    };

    final response = await dio.post("driver/bookingAction",
        data: map, options: Options(headers: headers));

    log("actionOnBooking..   $response");

    return response.data;
  }

  //*************** MyTrip list *******************/
  Future<MyTripResponseModel> getMYTripList(
      MyTripRequestModel myTripRequestModel, userTokenGet) async {
    // Get.log(AppConstents.baseUrl.toString() + myTripUserEndPoint.toString());
    // Get.log("userTokenGet in api $userTokenGet");
    // Get.log(
    //     "log(myTripRequestModel.toJson().toString());${myTripRequestModel.toJson()}");
    // Get.log("userTokenGet $userTokenGet");

    var headers = <String, String>{};
    headers['authorization'] = "bearer $userTokenGet";
    final response = await dio.post(myTripUserEndPoint,
        data: myTripRequestModel.toJson(), options: Options(headers: headers));
    Get.log(response.data.toString());
    return MyTripResponseModel.fromJson(response.data);
  }

  //****************** my trip details *****************/
  Future<MyTRipDetailREsponseModel> getMytripDetailsREsponse(String id) async {
    var headers = <String, String>{};
    headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    final response = await dio.get(myTripDetailsEndPint + id,
        options: Options(headers: headers));
    return MyTRipDetailREsponseModel.fromJson(response.data);
  }

  //*************** TransactionHistory *******************/
  Future<TransactionHistoryResponseModel> getMYtripTransactionHistory() async {
    var headers = <String, String>{};
    headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    final response = await dio.get(myTripTransactionHistoryEndPoint,
        options: Options(headers: headers));
    print(" payment summary ${response.data}");
    return TransactionHistoryResponseModel.fromJson(response.data);
  }

  //*************** ChatHistory *******************/
  Future<Map<String, dynamic>> getChatHistoryList(String bookingId) async {
    dio.options.headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";

    final response = await dio.post(
      ChatHistory,
      data: {"booking_id": bookingId},
    );

    Get.log(response.data.toString());
    return response.data;
  }

  Future<Map<String, dynamic>> updateChatmedia(file) async {
    var headers = <String, String>{};
    headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConstents.baseUrl + ChatMediaUpload));
    request.files.add(await http.MultipartFile.fromPath('media', file));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    log("response..  $response");
    var responseData = await response.stream.bytesToString();
    final responseJson = jsonDecode(responseData);
    return responseJson;
  }

  Future<Map<String, dynamic>> uploadDriverMedia(var file, String type) async {
    var headers = <String, String>{};
    headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    print("response..uploadDriverMedia  ");
    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConstents.baseUrl + driverMedia));
    if (type == "multiple") {
      for (int i = 0; i < file.length; i++) {
        print("file[i].path.toString()..  ${file[i].path}");
        request.files.add(await http.MultipartFile.fromPath(
            'media', file[i].path.toString()));
      }
    } else {
      request.files.add(await http.MultipartFile.fromPath('media', file));
    }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    var responseData = await response.stream.bytesToString();
    print("response..  $responseData");
    final responseJson = await jsonDecode(responseData);
    print("response..request  $responseJson");
    return responseJson;
  }

  Future<Map<String, dynamic>> mpesaDetail() async {
    var headers = <String, String>{};
    headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    final response = await dio.get(
      "mpesaInfo",
      options: Options(headers: headers),
    );
    log("mpesaDetail..   $response");

    return response.data;
  }

  Future<Map<String, dynamic>> openPayDetail() async {
    var headers = <String, String>{};
    headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    final response = await dio.get(
      AppConstents.baseUrl + "payment-gateway",
      options: Options(headers: headers),
    );
    log("mpesaDetail..   " + response.toString());

    return response.data;
  }

  Future<Map<String, dynamic>> deleteApi() async {
    dio.options.headers['accept-language'] =
        "${UserSession.getLng(UserSession.keyLocalLng)} ";
    dio.options.headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    final response = await dio.get(
      deleteEndPoint,
    );
    print("deleteApi..   $response");

    return response.data;
  }

  Future<Map<String, dynamic>> logoutApi() async {
    var headers = <String, String>{};
    headers['authorization'] =
        "bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}";
    final response = await dio.get(
      logoutEndPoint,
      options: Options(headers: headers),
    );
    log("logoutApi..   $response");

    return response.data;
  }
}

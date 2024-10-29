import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:madr_driver/design/settings/controller/profile_controller.dart';
import 'package:madr_driver/utils/location.dart';

import '../../../services/api_sevices.dart';
import '../../../utils/toast.dart';
import '../../../utils/user_session.dart';
import '../../dashboard/controller/home_controller.dart';
import '../model/my_trip_response_model.dart';

class MyTripController extends GetxController {
  var isLoading = false.obs;
  var isCancelLoading = false.obs;
  RxBool isStartLoading = false.obs;
  MyTripResponseModel? myTripResponseModel;
  NetworkServices networkServices = NetworkServices();
  RxInt page = 1.obs;
  RxInt record = 6.obs;
  var tripType = 0.obs;
  RxList<BookingList> tripList = <BookingList>[].obs;
  HomeController homeController = HomeController();
  var profileController = Get.find<ProfileController>();

  actionOnCurrentBooking(String? sId, String status) async {
    log("actionOnCurrentBooking..   $sId  $status");
    try {
      final response = await networkServices
          .actionOnBooking({"booking_id": sId, "status": status});

      if (response["ResponseCode"] == 200) {
        isStartLoading.value = false;

        await Location.locationPermission();

        await homeController.BookingStatusThroughFirebase(isLoading.value);
      } else {
        isStartLoading.value = false;
        showFlutterToast(message: response['ResponseMessage'].toString());
      }
    } catch (e) {
      isStartLoading.value = false;
      showFlutterToast(message: e.toString());
      log(e.toString());
    }
  }

  Future<void> doMytripGetAllRequest(userTokenGet) async {
    update();

    try {
      final response = await networkServices.getMYTripList(
          MyTripRequestModel(
              recode: record.toString(),
              page: page.toString(),
              rideType: tripType.toString()),
          userTokenGet);

      if (response.responseCode == 200) {
        myTripResponseModel = response;
        update();
      } else {
        myTripResponseModel = response;
        update();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<BookingList>> fecthTripList() async {
    return tripList;
  }

  getTripList() async {
    var response = await networkServices.getMYTripList(
        MyTripRequestModel(
          recode: record.toString(),
          page: page.toString(),
        ),
        "${UserSession.getStringFromSession(UserSession.keyUserToken)}");

    log("reeepooo.. $record   $page    $tripType");
    log("reeepooo.. $response");
    try {
      if (response.responseCode == 200) {
        var rest = json.encode(response.responseBody!.bookingList);
        print("reeepooo.rest. rest  $rest");
        var restdecode = json.decode(rest);

        if (page.value == 1) {
          if (restdecode.length > 0) {
            print("reeepooo..rest $restdecode");

            tripList.addAll(await restdecode
                .map<BookingList>((json) => BookingList.fromJson(json))
                .toList());
            update();

            log("  tripList..rest $tripList");

            isLoading.value = false;
          } else {
            print("reeepooo..rest $restdecode");
            isLoading.value = false;
            tripList.value = [];
          }
        } else {
          if (restdecode.length > 0) {
            tripList.addAll(await restdecode
                .map<BookingList>((json) => BookingList.fromJson(json))
                .toList());
            update();
            log("  tripList..rest  isLoading... $tripList");
            isLoading.value = false;
            log("  tripList..rest  isLoading.... $tripList");
          }
        }
      } else {
        print('<<<<<<<<<<<<LotteryApp>>>>>>>>>$response');
        showFlutterToast(message: response.responseMessage.toString());
        isLoading.value = false;
      }
      update();
    } catch (e) {
      print(" exceppp...    " + e.toString());
      isLoading.value = false;
    }

    // return await tripList.value;
  }

  cancelRide(String bookingId, int index) async {
    var response = await networkServices.cancelScheduleRide(bookingId);
    log("reeepooo.. cancelRide   $response");

    try {
      if (response['ResponseCode'] == 200) {
        log("reeepooo..rest  cancelRide  $response");
        tripList.removeAt(index);
        update();
        showFlutterToast(message: response['ResponseMessage'].toString());
        isCancelLoading.value = false;
      } else {
        print('<<<<<<<<<<<<LotteryApp>>>>>>>>>$response');
        showFlutterToast(message: response['ResponseMessage'].toString());
        isCancelLoading.value = false;
      }
    } catch (e) {
      print(" ... cancelRide ..... $e");
      isCancelLoading.value = false;
    }
  }
}

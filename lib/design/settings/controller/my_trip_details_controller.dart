import 'dart:convert';
import 'package:get/get.dart';
import '../../../services/api_sevices.dart';
import '../model/my_trip_details_response_model.dart';

class MyTripDetailsController extends GetxController {
  var isloading = true.obs;
  var isRating = false.obs;
  var isUpdatingRating = false.obs;

  NetworkServices networkServices = NetworkServices();
  Rxn<BookingDetail?> tripDetail = Rxn();

  getDetailsRequest(id) async {
    try {
      final response = await networkServices.getMytripDetailsREsponse(id);
      print(
          "trip detail...   ${response.responseBody!.bookingDetail!.toJson()}");
      if (response.responseCode == 200) {
        var rest = json.encode(response.responseBody!.bookingDetail);
        var restdecode = json.decode(rest);
        print("trip detail...11   $response");
        tripDetail.value = BookingDetail.fromJson(restdecode);

        print(
            ">>>>>>>>>>>>::::::::::::::::>>>>>>>>>>>>>>>${response.toJson().toString()}");
        isloading.value = false;
        isUpdatingRating.value = false;

        return tripDetail.value;
      } else {
        tripDetail.value = null;
        isloading.value = false;
        isUpdatingRating.value = false;

        return tripDetail.value;
      }
    } catch (e) {
      print(" tripe details...   $e");
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:madr_driver/design/dashboard/controller/accept_ride_controller.dart';
import 'package:madr_driver/design/dashboard/model/booking_info.dart';
import 'package:madr_driver/design/dashboard/model/waiting_booking_list.dart';
import 'package:madr_driver/services/api_sevices.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/user_session.dart';
import '../../settings/model/my_trip_response_model.dart';
import '../../splash_screen.dart';
import '../design/accept_ride.dart';
import '../../../socket_connection/socket_connection.dart';
import '../model/driver_status_model.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var isScheduleLoading = false.obs;
  RxBool isLeadVisible = false.obs;
  RxBool isSchedule = false.obs;
  var dataFecthingLoader = false.obs;
  var enable = false.obs;
  var scheduleCount = 0.obs;
  var page = 1;
  var record = 8;
  RxList<BookingInfoList> waitingList = <BookingInfoList>[].obs;

  NetworkServices networkServices = NetworkServices();
  DriverStatusResponseModel? driverStatusResponseModel;

  RxList<BookingList> scheduleRideList = <BookingList>[].obs;
  Rxn<ScrollController> dragController = Rxn();
  RxDouble maxDragSize = 0.4.obs;
  RxDouble initialDragSize = 0.3.obs;
  Rxn<LocationData?> updateloc = Rxn();

  late GoogleMapController homeMapController;
  final double minLocationAccuracy = 20.0;
  Rxn<BitmapDescriptor?> markerIcon = Rxn();
  StreamSubscription<Position>? locationSubscription;

  // var mapController = Get.find<AppMapController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("homeController init");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print(" homeprint..  home controller dispose..  ");
  }

  void onMapCreated(GoogleMapController controller) async {
    print(" homeprint.. home controller  map initialize..  ");
    homeMapController = controller;
  }

  void addCustomIcon() {
    print(" homeprint.. home controller marker..  ");
    getBytesFromAsset('assets/images/ic_car_track.png').then((icon) {
      markerIcon.value = BitmapDescriptor.fromBytes(icon);
    });
    // BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(2, 2)),
    //         "assets/images/ic_car_track.png")
    //     .then(
    //   (icon) {
    //     markerIcon.value = icon;

    //   },
    // );
  }

  Future<Uint8List> getBytesFromAsset(String path) async {
    double pixelRatio = MediaQuery.of(Get.key.currentContext!).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: pixelRatio.round() * 28);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // setIcon(String s) async {
  //   final Uint8List markerIcon = await getBytesFromAsset(s, 65);
  //   print("add way marker ...  marker icon..  " + markerIcon.toString());
  //   icons.value = BitmapDescriptor.fromBytes(markerIcon);
  //   print("add way marker ...  icons.value..  " + icons.value.toString());
  // }

  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   print("add way marker ...  data..  " + data.toString());
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //       targetWidth: width);
  //   print("add way marker ...  codec..  " + codec.toString());
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   print("add way marker ...  fi..  " + fi.toString());
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //       .buffer
  //       .asUint8List();
  // }

  getCurrentLocation() async {
    print("current location..   ");
    // Location location = Location();
    try {
      Permission.notification.request();
      Position location = await Geolocator.getCurrentPosition();
      print("position... getCurrentLocation  home dispose " +
          location.toString());
      // Create a LocationData object from the Position data
      LocationData locationData = LocationData.fromMap({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'accuracy': location.accuracy,
        'heading': location.heading
        // Add other necessary properties if available
      });
      print("position... getCurrentLocationIOS locationData home dispose  " +
          locationData.toString());
      updateloc.value = locationData;
      UserSession.setDoubleInSession(
          UserSession.keyCurrentLat, locationData.latitude!.toDouble());
      UserSession.setDoubleInSession(
          UserSession.keyCurrentLng, locationData.longitude!.toDouble());

      SocketConnection.sendMessage("driveCurrentLocationUpdate", {
        'longitude': location.longitude.toString(),
        'latitude': location.latitude.toString(),
      });
      fetchCurrentLocation();
    } catch (e) {
      showFlutterToast(message: "loc err.. " + e.toString());
    }

    locationSubscription =
        Geolocator.getPositionStream().listen((Position loc) async {
      // location.onLocationChanged.listen(
      // (newLoc) async {
      print(
          "  .distanceBetweenPoints  newLoc.accuracy!..11 home dispose  ${loc.altitude}");
      try {
        // showFlutterToast(
        //     message: "accuracy ..    " + newLoc.accuracy.toString());
        if (loc.accuracy <= minLocationAccuracy) {
          LocationData newLoc = LocationData.fromMap({
            'latitude': loc.latitude,
            'longitude': loc.longitude,
            'accuracy': loc.accuracy,
            'heading': loc.heading
            // Add other necessary properties if available
          });
          print(
              "  .distanceBetweenPoints  newLoc.accuracy!.. home dispose  ${newLoc.accuracy!}");
          print("current loca.. onchange..  home contr  $newLoc");
          updateloc.value = newLoc;
          UserSession.setDoubleInSession(
              UserSession.keyCurrentLat, newLoc.latitude!.toDouble());
          UserSession.setDoubleInSession(
              UserSession.keyCurrentLng, newLoc.longitude!.toDouble());
          fetchCurrentLocation();

          SocketConnection.sendMessage("driveCurrentLocationUpdate", {
            'longitude': newLoc.longitude.toString(),
            'latitude': newLoc.latitude.toString(),
          });
        }
      } catch (e) {}
    });
  }

  fetchCurrentLocation() async {
    updateloc.value == null ? await getCurrentLocation() : "";
    homeMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(updateloc.value!.latitude!,
              updateloc.value!.longitude!), // Update with your current location
          zoom: 19,
        ),
      ),
    );

    // print("way location..  " + mapController.wayLocation.value.toString());
    // if (mapController.wayLocation.value == null) {
    //   mapController.fetchLocation().then((value) {
    //     mapController.addWayMarkerAnimated(
    //         mapController.updateloc.value!,
    //         "wayLocation",
    //         BitmapDescriptor.defaultMarker,
    //         "assets/images/ic_car_track.png");
    //   });
    // } else {
    //   mapController.addWayMarkerAnimated(
    //       mapController.wayLocation.value!,
    //       "wayLocation",
    //       BitmapDescriptor.defaultMarker,
    //       "assets/images/ic_car_track.png");
    // }
  }

  updateNewRequest(restdecode) {
    print("updateNewRequest..   $restdecode");
    print(
        "vvv..   ${!waitingList.any((element) => element.bookingId == restdecode['booking_id'])}");
    if (!waitingList
        .any((element) => element.bookingId == restdecode['booking_id'])) {
      waitingList.add(BookingInfoList.fromJson(restdecode));

      isLeadVisible.value = true;
      update();
    } else {
      update();
    }
  }

  Future<void> currentBookingList() async {
    try {
      var response = await networkServices.waitingBookings();

      if (response.responseCode == 200) {
        waitingList.clear();
        waitingList.addAll(response.responseBody!.bookingInfoList!.toList());
        update();
        print("current booking ...   ${waitingList.length}");
        print("current booking ...   $waitingList");
        if (waitingList.isNotEmpty) {
          isLeadVisible.value = true;

          update();
        } else {
          isLeadVisible.value = false;
        }
      } else {
        //showFlutterToast(message: response.responseMessage.toString());
      }
    } catch (e) {
      // showFlutterToast(message: e.toString());
      print("currentBookingList..   $e");
    }
  }

  getScheduleRideList() async {
    var response = await networkServices.getScheduleRide(
        MyTripRequestModel(recode: record.toString(), page: page.toString()));
    log("reeepooo.. $response");
    try {
      if (response.responseCode == 200) {
        var rest = json.encode(response.responseBody!.bookingList);
        var restdecode = json.decode(rest);
        if (page == 1) {
          if (restdecode.length > 0) {
            log("reeepooo..rest $restdecode");
            isLeadVisible.value = false;
            isSchedule.value = true;
            scheduleRideList.value = [];

            scheduleRideList.addAll(await restdecode
                .map<BookingList>((json) => BookingList.fromJson(json))
                .toList());
          } else {
            showFlutterToast(message: AppConstents().NoBooking);
          }
        } else {
          if (restdecode.length > 0) {
            scheduleRideList.addAll(await restdecode
                .map<BookingList>((json) => BookingList.fromJson(json))
                .toList());
          }
        }
        //  var rest = dataObj["common_specialities"];

        isLoading.value = false;
        isScheduleLoading.value = false;
      } else {
        print('<<<<<<<<<<<<LotteryApp>>>>>>>>>$response');
        showFlutterToast(message: response.responseMessage.toString());
        isLoading.value = false;
        isScheduleLoading.value = false;
      }
    } catch (e) {
      print(e);
      isLoading.value = false;
      isScheduleLoading.value = false;
    }
  }

  acceptRide(String bookingId, int index) async {
    isLoading.value = true;
    var response = await networkServices.acceptScheduleRide(bookingId);
    log("reeepooo.. acceptRide   $response");

    try {
      if (response['ResponseCode'] == 200) {
        log("reeepooo..rest $response");
        scheduleRideList.removeAt(index);

        log("reeepooo..rest $scheduleRideList");
        if (scheduleRideList.length <= 0) {
          isLeadVisible.value = false;
          isSchedule.value = false;
        }

        SocketConnection.sendMessage("getScheduledRideCount", {});
        showFlutterToast(message: response['ResponseMessage'].toString());
        isLoading.value = false;
      } else {
        print('<<<<<<<<<<<<LotteryApp>>>>>>>>>$response');
        showFlutterToast(message: response['ResponseMessage'].toString());
        isLoading.value = false;
      }
    } catch (e) {
      print(" ... acceptRide ..... $e");
      isLoading.value = false;
    }
  }

  cancelRide(String bookingId, int index) async {
    isLoading.value = true;
    var response = await networkServices.cancelScheduleRide(bookingId);
    log("reeepooo.. cancelRide   $response");

    try {
      if (response['ResponseCode'] == 200) {
        log("reeepooo..rest  cancelRide  $response");
        scheduleRideList.removeAt(index);

        log("reeepooo..rest  cancelRide  $scheduleRideList");
        if (scheduleRideList.length <= 0) {
          isLeadVisible.value = false;
          isSchedule.value = false;
        }

        isLoading.value = false;
      } else {
        print('<<<<<<<<<<<<LotteryApp>>>>>>>>>$response');
        showFlutterToast(message: response['ResponseCode'].toString());
        isLoading.value = false;
      }
    } catch (e) {
      print(" ... cancelRide ..... $e");
      isLoading.value = false;
    }
  }

  driverStatusUpdateRequest() async {
    log(enable.toString());
    isLoading(true);

    try {
      final response = await networkServices
          .driverStatus({"online_status": enable.isTrue ? "1" : "0"});

      if (response.responseCode == 200) {
        isLoading(false);

        showFlutterToast(message: response.responseMessage.toString());
      } else {
        isLoading(false);
        showFlutterToast(message: response.responseMessage.toString());
      }
    } on Exception {
      isLoading(false);
    } catch (e) {
      isLoading(false);

      showFlutterToast(message: e.toString());
      log(e.toString());
    }
  }

  Future<void> BookingStatus() async {
    print(
        "booking status..  ${UserSession.getStringFromSession(UserSession.keyUserToken)}");
    try {
      final response = await networkServices.bookingStatusMethod();
      final jsonData = jsonDecode(response);
      print("booking status.. response..   ");
      print("booking status..  $jsonData");
      print("booking status..  ${jsonData['succeeded']}");

      if (jsonData['ResponseCode'] == 200) {
        await SocketConnection.connectToServer();
        print("booking status..  " + jsonData['ResponseMessage']);

        BookingInfo bookingInfoList =
            BookingInfo.fromJson(jsonData['ResponseBody']);
        print(" jsonData['ResponseBody']");

        print(" jsonData['ResponseBody']");

        UserSession.setStringInSession(UserSession.currencyCode,
            jsonData['ResponseBody']['currency_code'].toString());
        UserSession.setStringInSession(UserSession.currencyPosition,
            jsonData['ResponseBody']['currency_position'].toString());
        UserSession.setStringInSession(UserSession.currencySymbol,
            jsonData['ResponseBody']['currency_symbol'].toString());
        UserSession.setStringInSession(
            UserSession.tax, jsonData['ResponseBody']['tax'].toString());
        UserSession.setStringInSession(UserSession.nightTimeStart,
            jsonData['ResponseBody']['night_time_start'].toString());
        UserSession.setStringInSession(UserSession.nightTimeEnd,
            jsonData['ResponseBody']['night_time_end'].toString());

        if (jsonData['ResponseBody']['bookingData']['status'] == 1) {
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus,
              jsonData['ResponseBody']['bookingData']['status']);
          if (Get.currentRoute != "AcceptRideScreen") {
            Get.offAllNamed("AcceptRideScreen", arguments: bookingInfoList);
          }
        } else if (jsonData['ResponseBody']['bookingData']['status'] == 2) {
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus,
              jsonData['ResponseBody']['bookingData']['status']);
          if (Get.currentRoute != "AcceptRideScreen") {
            Get.offAllNamed("AcceptRideScreen", arguments: bookingInfoList);
          }
        } else if (jsonData['ResponseBody']['bookingData']['status'] == 3) {
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus,
              jsonData['ResponseBody']['bookingData']['status']);
          if (Get.currentRoute != "AcceptRideScreen") {
            Get.offAllNamed("AcceptRideScreen", arguments: bookingInfoList);
          }
        }
      } else {
        await SocketConnection.connectToServer();
        UserSession.setIntInSession(UserSession.keyCurrentBookingStatus, 0);
        print("Get.currentRoute..    " + Get.currentRoute);
        // if (Get.currentRoute == "/") {
        //   Get.offAndToNamed(SplashScreen.routeName);
        // } else
        if (Get.currentRoute != "HomeScreen") {
          Get.offAllNamed("HomeScreen");
        }
      }
    } catch (e) {
      print("booking status exception..  $e");
      isLoading(false);
    }
  }

  Future<void> ServerBookingStatus() async {
    print(
        "booking status..  ${UserSession.getStringFromSession(UserSession.keyUserToken)}");
    try {
      final response = await networkServices.bookingStatusMethod();
      final jsonData = jsonDecode(response);
      print("booking status.. response..   ");
      print("booking status..  $jsonData");
      print("booking status..  ${jsonData['succeeded']}");

      if (jsonData['ResponseCode'] == 200) {
        await SocketConnection.connectToServer();
        print("booking status..  " + jsonData['ResponseMessage']);
        print(
            "booking status..  ${jsonData['ResponseBody']['bookingData']['status']}");
        // var rest = json.encode(jsonData['ResponseBody']);
        // var restDecode = json.decode(rest);
        print(" jsonData['ResponseBody']11");
        BookingInfo bookingInfoList =
            BookingInfo.fromJson(jsonData['ResponseBody']);
        print(" jsonData['ResponseBody']");

        print(" jsonData['ResponseBody']");

        UserSession.setStringInSession(UserSession.currencyCode,
            jsonData['ResponseBody']['currency_code'].toString());

        UserSession.setStringInSession(UserSession.currencyPosition,
            jsonData['ResponseBody']['currency_position'].toString());

        UserSession.setStringInSession(UserSession.currencySymbol,
            jsonData['ResponseBody']['currency_symbol'].toString());

        UserSession.setStringInSession(
            UserSession.tax, jsonData['ResponseBody']['tax'].toString());

        UserSession.setStringInSession(UserSession.nightTimeStart,
            jsonData['ResponseBody']['night_time_start'].toString());

        UserSession.setStringInSession(UserSession.nightTimeEnd,
            jsonData['ResponseBody']['night_time_end'].toString());

        print(" jsonData['ResponseBody']  if");

        if (jsonData['ResponseBody']['bookingData']['status'] == 1) {
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus,
              jsonData['ResponseBody']['bookingData']['status']);
          if (Get.currentRoute != "AcceptRideScreen") {
            Get.offAllNamed("AcceptRideScreen", arguments: bookingInfoList);
          }
          var controller = Get.find<AcceptRideController>();
          controller.rideStatus.value = 0;
        } else if (jsonData['ResponseBody']['bookingData']['status'] == 2) {
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus,
              jsonData['ResponseBody']['bookingData']['status']);
          if (Get.currentRoute != "AcceptRideScreen") {
            Get.offAllNamed("AcceptRideScreen", arguments: bookingInfoList);
          }
          var controller = Get.find<AcceptRideController>();
          controller.rideStatus.value = 2;
        } else if (jsonData['ResponseBody']['bookingData']['status'] == 3) {
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus,
              jsonData['ResponseBody']['bookingData']['status']);
          if (Get.currentRoute != "AcceptRideScreen") {
            Get.offAllNamed("AcceptRideScreen", arguments: bookingInfoList);
          }
          var controller = Get.find<AcceptRideController>();
          controller.rideStatus.value = 3;
        }
        Get.back();
      } else {
        print("Get.currentRoute..    " + Get.currentRoute);
        if (Get.currentRoute == "/") {
          Get.offAllNamed(SplashScreen.routeName);
        } else if (Get.currentRoute != "HomeScreen") {
          Get.offAllNamed("HomeScreen");
        } else if (Get.currentRoute == "HomeScreen") {
          await SocketConnection.connectToServer();
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus, 0);
          Get.back();
        }
      }
    } catch (e) {
      print("booking status exception..  $e");
      isLoading(false);
    }
  }

  Future<void> BookingStatusThroughFirebase(bool isLoading) async {
    try {
      final response = await await networkServices.bookingStatusMethod();
      print("booking status.. response..   $response");
      final jsonData = jsonDecode(response);
      print("booking status.. response..   ");
      print("booking status..  $jsonData");
      print("booking status..  ${jsonData['succeeded']}");

      if (jsonData['ResponseCode'] == 200) {
        print("booking status..  ${jsonData['ResponseMessage']}");
        print(
            "booking status..  ${jsonData['ResponseBody']['bookingData']['status']}");
        await SocketConnection.connectToServer();

        UserSession.setStringInSession(UserSession.currencyCode,
            jsonData['ResponseBody']['currency_code'].toString());
        UserSession.setStringInSession(UserSession.currencyPosition,
            jsonData['ResponseBody']['currency_position'].toString());
        UserSession.setStringInSession(UserSession.currencySymbol,
            jsonData['ResponseBody']['currency_symbol'].toString());
        UserSession.setStringInSession(
            UserSession.tax, jsonData['ResponseBody']['tax'].toString());
        UserSession.setStringInSession(UserSession.nightTimeStart,
            jsonData['ResponseBody']['night_time_start'].toString());
        UserSession.setStringInSession(UserSession.nightTimeEnd,
            jsonData['ResponseBody']['night_time_end'].toString());

        print("booking status int....  ");
        BookingInfo bookingInfoList =
            BookingInfo.fromJson(jsonData['ResponseBody']);
        print("booking status int....  ");
        if (jsonData['ResponseBody']['bookingData']['status'] == 1) {
          print("booking status int....  ");
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus,
              jsonData['ResponseBody']['bookingData']['status']);
          print("booking status int....  ");
          Get.offAllNamed("AcceptRideScreen", arguments: bookingInfoList);
        } else if (jsonData['ResponseBody']['bookingData']['status'] == 2) {
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus,
              jsonData['ResponseBody']['bookingData']['status']);
          Get.offAllNamed("AcceptRideScreen", arguments: bookingInfoList);
        } else if (jsonData['ResponseBody']['bookingData']['status'] == 3) {
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus,
              jsonData['ResponseBody']['bookingData']['status']);
          Get.offAllNamed(AcceptRideScreen.routeName,
              arguments: bookingInfoList);
        }
        isLoading = false;
      } else {
        await SocketConnection.connectToServer();
        isLoading = false;
        UserSession.setIntInSession(UserSession.keyCurrentBookingStatus, 0);
        Get.offAllNamed("HomeScreen");
      }
    } catch (e) {
      log("booking status exception..  $e");
      isLoading = false;
    }
  }
}

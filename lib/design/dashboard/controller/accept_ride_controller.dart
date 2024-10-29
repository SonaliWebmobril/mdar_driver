import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:madr_driver/constents/package_extend.dart';
import 'package:madr_driver/design/dashboard/design/map_widget/NetworkUtils.dart';
import 'package:madr_driver/design/dashboard/design/map_widget/PointLatLng.dart';
import 'package:madr_driver/design/dashboard/design/map_widget/PolygonUtil.dart';
import 'package:madr_driver/design/dashboard/design/map_widget/PolylinePoints.dart';
import 'package:madr_driver/design/dashboard/design/map_widget/PolylineResult.dart';
import 'package:madr_driver/design/dashboard/design/map_widget/SphericalUtil.dart';
import 'package:madr_driver/design/dashboard/model/booking_info.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/style.dart';
import '../../../utils/toast.dart';
import '../../../utils/user_session.dart';
import '../../../socket_connection/socket_connection.dart';

RxList<LatLng> multipleWayLocation = <LatLng>[].obs;

class AcceptRideController extends GetxController {
  DateTime? backBtnPressTime;
  TextEditingController otpController = TextEditingController();
  late BookingInfo data;
  RxDouble totalPrice = 0.0.obs;
  RxInt rideStatus = 0.obs;
  RxString cancelReasonTxt = ''.obs;
  RxString cancelReasonId = ''.obs;
  RxInt selectedtIndex = (-1).obs;
  RxInt chatCount = 0.obs;
  RxBool textFieldForReason = false.obs;
  Rx<TextEditingController> etCancelReason = TextEditingController().obs;
  Rx<FocusNode> etCancelFocusNode = FocusNode().obs;
  RxInt etReasonLength = 0.obs;
  RxInt waitUser = 0.obs;
  //var mapController = Get.find<AppMapController>();

  late GoogleMapController mapController;
  Rxn<LocationData?> currentLocation = Rxn();
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  RxMap<PolylineId, Polyline> polylines = <PolylineId, Polyline>{}.obs;
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  PolylinePoints polylinePoints = PolylinePoints();
  Rxn<LatLng?> startLocation = Rxn();
  RxDouble totalKm = 0.0.obs;
  num previousDistance = 0.1;
  Rxn<LatLng?> endLocation = Rxn();
  RxDouble currentBearing = 0.0.obs;
  Rxn<LatLng?> wayLocation = Rxn();
  Rxn<LatLng?> PreviousWayLocation = Rxn();
  Rxn<LatLng?> KmPreviousLocation = Rxn();
  Rxn<BitmapDescriptor?> icons = Rxn();
  bool isLOcationDenied = false;

  int count = 0;
  final double minLocationAccuracy = 20.0;
  StreamSubscription<Position>? locationSubscription;

  @override
  void onInit() {
    super.onInit();
    int currentStatus =
        UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus)!;
    print("accept ride..currentStatus..   " + currentStatus.toString());
    if (currentStatus == 0 || currentStatus == 1) {
      rideStatus.value = 0;
    } else if (currentStatus == 2) {
      rideStatus.value = 2;
    } else if (currentStatus == 3) {
      rideStatus.value = 3;
    }
  }

  void addCustomIcon() {
    print(" homeprint.. home controller marker..  ");
    getBytesFromAss('assets/images/ic_car_track.png').then((icon) {
      icons.value = BitmapDescriptor.fromBytes(icon);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print(" homeprint..  accept controller dispose..  ");
    locationSubscription?.cancel();
  }

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  Future<LocationData> fetchLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    print("position... getCurrentLocationIOS accept ride  dispose " +
        position.toString());
    // Create a LocationData object from the Position data
    LocationData locationData = LocationData.fromMap({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'accuracy': position.accuracy,
      'heading': position.heading
      // Add other necessary properties if available
    });
    print(
        "position... getCurrentLocationIOS locationData  accept ride  dispose " +
            locationData.toString());

    print("location...  " + position.toString());
    currentLocation.value = locationData;

    wayLocation.value =
        LatLng(position.latitude.toDouble(), position.longitude.toDouble());
    PreviousWayLocation.value =
        LatLng(position.latitude.toDouble(), position.longitude.toDouble());
    KmPreviousLocation.value =
        LatLng(position.latitude.toDouble(), position.longitude.toDouble());
    UserSession.setDoubleInSession(
        UserSession.keyCurrentLat, position.latitude);

    UserSession.setDoubleInSession(
        UserSession.keyCurrentLng, position.longitude);
    return locationData;

    // Location location = Location();

    // await location.getLocation().then((location) async {
    //   print("location...  " + location.toString());
    //   currentLocation.value = location;
    //   wayLocation.value =
    //       LatLng(location.latitude!.toDouble(), location.longitude!.toDouble());
    //   PreviousWayLocation.value =
    //       LatLng(location.latitude!.toDouble(), location.longitude!.toDouble());
    //   KmPreviousLocation.value =
    //       LatLng(location.latitude!.toDouble(), location.longitude!.toDouble());
    //   UserSession.setDoubleInSession(
    //       UserSession.keyCurrentLat, location.latitude!);

    //   UserSession.setDoubleInSession(
    //       UserSession.keyCurrentLng, location.longitude!);
    //   return location;
    // });
    // return location;
  }

  navigateToWaze() async {
    var latitudeUrl = startLocation.value!.latitude;
    var longitudeUrl = startLocation.value!.longitude;

    if (UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus) ==
        2) {
      latitudeUrl = endLocation.value!.latitude;
      longitudeUrl = endLocation.value!.longitude;
    }

    if (Platform.isAndroid) {
      try {
        final String wazeUrl =
            'waze://?q=${double.parse(latitudeUrl.toString())}, ${double.parse(longitudeUrl.toString())}&navigate=yes';
        await launchUrl(Uri.parse(wazeUrl),
            mode: LaunchMode.externalApplication);
      } catch (e) {
        print("exception...  " + e.toString());
        showFlutterToast(message: "App not installed");
      }
    } else {
      try {
        final String wazeUrl =
            'waze://?q=${double.parse(latitudeUrl.toString())}, ${double.parse(longitudeUrl.toString())}&navigate=yes';
        await launchUrl(Uri.parse(wazeUrl),
            mode: LaunchMode.externalApplication);
      } catch (e) {
        print("exception...  " + e.toString());
        showFlutterToast(message: "App not installed");
      }
    }
  }

  navigateToMap() async {
    var latitudeUrl = startLocation.value!.latitude;
    var longitudeUrl = startLocation.value!.longitude;

    if (UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus) ==
        2) {
      latitudeUrl = endLocation.value!.latitude;
      longitudeUrl = endLocation.value!.longitude;
    }

    if (Platform.isAndroid) {
      try {
        await launchUrl(
          Uri.parse(
              'http://maps.google.co.in/maps?q=${double.parse(latitudeUrl.toString())}, ${double.parse(longitudeUrl.toString())}'),
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        showFlutterToast(message: "App not installed");
      }
    } else {
      try {
        await launchUrl(
            Uri.parse(
                "https://maps.apple.com/?q=${double.parse(latitudeUrl.toString())}, ${double.parse(longitudeUrl.toString())}"),
            mode: LaunchMode.externalApplication);
      } catch (e) {
        showFlutterToast(message: "App not installed");
      }
    }
  }

  updateDestinationLocation() async {
    // destination marker
    addEndMarker(
        endLocation.value!, "destination", BitmapDescriptor.defaultMarker, "");
  }

  updateOriginLocation() async {
    print("update updateLocationOnAccept.. ");

    addStartMarker(startLocation.value!, "origin",
        BitmapDescriptor.defaultMarkerWithHue(80), "");
  }

  onRejectLead() async {
    print("update onRejectLead.. ");
    try {
      startLocation.value = null;
      endLocation.value = null;
      polylineCoordinates.value = [];
      polylines.clear();
      polylineCoordinates.clear();
      markers.clear();
      markers.value = {};
      locationSubscription!.cancel();
    } catch (e) {
      print("on reject exception ..   ${e.toString()}");
    }
  }

  int isNotify = 0;

  getCurrentLocation() async {
    print("current location..   ");
    // Location location = Location();
    try {
      Permission.notification.request();
      Position location = await Geolocator.getCurrentPosition();
      print("position... getCurrentLocation  accept dispose " +
          location.toString());
      // Create a LocationData object from the Position data
      LocationData locationData = LocationData.fromMap({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'accuracy': location.accuracy,
        'heading': location.heading
        // Add other necessary properties if available
      });
      print("position... getCurrentLocationIOS locationData accept dispose " +
          locationData.toString());
      currentLocation.value = locationData;

      // await location.getLocation().then((location) async {
      print("current location..   ${location.latitude}");
      // currentLocation.value = location;
      wayLocation.value =
          LatLng(location.latitude.toDouble(), location.longitude.toDouble());
      PreviousWayLocation.value =
          LatLng(location.latitude.toDouble(), location.longitude.toDouble());
      KmPreviousLocation.value =
          LatLng(location.latitude.toDouble(), location.longitude.toDouble());

      UserSession.setDoubleInSession(
          UserSession.keyCurrentLat, location.latitude.toDouble());
      UserSession.setDoubleInSession(
          UserSession.keyCurrentLng, location.longitude.toDouble());

      if (UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus) ==
          2) {
        updateNotify(
            UserSession.getIntFromSession(UserSession.notifyStatus) ?? 0);
        totalKm.value =
            UserSession.getDoubleInSession(UserSession.currentRideTotalKm);
        print("First Check total Km ${totalKm.value}");
        double lastLong =
            UserSession.getDoubleInSession(UserSession.currentBookingLastLong);
        double lastLat =
            UserSession.getDoubleInSession(UserSession.currentBookingLastLat);
        print("First Check lastLat $lastLat laofh $lastLong");
        LocationData? locationData = currentLocation.value;
        if (lastLat != 0.0 && lastLong != 0.0 && locationData != null) {
          var distance = calculateDistance(
              lastLat, lastLong, locationData.latitude, locationData.longitude);
          print("intital Distance distance   ${distance}");
          totalKm.value = totalKm.value + distance;

          print("intital Distance ${totalKm.value}");
          UserSession.setDoubleInSession(
              UserSession.currentRideTotalKm, totalKm.value);
          checkTotalDistance();
        }
      }

      if (Get.currentRoute == "AcceptRideScreen") {
        // socket condition change..
        Future.delayed(Duration(seconds: 3), () {
          SocketConnection.sendMessage("driveCurrentLocationUpdate", {
            'longitude': location.longitude.toString(),
            'latitude': location.latitude.toString(),
          });
        });

        // destination marker
        addWayMarker(wayLocation.value!, "wayLocation",
            BitmapDescriptor.defaultMarker, "assets/images/ic_car_track.png");
      }

      if (UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus) ==
              1 ||
          UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus) ==
              2) {
        print("  currentLocation.value!.heading..   " +
            currentLocation.value!.heading.toString());
        SocketConnection.sendMessage("driveOnUpdateLocation", {
          'booking_id':
              UserSession.getStringFromSession(UserSession.keyCurrentBookingId),
          'location': wayLocation.value,
          'heading':
              double.parse(currentLocation.value!.heading.toString()) - 180,
          'arrivalTime': driverDuration.value,
          'arrivalTimeValue': driverDurationInMinute.value,
          'arrivalDistance': driverDistance.value
        });
      }
      //});
    } catch (e) {
      // getPermissionForLocation();
      print("current location ee..  " + e.toString());
    }

    locationSubscription = Geolocator.getPositionStream().listen(
      (Position loc) async {
        // location.onLocationChanged.listen(
        // (newLoc) async {
        print(
            "  .distanceBetweenPoints  newLoc.accuracy!..11 accept dispose  ${loc.altitude}");
        try {
          LocationData newLoc = LocationData.fromMap({
            'latitude': loc.latitude,
            'longitude': loc.longitude,
            'accuracy': loc.accuracy,
            'heading': loc.heading
            // Add other necessary properties if available
          });
          print(
              "  .distanceBetweenPoints  newLoc.accuracy!..accept dispose  ${newLoc.accuracy!}");
          // showFlutterToast(
          //     message: "accuracy ..    " + newLoc.accuracy.toString());
          if (newLoc.accuracy! <= minLocationAccuracy) {
            print("current loca.. onchange.. accept ride dispose  $newLoc");

            double newBearing = bearingBetweenPoints(
                LatLng(currentLocation.value!.latitude!,
                    currentLocation.value!.longitude!),
                LatLng(newLoc.latitude!, newLoc.longitude!));
            updateMapBearing(newBearing);

            wayLocation.value = LatLng(
                newLoc.latitude!.toDouble(), newLoc.longitude!.toDouble());

            currentLocation.value = newLoc;
            UserSession.setDoubleInSession(
                UserSession.keyCurrentLat, newLoc.latitude!.toDouble());
            UserSession.setDoubleInSession(
                UserSession.keyCurrentLng, newLoc.longitude!.toDouble());

            addWayMarker(
                wayLocation.value!,
                "wayLocation",
                BitmapDescriptor.defaultMarker,
                "assets/images/ic_car_track.png");
            print(" add way marker..  after add way marker..  ");

            print("start location..   ${startLocation.value}");

            print(
                " keyCurrentBookingStatus... ${UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus)}");

            if (UserSession.getIntFromSession(
                        UserSession.keyCurrentBookingStatus) ==
                    1 ||
                UserSession.getIntFromSession(
                        UserSession.keyCurrentBookingStatus) ==
                    2) {
              print("multipleWayLocation,.. onchange  $multipleWayLocation");
              if (multipleWayLocation.isNotEmpty) {
                var distanceBetweenPoints =
                    SphericalUtil.computeDistanceBetween(
                        LatLng(PreviousWayLocation.value!.latitude,
                            PreviousWayLocation.value!.longitude),
                        LatLng(wayLocation.value!.latitude,
                            wayLocation.value!.longitude));

                print(
                    "distanceBetweenPoints... safca  $distanceBetweenPoints Prwerf ");

                if (distanceBetweenPoints > 5.0) {
                  // distanceBetweenPoints = 0;
                  if (UserSession.getIntFromSession(
                              UserSession.keyCurrentBookingStatus) ==
                          2 &&
                      previousDistance.toStringAsFixed(2) !=
                          distanceBetweenPoints.toStringAsFixed(2)) {
                    print("distanceBetweenPoints.. 888.....  " +
                        distanceBetweenPoints.toString());

                    totalKm.value = totalKm.value + distanceBetweenPoints;
                    previousDistance = distanceBetweenPoints;

                    print("total km ..  " + totalKm.value.toString());
                    UserSession.setDoubleInSession(
                        UserSession.currentRideTotalKm, totalKm.value);

                    UserSession.setDoubleInSession(
                        UserSession.currentBookingLastLat,
                        wayLocation.value!.latitude);
                    UserSession.setDoubleInSession(
                        UserSession.currentBookingLastLong,
                        wayLocation.value!.longitude);
                    await checkTotalDistance();
                  }

                  PreviousWayLocation.value = LatLng(
                      newLoc.latitude!.toDouble(),
                      newLoc.longitude!.toDouble());
                  print("  currentLocation.value!.heading..   " +
                      currentLocation.value!.heading.toString());
                  SocketConnection.sendMessage("driveOnUpdateLocation", {
                    'booking_id': UserSession.getStringFromSession(
                        UserSession.keyCurrentBookingId),
                    'location': wayLocation.value,
                    'heading': double.parse(
                            currentLocation.value!.heading.toString()) -
                        180,
                    'arrivalTime': driverDuration.value,
                    'arrivalTimeValue': driverDurationInMinute.value,
                    'arrivalDistance': driverDistance.value
                  });
                  // PolygonUtil.earthRadius = 6371009.0;
                  var val = PolygonUtil.isLocationOnPath(
                      LatLng(double.parse(newLoc.latitude!.toStringAsFixed(3)),
                          double.parse(newLoc.longitude!.toStringAsFixed(3))),
                      multipleWayLocation,
                      false,
                      tolerance: 0.01);
                  print(
                      "startLocation...    getpolyline...val   ${startLocation.value}");

                  print("isLocationOnPath..  $val");
                  print(
                      "startLocation...    getpolyline... pre  ${startLocation.value}");
                  if (val == false) {
                    multipleWayLocation.clear();
                    print(
                        "startLocation...    getpolyline...mul   ${startLocation.value}");
                    await getPolyline();
                  }
                }
                // if (previousDistance.toStringAsFixed(2) !=
                //     distanceBetweenPoints.toStringAsFixed(2)) {
                //   SocketConnection.sendMessage("driveOnUpdateLocation", {
                //     'booking_id': UserSession.getStringFromSession(
                //         UserSession.keyCurrentBookingId),
                //     'location': wayLocation,
                //     'heading':
                //         double.parse(currentLocation.value!.heading.toString()) -
                //             180,
                //     'arrivalTime': driverDuration,
                //   });
                // }
              } else {
                // showFlutterToast(message: "Multiple way location null..   ");
              }
            }
          }
        } catch (e) {
          print(" on location change,, excep... $e");
        }
      },
    );
  }

  checkTotalDistance() {
    // final acceptRideController = Get.find<AcceptRideController>();
    if (data.bookingData!.km != null) {
      print(
          "acceptRideController.data.bookingData!.km..    ${data.bookingData!.km}");
      double wayKm = double.parse((totalKm.value / 1000).toString());
      double packageKm = double.parse(data.bookingData!.km!) - 1;
      print("wayKm..   $wayKm");
      //  showFlutterToast(message: "Way Km... ${wayKm.toStringAsFixed(5)}");
      print("packageKm..   $packageKm");
      print("isNotify..   $isNotify");
      print("isNotify..   ${data.bookingData!.rideType}");
      print(
          "wayKm >= packageKm   ${wayKm >= packageKm && isNotify == 0 && (data.bookingData!.rideType.toString() == "2" || data.bookingData!.rideType.toString() == "3")}");
      if (wayKm >= packageKm &&
          isNotify == 0 &&
          (data.bookingData!.rideType.toString() == "2" ||
              data.bookingData!.rideType.toString() == "3")) {
        print("FAKUYYFWBJMHB ");
        updateNotify(1);
        UserSession.setIntInSession(UserSession.notifyStatus, isNotify);
        Map datamap = {
          "booking_id": data.bookingData!.bookingId,
          "type": "distance",
          "km": wayKm.round(),
          "notifyStatus": "1"
        };
        print("FAKUYYFWBJMHB $datamap");
        SocketConnection.sendMessage("notifyBothforTimeKm", datamap);
      } else if (wayKm >= (packageKm + 1) && isNotify == 1) {
        updateNotify(2);
        Map datamap = {
          "booking_id": data.bookingData!.bookingId,
          "type": "distance",
          "km": wayKm.round(),
          "notifyStatus": "2"
        };
        print("saehkufhjewlf $datamap");
        SocketConnection.sendMessage("notifyBothforTimeKm", datamap);
        if (Get.isDialogOpen ?? false) {
        } else {
          Get.dialog(
            WillPopScope(
              onWillPop: () async => false,
              child: const PackageExtend(isKm: true),
            ),
          );
        }
      }
    }
    debugPrint(
        "Total Km CheckInga PackageKM ${data.bookingData!.km} Total Km ${totalKm.value / 1000} ${data.bookingData!.rideType}");
  }

  void updateNotify(int value) {
    isNotify = value;
    UserSession.setIntInSession(UserSession.notifyStatus, value);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  setIcon(String s) async {
    final Uint8List markerIcon = await getBytesFromAsset(s, 65);
    print("add way marker ...  marker icon..  " + markerIcon.toString());
    icons.value = BitmapDescriptor.fromBytes(markerIcon);
    print("add way marker ...  icons.value..  " + icons.value.toString());
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    print("add way marker ...  data..  " + data.toString());
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    print("add way marker ...  codec..  " + codec.toString());
    ui.FrameInfo fi = await codec.getNextFrame();
    print("add way marker ...  fi..  " + fi.toString());
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void clearCache() {
    totalKm.value = 0.0;
    isNotify = 0;
    UserSession.setDoubleInSession(UserSession.currentBookingLastLat, 0.0);
    UserSession.setDoubleInSession(UserSession.currentBookingLastLong, 0.0);
    UserSession.setDoubleInSession(UserSession.currentRideTotalKm, 0.0);
    UserSession.setIntInSession(UserSession.notifyStatus, 0);
  }

  void updateMapBearing(double newBearing) {
    currentBearing.value = newBearing;

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              wayLocation.value!.latitude,
              wayLocation
                  .value!.longitude), // Update with your current location
          zoom: 19,
          bearing: currentBearing.value,
        ),
      ),
    );
  }

  double bearingBetweenPoints(LatLng from, LatLng to) {
    double lat1 = from.latitude;
    double lon1 = from.longitude;
    double lat2 = to.latitude;
    double lon2 = to.longitude;

    double deltaLon = lon2 - lon1;

    double y = sin(deltaLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon);
    double angle = atan2(y, x);

    return (angle) / pi;
  }

  Future<Uint8List> getBytesFromAss(String path) async {
    double pixelRatio = MediaQuery.of(Get.key.currentContext!).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: pixelRatio.round() * 30);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future addWayMarker(
      LatLng position, String id, BitmapDescriptor descriptor, String s) async {
    print("add way marker ... before setIcon  .  " + setIcon.toString());
    if (icons.value != null) {
      MarkerId markerId = MarkerId(id);
      Marker marker = Marker(
          markerId: markerId,
          icon: icons.value!,
          position: position,
          // draggable: true,
          rotation:
              double.parse(currentLocation.value!.heading.toString()) - 180,
          // rotation: bearing!,
          flat: false,
          anchor: const Offset(0.5, 0.5),
          alpha: 0.91);
      markers[markerId] = marker;
    }
  }

  addWayMarkerAnimated(
      LatLng position, String id, BitmapDescriptor descriptor, String s) async {
    // await setIcon(s);
    // if (icons.value != null) {
    //   MarkerId markerId = MarkerId(id);
    //   Marker marker = Marker(
    //       markerId: markerId,
    //       icon: icons.value!,
    //       position: position,
    //       // draggable: true,
    //       rotation:
    //           double.parse(currentLocation.value!.heading.toString()) - 180,
    //       // rotation: bearing!,
    //       flat: false,
    //       anchor: const Offset(0.5, 0.5),
    //       alpha: 0.91);

    //   markers[markerId] = marker;
    //   print("add way marker... 33 ");

    try {
      print("add way marker... animateCamera " + mapController.toString());
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 19,
            //bearing: double.parse(currentLocation.value!.heading.toString()),
            target: LatLng(
              position.latitude,
              position.longitude,
            ),
          ),
        ),
      );
      print("add way marker... animateCamera 11 ");
    } catch (e) {
      print(" animate...  " + e.toString());
    }
    // }
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return degrees(atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - degrees(atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return degrees(atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - degrees(atan(lng / lat))) + 270;
    }
    return -1;
  }

  addStartMarker(
      LatLng position, String id, BitmapDescriptor descriptor, String s) async {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: position,
        // rotation: double.parse(currentLocation!.heading.toString()),
        flat: false,
        anchor: Offset(0.5, 0.5),
        alpha: 0.91);
    markers[markerId] = marker;
  }

  addEndMarker(
      LatLng position, String id, BitmapDescriptor descriptor, String s) async {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: position,
        flat: false,
        anchor: Offset(0.5, 0.5),
        alpha: 0.91);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    print("add polyline..  $polylineCoordinates");
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: ConstColor.blackColor,
        points: polylineCoordinates,
        width: 4);
    polylines[id] = polyline;
    //setState(() {});
  }

  Future<String> getAddress() async {
    var addresses = await Geocoder2.getDataFromCoordinates(
        latitude: wayLocation.value!.latitude,
        longitude: wayLocation.value!.longitude,
        googleMapApiKey: AppConstents.googleApiKey);

    print("addressesaddresses   ${addresses.address}");
    return addresses.address;
  }

  getPolyline() async {
    count = count + 1;
    //  Fluttertoast.showToast(
    //    msg: "API Count .. " + count.toString(), gravity: ToastGravity.CENTER);
    print("startLocation...    getpolyline...   ${startLocation.value}");
    print("startLocation...    getpolyline...   ${wayLocation.value}");
    var localLat = UserSession.getDoubleInSession(UserSession.keyCurrentLat);
    var localLng = UserSession.getDoubleInSession(UserSession.keyCurrentLng);
    // showFlutterToast(message: count.toString());
    // if (startLocation.value != null) {
    // final acceptRideController = Get.find<AcceptRideController>();
    if (UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus) ==
        1) {
      if (wayLocation.value != null) {
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          AppConstents.googleApiKey,
          PointLatLng(
              wayLocation.value!.latitude, wayLocation.value!.longitude),
          PointLatLng(
              startLocation.value!.latitude, startLocation.value!.longitude),
          PointLatLng(
              wayLocation.value!.latitude, wayLocation.value!.longitude),
          travelMode: TravelMode.driving,
        );
        if (result.points.isNotEmpty) {
          polylineCoordinates.value = [];
          result.points.forEach((PointLatLng point) {
            print("polyline result..  ${point.latitude}");
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        }

        _addPolyLine();
      } else {
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          AppConstents.googleApiKey,
          PointLatLng(currentLocation.value?.latitude ?? localLat,
              currentLocation.value?.longitude ?? localLng),
          PointLatLng(
              startLocation.value!.latitude, startLocation.value!.longitude),
          PointLatLng(currentLocation.value?.latitude ?? localLat,
              currentLocation.value?.longitude ?? localLng),
          travelMode: TravelMode.driving,
        );
        if (result.points.isNotEmpty) {
          polylineCoordinates.value = [];
          for (var point in result.points) {
            print("polyline result..  ${point.latitude}");
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
        }

        _addPolyLine();
      }
    } else if (UserSession.getIntFromSession(
            UserSession.keyCurrentBookingStatus) ==
        2) {
      if (data.bookingData!.rideType.toString() != "2" &&
          data.bookingData!.rideType.toString() != "3") {
        if (wayLocation.value != null) {
          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
            AppConstents.googleApiKey,
            PointLatLng(
                wayLocation.value!.latitude, wayLocation.value!.longitude),
            PointLatLng(
                endLocation.value!.latitude, endLocation.value!.longitude),
            PointLatLng(
                wayLocation.value!.latitude, wayLocation.value!.longitude),
            travelMode: TravelMode.driving,
          );
          if (result.points.isNotEmpty) {
            polylineCoordinates.value = [];
            result.points.forEach((PointLatLng point) {
              print("polyline result..  ${point.latitude}");
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
          }

          _addPolyLine();
        } else {
          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
            AppConstents.googleApiKey,
            PointLatLng(currentLocation.value?.latitude ?? localLat,
                currentLocation.value?.longitude ?? localLng),
            PointLatLng(
                endLocation.value!.latitude, endLocation.value!.longitude),
            PointLatLng(currentLocation.value?.latitude ?? localLat,
                currentLocation.value?.longitude ?? localLng),
            travelMode: TravelMode.driving,
          );
          if (result.points.isNotEmpty) {
            polylineCoordinates.value = [];
            for (var point in result.points) {
              print("polyline result..  ${point.latitude}");
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            }
          }

          _addPolyLine();
        }
      } else {
        if (wayLocation.value != null) {
          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
            AppConstents.googleApiKey,
            PointLatLng(
                startLocation.value!.latitude, startLocation.value!.longitude),
            PointLatLng(
                wayLocation.value!.latitude, wayLocation.value!.longitude),
            PointLatLng(
                wayLocation.value!.latitude, wayLocation.value!.longitude),
            travelMode: TravelMode.driving,
          );
          if (result.points.isNotEmpty) {
            polylineCoordinates.value = [];
            result.points.forEach((PointLatLng point) {
              print("polyline result..  ${point.latitude}");
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
          }

          _addPolyLine();
        } else {
          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
            AppConstents.googleApiKey,
            PointLatLng(
                startLocation.value!.latitude, startLocation.value!.longitude),
            PointLatLng(currentLocation.value?.latitude ?? localLat,
                currentLocation.value?.longitude ?? localLng),
            PointLatLng(currentLocation.value?.latitude ?? localLat,
                currentLocation.value?.longitude ?? localLng),
            travelMode: TravelMode.driving,
          );
          if (result.points.isNotEmpty) {
            polylineCoordinates.value = [];
            for (var point in result.points) {
              print("polyline result..  ${point.latitude}");
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            }
          }

          _addPolyLine();
        }
      }
    }

    // if (wayLocation.value != null) {
    //   if (endLocation.value != null) {
    //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //       googleAPiKey.value,
    //       PointLatLng(
    //           startLocation.value!.latitude, startLocation.value!.longitude),
    //       PointLatLng(
    //           endLocation.value!.latitude, endLocation.value!.longitude),
    //       PointLatLng(
    //           wayLocation.value!.latitude, wayLocation.value!.longitude),
    //       travelMode: TravelMode.driving,
    //     );
    //     if (result.points.isNotEmpty) {
    //       polylineCoordinates.value = [];
    //       result.points.forEach((PointLatLng point) {
    //         print("polyline result..  ${point.latitude}");
    //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //       });
    //     }

    //     _addPolyLine();
    //   } else {
    //     print("polyline result.. else..   ");
    //     print(
    //         "polyline result.. else..   ${startLocation.value!.latitude}  ${startLocation.value!.longitude}");
    //     print(
    //         "polyline result.. else..   ${PointLatLng(wayLocation.value!.latitude, wayLocation.value!.longitude)}");
    //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //       googleAPiKey.value,
    //       PointLatLng(
    //           startLocation.value!.latitude, startLocation.value!.longitude),
    //       PointLatLng(
    //           wayLocation.value!.latitude, wayLocation.value!.longitude),
    //       PointLatLng(
    //           wayLocation.value!.latitude, wayLocation.value!.longitude),
    //       travelMode: TravelMode.driving,
    //     );
    //     print("polyline result.. else..   ${result.points}");
    //     if (result.points.isNotEmpty) {
    //       polylineCoordinates.value = [];
    //       result.points.forEach((PointLatLng point) {
    //         print("polyline result..  ${point.latitude}");
    //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //       });
    //     }

    //     _addPolyLine();
    //   }
    // } else {
    //   print("way location null ..  " + wayLocation.value.toString());
    //   var localLat = UserSession.getDoubleInSession(UserSession.keyCurrentLat);
    //   var localLng = UserSession.getDoubleInSession(UserSession.keyCurrentLng);
    //   if (endLocation.value != null) {
    //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //       googleAPiKey.value,
    //       PointLatLng(
    //           startLocation.value!.latitude, startLocation.value!.longitude),
    //       PointLatLng(
    //           endLocation.value!.latitude, endLocation.value!.longitude),
    //       PointLatLng(currentLocation.value?.latitude ?? localLat,
    //           currentLocation.value?.longitude ?? localLng),
    //       travelMode: TravelMode.driving,
    //     );
    //     if (result.points.isNotEmpty) {
    //       polylineCoordinates.value = [];
    //       for (var point in result.points) {
    //         print("polyline result..  ${point.latitude}");
    //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //       }
    //     }

    //     _addPolyLine();
    //   } else {
    //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //       googleAPiKey.value,
    //       PointLatLng(
    //           startLocation.value!.latitude, startLocation.value!.longitude),
    //       PointLatLng(currentLocation.value?.latitude ?? localLat,
    //           currentLocation.value?.longitude ?? localLng),
    //       PointLatLng(currentLocation.value?.latitude ?? localLat,
    //           currentLocation.value?.longitude ?? localLng),
    //       travelMode: TravelMode.driving,
    //     );
    //     if (result.points.isNotEmpty) {
    //       polylineCoordinates.value = [];
    //       for (var point in result.points) {
    //         print("polyline result..  ${point.latitude}");
    //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //       }
    //     }

    //     _addPolyLine();
    //   }
    // }
  }

  locationIntialization() async {
    wayLocation.value ??= LatLng(
        UserSession.getDoubleInSession(UserSession.keyCurrentLat),
        UserSession.getDoubleInSession(UserSession.keyCurrentLng));
    polylines.clear();

    if (UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus) ==
        1) {
      print(
          "controller.startLocation.value....    ${startLocation.value ?? "null"}");
      print("wayLocation...   ${wayLocation.value}");
      print("pickupLat...   ${data.bookingData!.pickupLat}");
      print(" pickupLong ...  ${data.bookingData!.pickupLong}");

      startLocation.value = LatLng(
          double.parse(data.bookingData!.pickupLat.toString()),
          double.parse(data.bookingData!.pickupLong.toString()));
      updateOriginLocation();

      // mapController.startLocation.value = mapController.wayLocation.value;

      // mapController.updateOriginLocation();

      // mapController.endLocation.value = LatLng(
      //     double.parse(data.bookingData!.pickupLat.toString()),
      //     double.parse(data.bookingData!.pickupLong.toString()));

      // mapController.updateDestinationLocation();

      // SocketConnection.sendMessage("driveOnUpdateLocation", {
      //   'booking_id':
      //       UserSession.getStringFromSession(UserSession.keyCurrentBookingId),
      //   'location': mapController.wayLocation.value,
      //   'heading': 180,
      //   'arrivalTime': "0",
      // });

      await getPolyline();
    } else if (UserSession.getIntFromSession(
            UserSession.keyCurrentBookingStatus) ==
        2) {
      if (data.bookingData!.rideType.toString() != "2" &&
          data.bookingData!.rideType.toString() != "3") {
        startLocation.value = LatLng(
            double.parse(data.bookingData!.pickupLat.toString()),
            double.parse(data.bookingData!.pickupLong.toString()));
        updateOriginLocation();
        endLocation.value = LatLng(
            double.parse(data.bookingData!.dropLat.toString()),
            double.parse(data.bookingData!.dropLong.toString()));
        updateDestinationLocation();
        // SocketConnection.sendMessage("driveOnUpdateLocation", {
        //   'booking_id':
        //       UserSession.getStringFromSession(UserSession.keyCurrentBookingId),
        //   'location': mapController.wayLocation.value,
        //   'heading': 180,
        //   'arrivalTime': "0",
        // });

        await getPolyline();
      } else {
        startLocation.value = LatLng(
            double.parse(data.bookingData!.pickupLat.toString()),
            double.parse(data.bookingData!.pickupLong.toString()));
        updateOriginLocation();
        //  mapController.endLocation.value = mapController.wayLocation.value;
        // mapController.updateDestinationLocation();
        // SocketConnection.sendMessage("driveOnUpdateLocation", {
        //   'booking_id':
        //       UserSession.getStringFromSession(UserSession.keyCurrentBookingId),
        //   'location': mapController.wayLocation.value,
        //   'heading': 180,
        //   'arrivalTime': "0",
        // });

        await getPolyline();
      }
    }
    if (currentLocation.value == null || wayLocation.value == null) {
    } else {
      print("  currentLocation.value!.heading..   " +
          currentLocation.value!.heading.toString());
      SocketConnection.sendMessage("driveOnUpdateLocation", {
        'booking_id':
            UserSession.getStringFromSession(UserSession.keyCurrentBookingId),
        'location': wayLocation.value,
        'heading':
            (double.parse(currentLocation.value!.heading.toString()) - 180),
        'arrivalTime': driverDuration.value,
        'arrivalTimeValue': driverDurationInMinute.value,
        'arrivalDistance': driverDistance.value
      });
    }
  }

  mapNavigate() {
    showModalBottomSheet(
        context: Get.key.currentContext!,
        elevation: 10,
        backgroundColor: ConstColor.codeFieldColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsetsDirectional.only(
                start: 20, end: 20, top: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    AppConstents().txtOpenWith + " : ",
                    style: black18Normal500,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          navigateToMap();
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "assets/images/Maps.png",
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                              Container(child: Text("Map"))
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            navigateToWaze();
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  child: Image.asset(
                                    "assets/images/Waze.png",
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                                Container(child: Text("Waze"))
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<bool> onLoginBackPressed() async {
    DateTime CurrentTime = DateTime.now();
    bool backButton = backBtnPressTime == null ||
        CurrentTime.difference(backBtnPressTime!) > const Duration(seconds: 3);
    if (backButton) {
      backBtnPressTime = CurrentTime;
      showFlutterToast(
          message:
              AppLocalizations.of(Get.key.currentContext!)!.txt_double_click,
          backgroundColor: ConstColor.blackColor,
          textColor: ConstColor.accentColor);
      return false;
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  void verifyOtp() {
    print("otpController..    ${otpController.text}");
    locationSubscription?.pause();
    if (otpController.text.toString().trim().length == 4) {
      SocketConnection.sendMessage("bookingOtpVerify", {
        "otp": otpController.text.toString(),
        "booking_id": data.bookingData!.bookingId
      });
    } else {
      showFlutterToast(
          message: AppLocalizations.of(Get.key.currentContext!)!.val_otp);
    }
  }

  bool isLoading = false;

  double extendedKmCheck() {
    double dataKm = double.parse(data.bookingData!.km!);
    double totalKms = totalKm.value / 1000;
    var result = totalKms - dataKm;
    print("result..   " + result.toString());
    if (result.isNegative) {
      return 0;
    } else {
      return result;
    }
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            ' ${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
        print("Address.   " + address.toString());
        return address;
      }
    } catch (e) {
      print('Error: $e');
    }
    return '';
  }

  void completedBooking() async {
    var addresses = await getAddressFromCoordinates(
      wayLocation.value!.latitude,
      wayLocation.value!.longitude,
    );
    print(
        "data.bookingData!.bookingId.toString() ..    ${data.bookingData!.bookingId}");
    var mapData = {
      "booking_id": data.bookingData!.bookingId,
      "ride_type": data.bookingData!.rideType.toString(),
      "drop_long": wayLocation.value!.longitude,
      "drop_lat": wayLocation.value!.latitude,
      "drop_address": addresses,
      "extendedKms": (data.bookingData!.rideType.toString() == "0" ||
              data.bookingData!.rideType.toString() == "1")
          ? (totalKm.value / 1000).toStringAsFixed(2)
          : extendedKmCheck()
    };
    SocketConnection.sendMessage("bookingComplete", mapData);
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madr_driver/design/dashboard/controller/accept_ride_controller.dart';
import 'package:madr_driver/utils/location.dart';
import 'package:madr_driver/utils/user_session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class MapPolylines extends StatefulWidget {
  const MapPolylines({super.key});

  @override
  State<MapPolylines> createState() => MapPolylinesState();
}

class MapPolylinesState extends State<MapPolylines> {
  var controller = Get.find<AcceptRideController>();

  @override
  void initState() {
    super.initState();
    print("map polyline initialise..   ");
    controller.addCustomIcon();
    Future.delayed(Duration(seconds: 5), () {
      if (Platform.isIOS) {
        Geolocator.checkPermission().then((value) {
          print("location permission..   " + value.toString());
          if (value == LocationPermission.denied ||
              value == LocationPermission.deniedForever) {
            //s = await Geolocator.requestPermission();..
            Location.locationPermission();
          } else if (value != LocationPermission.always ||
              value != LocationPermission.whileInUse) {
            print('Location Enable home');
            controller.getCurrentLocation();
          }
        });
      } else {
        Permission.location.isGranted.then((value) {
          print("val Permission.location  $value");
          if (value) {
            print('Location Enable mapwidget');
            controller.getCurrentLocation();
          } else {
            print('Location Disable');
            Location.locationPermission();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("map polyline dispose..  " + controller.markers.isEmpty.toString());
    controller.markers.value = {};
    controller.icons.value = null;
    controller.mapController.dispose();
    controller.locationSubscription?.cancel();

    // controller.onRejectLead();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print("accept ride google map..  " + Get.currentRoute.toString());
      return (controller.currentLocation.value == null &&
              UserSession.getDoubleInSession(UserSession.keyCurrentLat) == 0.0)
          ? GoogleMap(
              initialCameraPosition: const CameraPosition(
                  target: LatLng(24.372950, 140.849577), zoom: 1),
              onMapCreated: controller.onMapCreated,
              liteModeEnabled: false,
              myLocationButtonEnabled: false,
              markers: {},
              polylines: {},
            )
          : (controller.currentLocation.value == null)
              ? GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          UserSession.getDoubleInSession(
                              UserSession.keyCurrentLat),
                          UserSession.getDoubleInSession(
                              UserSession.keyCurrentLng)),
                      zoom: 19),
                  onMapCreated: controller.onMapCreated,
                  liteModeEnabled: false,
                  myLocationButtonEnabled: false,
                  markers: (controller.markers.isNotEmpty)
                      ? Set<Marker>.of(controller.markers.values)
                      : {},
                  polylines: controller.polylines.isNotEmpty
                      ? Set<Polyline>.of(controller.polylines.values)
                      : {},
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          controller.currentLocation.value!.latitude!,
                          controller.currentLocation.value!.longitude!),
                      zoom: 19),
                  onMapCreated: controller.onMapCreated,
                  liteModeEnabled: false,
                  myLocationButtonEnabled: false,
                  markers: (controller.markers.isNotEmpty)
                      ? Set<Marker>.of(controller.markers.values)
                      : {},
                  polylines: controller.polylines.isNotEmpty
                      ? Set<Polyline>.of(controller.polylines.values)
                      : {},
                );

      // GoogleMap(
      //     initialCameraPosition: CameraPosition(
      //         target: controller.wayLocation.value == null
      //             ? controller.currentLocation.value == null
      //                 ? LatLng(
      //                     UserSession.getDoubleInSession(
      //                         UserSession.keyCurrentLat),
      //                     UserSession.getDoubleInSession(
      //                         UserSession.keyCurrentLng))
      //                 : LatLng(controller.currentLocation.value!.latitude!,
      //                     controller.currentLocation.value!.longitude!)
      //             : LatLng(controller.wayLocation.value!.latitude,
      //                 controller.wayLocation.value!.longitude),
      //         zoom: 19,
      //         bearing: controller.currentBearing.value),
      //     liteModeEnabled: false,
      //     onMapCreated: controller.onMapCreated,
      //     myLocationButtonEnabled: false,
      //     // onCameraMove: (position) {
      //     //   print("camera move position..  " + position.toString());
      //     //   controller.currentBearing.value = position.bearing;
      //     // },
      //     markers: (controller.markers.isNotEmpty)
      //         ? Set<Marker>.of(controller.markers.values)
      //         : {},
      //     polylines: controller.polylines.isNotEmpty
      //         ? Set<Polyline>.of(controller.polylines.values)
      //         : {},
      //   );
    });
  }
}

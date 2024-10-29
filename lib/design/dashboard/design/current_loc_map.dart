import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madr_driver/design/dashboard/controller/home_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

import '../../../utils/location.dart';
import '../../../utils/user_session.dart';

class CurrentLocMap extends StatefulWidget {
  const CurrentLocMap({super.key});

  @override
  State<CurrentLocMap> createState() => CurrentLocMapState();
}

class CurrentLocMapState extends State<CurrentLocMap> {
  var controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    //  Future.delayed(const Duration(seconds: 5), () {
    controller.addCustomIcon();
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
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //controller.markerIcon.value = null;
    print("homeprint.. current ma  " +
        controller.homeMapController.isBlank.toString());
    controller.homeMapController.dispose();
    controller.locationSubscription?.cancel();
    print(" homeprint.. current map dispose..  ");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(" homeprint.. home screen map..  " +
          controller.updateloc.value.toString());
      print("google map.rebuild.  " + mounted.toString());

      // return GoogleMap(
      //   initialCameraPosition: CameraPosition(
      //     target: LatLng(
      //       controller.updateloc.value?.latitude ??
      //           (UserSession.getDoubleInSession(UserSession.keyCurrentLat) ==
      //                   "0.0"
      //               ? 24.372950
      //               : UserSession.getDoubleInSession(
      //                   UserSession.keyCurrentLat)),
      //       controller.updateloc.value?.longitude ??
      //           (UserSession.getDoubleInSession(UserSession.keyCurrentLng) ==
      //                   "0.0"
      //               ? 140.849577
      //               : UserSession.getDoubleInSession(
      //                   UserSession.keyCurrentLat)),
      //     ),
      //     zoom: 19,
      //   ),
      //   onMapCreated: controller.onMapCreated,
      //   liteModeEnabled: false,
      //   myLocationButtonEnabled: false,
      //   markers: (controller.markerIcon.value == null)
      //       ? {}
      //       : {
      //           Marker(
      //             markerId: const MarkerId("updateLoc"),
      //             position: LatLng(
      //               controller.updateloc.value?.latitude ??
      //                   UserSession.getDoubleInSession(
      //                       UserSession.keyCurrentLat),
      //               controller.updateloc.value?.longitude ??
      //                   UserSession.getDoubleInSession(
      //                       UserSession.keyCurrentLng),
      //             ),
      //             icon: controller.markerIcon.value!,
      //             rotation: double.parse(
      //                     controller.updateloc.value?.heading?.toString() ??
      //                         "0") -
      //                 180,
      //           ),
      //         },
      //   polylines: {},
      // );

      return (controller.updateloc.value == null &&
              UserSession.getDoubleInSession(UserSession.keyCurrentLat) == 0.0)
          ? GoogleMap(
              initialCameraPosition: const CameraPosition(
                  target: LatLng(24.372950, 140.849577), zoom: 1),
              onMapCreated: controller.onMapCreated,
              liteModeEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              markers: {},
              polylines: {},
            )
          : (controller.updateloc.value == null)
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
                  zoomControlsEnabled: true,
                  markers: (controller.markerIcon.value == null)
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId("updateLoc"),
                            position: LatLng(
                                UserSession.getDoubleInSession(
                                    UserSession.keyCurrentLat),
                                UserSession.getDoubleInSession(
                                    UserSession.keyCurrentLng)),
                            icon: controller.markerIcon.value!,
                            rotation: 180,
                          ),
                        },
                  polylines: {},
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(controller.updateloc.value!.latitude!,
                          controller.updateloc.value!.longitude!),
                      zoom: 19),
                  onMapCreated: controller.onMapCreated,
                  liteModeEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  markers: (controller.markerIcon.value == null)
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId("updateLoc"),
                            position: LatLng(
                                controller.updateloc.value!.latitude!,
                                controller.updateloc.value!.longitude!),
                            icon: controller.markerIcon.value!,
                            rotation: double.parse(controller
                                    .updateloc.value!.heading
                                    .toString()) -
                                180,
                          ),
                        },
                  polylines: {},
                );
    });
  }
}

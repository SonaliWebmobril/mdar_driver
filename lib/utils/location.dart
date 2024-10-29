import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:madr_driver/design/dashboard/controller/accept_ride_controller.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../design/dashboard/controller/home_controller.dart';

class Location {
  // static final controller = Get.find<Accept>();

  static Future<void> locationPermission() async {
    try {
      if (Platform.isIOS) {
        // Permission.location.request();
        LocationPermission s = await Geolocator.checkPermission();
        print("location permission..   " + s.toString());
        if (s == LocationPermission.denied) {
          Permission.location.request().then((value) async {
            print("Location ..  val.. " + value.toString());
            if (Get.currentRoute == "HomeScreen") {
              var controller = Get.find<HomeController>();
              await controller.getCurrentLocation();
            } else if (Get.currentRoute == "AcceptRideScreen") {
              var controller = Get.find<AcceptRideController>();
              await controller.getCurrentLocation();
            }
          });
        } else if (s == LocationPermission.deniedForever) {
          showFlutterToast(message: AppConstents().locationSettingPermission);

          // return await showDialog(
          //     context: Get.key.currentContext!,
          //     barrierDismissible: false,
          //     builder: (BuildContext context) => AlertDialog(
          //         title: Text(AppLocalizations.of(Get.key.currentContext!)!
          //             .txt_location_permission),
          //         content: Container(
          //             // height: 200,
          //             color: Colors.white,
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Container(
          //                     child: Text(
          //                   AppLocalizations.of(Get.key.currentContext!)!
          //                       .txt_permision_setting,
          //                   style: const TextStyle(
          //                       fontSize: 16, fontWeight: FontWeight.w400),
          //                 )),
          //                 InkWell(
          //                   onTap: () {
          //                     //Get.back();
          //                     FocusManager.instance.primaryFocus?.unfocus();

          //                     Get.back();
          //                     openAppSettings().whenComplete(() async {
          //                       PermissionStatus status =
          //                           await Permission.location.status;
          //                       print("permission status..nexttt  " +
          //                           status.toString());

          //                       if (status.isGranted) {
          //                         if (Get.currentRoute == "HomeScreen") {
          //                           var controller = Get.find<HomeController>();
          //                           await controller.getCurrentLocation();
          //                         } else if (Get.currentRoute ==
          //                             "AcceptRideScreen") {
          //                           var controller =
          //                               Get.find<AcceptRideController>();
          //                           await controller.getCurrentLocation();
          //                         }
          //                         //  controller.getCurrentLocation();
          //                       }
          //                     }).asStream();
          //                   },
          //                   child: Container(
          //                       decoration: linearColorDecoration,
          //                       margin: const EdgeInsetsDirectional.only(
          //                           top: 15, bottom: 10),
          //                       padding: const EdgeInsets.only(
          //                           left: 55, right: 55, top: 8, bottom: 8),
          //                       child: Text(
          //                           AppLocalizations.of(
          //                                   Get.key.currentContext!)!
          //                               .txt_setting,
          //                           style: const TextStyle(
          //                               fontSize: 16,
          //                               fontWeight: FontWeight.w600,
          //                               color: Colors.white))),
          //                 ),
          //                 InkWell(
          //                     onTap: () {
          //                       // Get.back();
          //                       FocusManager.instance.primaryFocus?.unfocus();
          //                       // print("userToken..  " +
          //                       //     userToken
          //                       //         .toString());
          //                       // if (userToken ==
          //                       //         null ||
          //                       //     userToken == "") {
          //                       //   Get.back();
          //                       //   Get.back();
          //                       // } else {
          //                       //   SystemNavigator
          //                       //       .pop();
          //                       //   // openAppSettings()
          //                       //   //     .then((value) {
          //                       //   //   print("value ...   " +
          //                       //   //       value
          //                       //   //           .toString());
          //                       //   // });
          //                       // }
          //                       // Get.back();
          //                       Get.back();
          //                     },
          //                     child: Container(
          //                       child: Text(
          //                           AppLocalizations.of(
          //                                   Get.key.currentContext!)!
          //                               .txt_exit,
          //                           style: const TextStyle(
          //                             fontSize: 14,
          //                             fontWeight: FontWeight.w600,
          //                           )),
          //                     ))
          //               ],
          //             ))));
        } else if (s != LocationPermission.always ||
            s != LocationPermission.whileInUse) {
          if (Get.currentRoute == "HomeScreen") {
            var controller = Get.find<HomeController>();
            await controller.getCurrentLocation();
          } else if (Get.currentRoute == "AcceptRideScreen") {
            var controller = Get.find<AcceptRideController>();
            await controller.getCurrentLocation();
          }
          // await controller.getCurrentLocation();
        } else {
          // global.locationMessage = '${AppLocalizations.of(context)!.txt_please_enablet_location_permission_to_use_app}';
        }
      } else {
        PermissionStatus permissionStatus = await Permission.location.status;
        print("PermissionStatus  ..  $permissionStatus");
        if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
          var data = await Permission.location.request();
          // var data = request
          print("permissionStatus data..   " + data.toString());

          print("PermissionStatus  .. isDenied ${Get.key.currentContext}");
          if (data == PermissionStatus.granted) {
            if (Get.currentRoute == "HomeScreen") {
              var controller = Get.find<HomeController>();
              await controller.getCurrentLocation();
            } else if (Get.currentRoute == "AcceptRideScreen") {
              var controller = Get.find<AcceptRideController>();
              await controller.getCurrentLocation();
            }
            // await controller.getCurrentLocation();
          } else {
            showFlutterToast(message: AppConstents().locationSettingPermission);
            // return await showDialog(
            //     context: Get.key.currentContext!,
            //     barrierDismissible: false,
            //     builder: (BuildContext context) => AlertDialog(
            //         title: Text(AppLocalizations.of(Get.key.currentContext!)!
            //             .txt_location_permission),
            //         content: Container(
            //             // height: 200,
            //             color: Colors.white,
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 Container(
            //                     child: Text(
            //                   AppLocalizations.of(Get.key.currentContext!)!
            //                       .txt_permision_location,
            //                   style: TextStyle(
            //                       fontSize: 16, fontWeight: FontWeight.w400),
            //                 )),
            //                 InkWell(
            //                   onTap: () async {
            //                     // Get.back();
            //                     FocusManager.instance.primaryFocus?.unfocus();
            //                     if (data ==
            //                         PermissionStatus.permanentlyDenied) {
            //                       // if (Permission.location.status !=
            //                       //     PermissionStatus.granted) {
            //                       //   locationPermission();
            //                       // }
            //                       Get.back();
            //                       await openAppSettings().then((value) async {
            //                         PermissionStatus status =
            //                             await Permission.location.status;
            //                         print("permission status..  " +
            //                             status.toString());
            //                         if (status.isGranted) {
            //                           if (Get.currentRoute == "HomeScreen") {
            //                             var controller =
            //                                 Get.find<HomeController>();
            //                             await controller.getCurrentLocation();
            //                           } else if (Get.currentRoute ==
            //                               "AcceptRideScreen") {
            //                             var controller =
            //                                 Get.find<AcceptRideController>();
            //                             await controller.getCurrentLocation();
            //                           }
            //                           // controller.getCurrentLocation();
            //                         }
            //                       });

            //                       print("openAppSettingsopenAppSettings ");
            //                     } else {
            //                       if (data == PermissionStatus.granted) {
            //                         if (Get.currentRoute == "HomeScreen") {
            //                           var controller =
            //                               Get.find<HomeController>();
            //                           await controller.getCurrentLocation();
            //                         } else if (Get.currentRoute ==
            //                             "AcceptRideScreen") {
            //                           var controller =
            //                               Get.find<AcceptRideController>();
            //                           await controller.getCurrentLocation();
            //                         }
            //                         // await controller.getCurrentLocation();
            //                       } else {
            //                         await Permission.location.request();
            //                       }
            //                     }
            //                   },
            //                   child: Container(
            //                       decoration: linearColorDecoration,
            //                       margin: const EdgeInsetsDirectional.only(
            //                           top: 15, bottom: 10),
            //                       padding: const EdgeInsetsDirectional.only(
            //                           start: 55, end: 55, top: 8, bottom: 8),
            //                       child: Text(
            //                           AppLocalizations.of(
            //                                   Get.key.currentContext!)!
            //                               .txt_retry,
            //                           style: const TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w600,
            //                               color: Colors.white))),
            //                 ),
            //                 InkWell(
            //                     onTap: () async {
            //                       Get.back();
            //                       FocusManager.instance.primaryFocus?.unfocus();

            //                       return await showDialog(
            //                           context: Get.key.currentContext!,
            //                           barrierDismissible: false,
            //                           builder: (BuildContext context) =>
            //                               AlertDialog(
            //                                   title: Text(AppLocalizations.of(
            //                                           Get.key.currentContext!)!
            //                                       .txt_location_permission),
            //                                   content: Container(
            //                                       // height: 200,
            //                                       color: Colors.white,
            //                                       child: Column(
            //                                         mainAxisSize:
            //                                             MainAxisSize.min,
            //                                         children: [
            //                                           Text(
            //                                             AppLocalizations.of(Get
            //                                                     .key
            //                                                     .currentContext!)!
            //                                                 .txt_permision_setting,
            //                                             style: const TextStyle(
            //                                                 fontSize: 16,
            //                                                 fontWeight:
            //                                                     FontWeight
            //                                                         .w400),
            //                                           ),
            //                                           InkWell(
            //                                             onTap: () {
            //                                               //Get.back();
            //                                               FocusManager.instance
            //                                                   .primaryFocus
            //                                                   ?.unfocus();

            //                                               Get.back();
            //                                               openAppSettings()
            //                                                   .whenComplete(
            //                                                       () async {
            //                                                 PermissionStatus
            //                                                     status =
            //                                                     await Permission
            //                                                         .location
            //                                                         .status;
            //                                                 print(
            //                                                     "permission status..nexttt  $status");

            //                                                 if (status
            //                                                     .isGranted) {
            //                                                   if (Get.currentRoute ==
            //                                                       "HomeScreen") {
            //                                                     var controller =
            //                                                         Get.find<
            //                                                             HomeController>();
            //                                                     await controller
            //                                                         .getCurrentLocation();
            //                                                   } else if (Get
            //                                                           .currentRoute ==
            //                                                       "AcceptRideScreen") {
            //                                                     var controller =
            //                                                         Get.find<
            //                                                             AcceptRideController>();
            //                                                     await controller
            //                                                         .getCurrentLocation();
            //                                                   }
            //                                                   // controller
            //                                                   //      .getCurrentLocation();
            //                                                 }
            //                                               });
            //                                             },
            //                                             child: Container(
            //                                                 decoration:
            //                                                     linearColorDecoration,
            //                                                 margin:
            //                                                     const EdgeInsetsDirectional
            //                                                         .only(
            //                                                         top: 15,
            //                                                         bottom: 10),
            //                                                 padding:
            //                                                     const EdgeInsets
            //                                                         .only(
            //                                                         left: 55,
            //                                                         right: 55,
            //                                                         top: 8,
            //                                                         bottom: 8),
            //                                                 child: Text(
            //                                                     AppLocalizations.of(Get
            //                                                             .key.currentContext!)!
            //                                                         .txt_setting,
            //                                                     style: const TextStyle(
            //                                                         fontSize:
            //                                                             16,
            //                                                         fontWeight:
            //                                                             FontWeight
            //                                                                 .w600,
            //                                                         color: Colors
            //                                                             .white))),
            //                                           ),
            //                                           InkWell(
            //                                               onTap: () {
            //                                                 // Get.back();
            //                                                 FocusManager
            //                                                     .instance
            //                                                     .primaryFocus
            //                                                     ?.unfocus();

            //                                                 Get.back();
            //                                               },
            //                                               child: Container(
            //                                                 child: Text(
            //                                                     AppLocalizations
            //                                                             .of(Get
            //                                                                 .key
            //                                                                 .currentContext!)!
            //                                                         .txt_exit,
            //                                                     style:
            //                                                         const TextStyle(
            //                                                       fontSize: 14,
            //                                                       fontWeight:
            //                                                           FontWeight
            //                                                               .w600,
            //                                                     )),
            //                                               ))
            //                                         ],
            //                                       ))));
            //                     },
            //                     child: Container(
            //                       child: Text(
            //                           AppLocalizations.of(
            //                                   Get.key.currentContext!)!
            //                               .txt_im_sure,
            //                           style: const TextStyle(
            //                             fontSize: 14,
            //                             fontWeight: FontWeight.w600,
            //                           )),
            //                     ))
            //               ],
            //             ))));
          }
        } else if (permissionStatus.isGranted) {
          print(".. permissionStatus.isGranted.. ");
          if (Get.currentRoute == "HomeScreen") {
            var controller = Get.find<HomeController>();
            await controller.getCurrentLocation();
          } else if (Get.currentRoute == "AcceptRideScreen") {
            var controller = Get.find<AcceptRideController>();
            await controller.getCurrentLocation();
          }
          // await controller.getCurrentLocation();
        } else if (permissionStatus.isPermanentlyDenied) {
          print("PermissionStatus  .else  ..  ");
          showFlutterToast(message: AppConstents().locationSettingPermission);

          // return await showDialog(
          //     context: Get.key.currentContext!,
          //     barrierDismissible: false,
          //     builder: (BuildContext context) => AlertDialog(
          //         title: Text(AppLocalizations.of(Get.key.currentContext!)!
          //             .txt_location_permission),
          //         content: Container(
          //             //  height: 200,
          //             color: Colors.white,
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Container(
          //                     child: Text(
          //                   AppLocalizations.of(Get.key.currentContext!)!
          //                       .txt_permision_setting,
          //                   style: const TextStyle(
          //                       fontSize: 16, fontWeight: FontWeight.w400),
          //                 )),
          //                 InkWell(
          //                   onTap: () async {
          //                     // Get.back();
          //                     FocusManager.instance.primaryFocus?.unfocus();
          //                     await openAppSettings().then((value) async {
          //                       PermissionStatus status =
          //                           await Permission.location.status;
          //                       print("permission status..  $status");
          //                       if (status.isGranted) {
          //                         if (Get.currentRoute == "HomeScreen") {
          //                           var controller = Get.find<HomeController>();
          //                           await controller.getCurrentLocation();
          //                         } else if (Get.currentRoute ==
          //                             "AcceptRideScreen") {
          //                           var controller =
          //                               Get.find<AcceptRideController>();
          //                           await controller.getCurrentLocation();
          //                         }
          //                         // controller.getCurrentLocation();
          //                       }
          //                     });
          //                   },
          //                   child: Container(
          //                       decoration: linearColorDecoration,
          //                       margin: const EdgeInsetsDirectional.only(
          //                           top: 15, bottom: 10),
          //                       padding: const EdgeInsetsDirectional.only(
          //                           start: 55, end: 55, top: 8, bottom: 8),
          //                       child: Text(
          //                           AppLocalizations.of(
          //                                   Get.key.currentContext!)!
          //                               .txt_setting,
          //                           style: const TextStyle(
          //                               fontSize: 16,
          //                               fontWeight: FontWeight.w600,
          //                               color: Colors.white))),
          //                 ),
          //                 InkWell(
          //                     onTap: () {
          //                       Get.back();
          //                       FocusManager.instance.primaryFocus?.unfocus();
          //                       // SystemNavigator.pop();
          //                     },
          //                     child: Container(
          //                       child: Text(
          //                           AppLocalizations.of(
          //                                   Get.key.currentContext!)!
          //                               .txt_exit,
          //                           style: const TextStyle(
          //                             fontSize: 14,
          //                             fontWeight: FontWeight.w600,
          //                           )),
          //                     ))
          //               ],
          //             ))));
        }
      }
    } catch (e) {
      // hideLoader();
      print("Exception -  base.dart - getCurrentPosition():" + e.toString());
    }

    return;
  }
}

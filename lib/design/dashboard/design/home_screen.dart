import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:madr_driver/design/dashboard/controller/home_controller.dart';
import 'package:madr_driver/design/dashboard/design/current_loc_map.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constents/FirebaseNotification.dart';
import '../../../utils/const_color.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/style.dart';
import '../../../utils/location.dart';
import '../../../utils/toast.dart';
import '../../../utils/user_session.dart';
import '../../auth_design/custom_widget/commonbutton.dart';
import '../../settings/controller/profile_controller.dart';
import '../../settings/design/setting_screen.dart';
import '../../settings/model/my_trip_response_model.dart';
import '../../../socket_connection/socket_connection.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var homeController = Get.put(HomeController());
  var profileController = Get.put(ProfileController());
  //var mapController = Get.put(AppMapController());

  FirebaseNotification firebaseMessaging = FirebaseNotification();

  late ScrollController scheduleRideScrollController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    print(" homeprint.. home screen dispose..  ");
  }

  @override
  void deactivate() {
    super.deactivate();
    print(" homeprint.. home screen deatctivate...  ");
  }

  @override
  void initState() {
    super.initState();
    print(" homeprint.. home screen");
    UserSession.isCurrentLoading = homeController.isLoading;

    homeController.isSchedule.value = false;
    scheduleRideScrollController = ScrollController();

    firebaseMessaging.showFlutterNotificationMessage();

    homeController.enable.value =
        UserSession.getBoolFromSession(UserSession.keyOnline) ?? true;
    scheduleRideScrollController.addListener(() {
      if (homeController.isScheduleLoading.value == false) {
        if (scheduleRideScrollController.position.maxScrollExtent ==
            scheduleRideScrollController.offset) {
          print("scheduleRideScrollController.....  ");
          homeController.page = homeController.page + 1;
          homeController.isScheduleLoading.value = true;
          homeController.getScheduleRideList();
        }
      }
    });

    getData();
  }

  DateTime? backBtnPressTime;

  Future<bool> _onLoginBackPressed() async {
    DateTime CurrentTime = DateTime.now();
    bool backButton = backBtnPressTime == null ||
        CurrentTime.difference(backBtnPressTime!) > const Duration(seconds: 3);
    if (backButton) {
      backBtnPressTime = CurrentTime;
      showFlutterToast(
          message:
              AppLocalizations.of(Get.key.currentContext!)!.txt_double_click,
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  Future<void> acceptRequest(int index) async {
    print("in acceptRequest");

    SocketConnection.sendMessage("bookingRequestAccept", {
      "booking_id": homeController.waitingList[index].bookingId,
      "driver_lat": UserSession.getDoubleInSession(UserSession.keyCurrentLat),
      "driver_long": UserSession.getDoubleInSession(UserSession.keyCurrentLng),
    });

    Get.log("in bookingRequestAccept");
    if (Platform.isAndroid) {
      await FlutterCallkitIncoming.endCall(
          homeController.waitingList[index].bookingId!);
    }
    homeController.waitingList.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onLoginBackPressed,
      child: Scaffold(
          backgroundColor: ConstColor.blackcodeTextButtonColor,
          body: Obx(() => ProgressHUD(
                inAsyncCall: homeController.isLoading.value,
                child: SafeArea(
                  child: Stack(
                    children: [
                      Container(
                          child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Obx(() => Visibility(
                              visible: homeController.enable.value,
                              child: const CurrentLocMap())),
                          Obx(
                            () => Visibility(
                              visible: homeController.enable.value == false,
                              child: Container(
                                color: ConstColor.blackColor,
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(Get.key.currentContext!)!
                                      .txt_offline,
                                  style: const TextStyle(
                                      color: ConstColor.accentColor),
                                )),
                              ),
                            ),
                          ),
                          Obx(() => homeController.enable.value == true
                              ? homeController.isLeadVisible.value == true
                                  ? homeController.waitingList.isNotEmpty
                                      ? Container(
                                          height: 550,
                                          alignment: Alignment.bottomCenter,
                                          child: SingleChildScrollView(
                                              child: Column(
                                            children: [draggableViewItem()],
                                          )))

                                      //  ........Schedule ride condition.....
                                      // : homeController.isSchedule.value == true &&
                                      //         homeController.scheduleRideList.value
                                      //                 .length >
                                      //             0
                                      //     ? scheduleRideList()
                                      : Container()
                                  : Container()
                              : Container())
                        ],
                      )),
                      Column(
                        children: [
                          marqueeCondition(),
                          Container(
                            color: Colors.transparent,
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 15, vertical: 10),
                                    child: Row(
                                      children: [
                                        // Obx(
                                        //   () => IconButton(
                                        //       onPressed: () {
                                        //         Helper.verifyInternet()
                                        //             .then((intenet) async {
                                        //           // ignore: unnecessary_null_comparison
                                        //           if (intenet != null &&
                                        //               intenet) {
                                        //             Get.toNamed(
                                        //                 "NotificationScreen");
                                        //           } else {
                                        //             Helper.createSnackBar(
                                        //                 context);
                                        //           }
                                        //         });
                                        //       },
                                        //       icon: Image.asset(
                                        //         AppConstents.notificationBell,
                                        //         color: homeController
                                        //                     .enable.value ==
                                        //                 true
                                        //             ? ConstColor
                                        //                 .blackcodeTextButtonColor
                                        //             : ConstColor.accentColor,
                                        //         height: 30,
                                        //         width: 30,
                                        //       )),
                                        // ),

                                        Obx(
                                          () => CustomSwitch(
                                            value: homeController.enable.value,
                                            onChanged: (bool val) {
                                              homeController.enable.value = val;
                                              UserSession.setBoolInSession(
                                                  UserSession.keyOnline, val);

                                              if (val == true) {
                                                homeController
                                                    .currentBookingList();
                                                SocketConnection.sendMessage(
                                                    "getScheduledRideCount",
                                                    {});
                                              } else {
                                                homeController.waitingList
                                                    .clear();
                                              }
                                              Helper.verifyInternet()
                                                  .then((intenet) async {
                                                // ignore: unnecessary_null_comparison
                                                if (intenet != null &&
                                                    intenet) {
                                                  await homeController
                                                      .driverStatusUpdateRequest();
                                                } else {
                                                  Helper.createSnackBar(
                                                      context);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 10, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 62,
                                          width: 62,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                  left: 6,
                                                  top: 6,
                                                  child: Container(
                                                    height: 55,
                                                    width: 55,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              72),
                                                    ),
                                                  )),
                                              Obx(
                                                () => InkWell(
                                                  onTap: () {
                                                    if (homeController
                                                            .locationSubscription !=
                                                        null) {
                                                      homeController
                                                          .locationSubscription!
                                                          .cancel();
                                                    }
                                                    Navigator.push(
                                                      context,
                                                      SlideRightRoute(
                                                          page:
                                                              const SettingsScreen(),
                                                          animationType:
                                                              "SlideTransition"),
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              72),
                                                      child: Image.network(
                                                          profileController
                                                              .profilePic
                                                              .toString(),
                                                          fit: BoxFit.fill,
                                                          width: 62,
                                                          height: 62,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                        print("");
                                                        return const Icon(
                                                          Icons.account_circle,
                                                          color: ConstColor
                                                              .blackColor,
                                                          size: 67,
                                                        );
                                                      })),
                                                ),
                                              ),
                                              Obx(() => Container(
                                                  transform:
                                                      Matrix4.translationValues(
                                                          5.0, 0.0, 0.0),
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomEnd,
                                                  child: badge(profileController
                                                      .criminalRecord.value
                                                      .toString())))
                                            ],
                                          ),
                                        ),
                                        Obx(() => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: ConstColor
                                                      .ratingStarColor,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  profileController
                                                      .driverAvgRating.value,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        Colors.green.shade900,
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ))
                                // }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => homeController.enable.value == true
                            ? (homeController.isLeadVisible.value == false)
                                ? homeController.isSchedule.value == false
                                    ? Container()
                                    //  Schedule ride condition.....
                                    // ? Container(
                                    //     alignment: Alignment.bottomRight,
                                    //     // padding: EdgeInsetsDirectional.only(top: 10),
                                    //     margin: EdgeInsetsDirectional.only(
                                    //         bottom: 145, end: 12),
                                    //     child: InkWell(
                                    //         onTap: () {
                                    //           // rejectLead();
                                    //           homeController
                                    //               .scheduleRideList.value = [];
                                    //           homeController.page = 1;
                                    //           homeController.isLoading.value =
                                    //               true;
                                    //           homeController
                                    //               .getScheduleRideList();
                                    //         },
                                    //         child: Stack(
                                    //           // mainAxisAlignment: MainAxisAlignment.end,
                                    //           children: [
                                    //             Container(
                                    //               child: Image.asset(
                                    //                 "assets/images/icon_schedule.png",
                                    //                 height: 40,
                                    //                 width: 40,
                                    //                 alignment: Alignment.center,
                                    //               ),
                                    //             ),
                                    //             Positioned(
                                    //               // top: -20,
                                    //               left: 20,
                                    //               // top: -5,
                                    //               child: homeController
                                    //                           .scheduleCount
                                    //                           .value ==
                                    //                       0
                                    //                   ? Container()
                                    //                   : Container(
                                    //                       height: 20,
                                    //                       width: 20,
                                    //                       decoration:
                                    //                           BoxDecoration(
                                    //                         shape:
                                    //                             BoxShape.circle,
                                    //                         color: Color(
                                    //                             0xffF9CB38),
                                    //                         border: Border.all(
                                    //                           color: Color(
                                    //                               0xffF9CB38),
                                    //                           width: 1,
                                    //                         ),
                                    //                       ),
                                    //                       child: Center(
                                    //                         child: Text(
                                    //                           homeController
                                    //                               .scheduleCount
                                    //                               .value
                                    //                               .toString(),
                                    //                           style: TextStyle(
                                    //                               color: Colors
                                    //                                   .white,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .bold,
                                    //                               fontSize: 10),
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //             ),
                                    //           ],
                                    //         )),
                                    //   )
                                    : Container()
                                : Container()
                            : Container(),
                      ),
                      Obx(
                        () => homeController.enable.value == true
                            ? (homeController.isLeadVisible.value == false)
                                ? homeController.isSchedule.value == false
                                    ? Container(
                                        alignment: Alignment.bottomRight,
                                        margin: Platform.isIOS
                                            ? const EdgeInsetsDirectional.only(
                                                bottom: 30, end: 20)
                                            : const EdgeInsetsDirectional.only(
                                                bottom: 100, end: 20),
                                        child: InkWell(
                                          onTap: () async {
                                            if (Platform.isIOS) {
                                              LocationPermission s =
                                                  await Geolocator
                                                      .checkPermission();
                                              print("location permission..   " +
                                                  s.toString());
                                              if (s ==
                                                      LocationPermission
                                                          .denied ||
                                                  s ==
                                                      LocationPermission
                                                          .deniedForever) {
                                                //s = await Geolocator.requestPermission();..
                                                Location.locationPermission();
                                              } else if (s !=
                                                      LocationPermission
                                                          .always ||
                                                  s !=
                                                      LocationPermission
                                                          .whileInUse) {
                                                print('Location Enable home');
                                                homeController
                                                    .fetchCurrentLocation();
                                              }
                                            } else {
                                              Permission.location.isGranted
                                                  .then((value) {
                                                if (value) {
                                                  print('Location enable ' +
                                                      value.toString());
                                                  homeController
                                                      .fetchCurrentLocation();
                                                } else {
                                                  print('Location Disable');
                                                  Location.locationPermission();
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color: ConstColor.accentColor,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              "assets/images/current_location.png",
                                              height: 25,
                                              width: 25,
                                              color: ConstColor
                                                  .blackcodeTextButtonColor,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                                : Container()
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  Future<void> rejectLead(int index) async {
    Get.log("in rejectLead");

    SocketConnection.sendMessage("bookingDeclineByDriver", {
      "booking_id": homeController.waitingList[index].bookingId,
    });

    Get.log("in bookingDeclineByDriver");
    if (Platform.isAndroid) {
      await FlutterCallkitIncoming.endCall(
          homeController.waitingList[index].bookingId!);
    }
    homeController.waitingList.removeAt(index);
    if (homeController.waitingList.length <= 0) {
      homeController.isLeadVisible.value = false;
    }
  }

  badge(String recordType) {
    print("record type..  " + recordType.toString());
    if (recordType == "0") {
      return Image.asset(
        "assets/images/grey_badge.png",
        width: 20,
        height: 20,
      );
    } else if (recordType == "1") {
      return Image.asset(
        "assets/images/green_badge.png",
        width: 20,
        height: 20,
      );
    } else if (recordType == "2") {
      return Image.asset(
        "assets/images/red_badge.png",
        width: 20,
        height: 20,
      );
    } else {
      return Image.asset(
        "assets/images/grey_badge.png",
        width: 20,
        height: 20,
      );
    }
  }

  currentWaitingList() {
    print("currentWaitingList list...   ");
    return Obx(() => homeController.waitingList.isNotEmpty
        ? ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homeController.waitingList.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var data = homeController.waitingList[index];
              return Container(
                padding: const EdgeInsetsDirectional.only(
                    start: 12, end: 12, top: 8, bottom: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (data.rideType == "1" || data.rideType == "0")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(Get.key.currentContext!)!.txt_distance}: ${homeController.waitingList[index].km} ${AppConstents().txtKm}",
                                style: homeSheetDetailTextStyle,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${AppLocalizations.of(Get.key.currentContext!)!.txt_estimate_time}: ${homeController.waitingList[index].time}",
                                style: homeSheetDetailTextStyle,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                  UserSession.getStringFromSession(
                                              UserSession.currencyPosition) ==
                                          "0"
                                      ? "${AppLocalizations.of(Get.key.currentContext!)!.txt_price}: ${UserSession.getStringFromSession(UserSession.currencySymbol)} ${double.parse(homeController.waitingList[index].totalPrice.toString()).toStringAsFixed(2)}"
                                      : "${AppLocalizations.of(Get.key.currentContext!)!.txt_price}: ${double.parse(homeController.waitingList[index].totalPrice.toString()).toStringAsFixed(2)} ${UserSession.getStringFromSession(UserSession.currencySymbol)}",
                                  style: homeSheetDetailTextStyle),
                            ],
                          )
                        else if (data.rideType == "2" || data.rideType == "3")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(Get.key.currentContext!)!.txt_distance}: ${homeController.waitingList[index].km} ${AppConstents().txtKm}",
                                style: homeSheetDetailTextStyle,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${AppLocalizations.of(Get.key.currentContext!)!.txt_estimate_time}: ${homeController.waitingList[index].time!.replaceAll("/", " ")}",
                                style: homeSheetDetailTextStyle,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                  UserSession.getStringFromSession(
                                              UserSession.currencyPosition) ==
                                          "0"
                                      ? "${AppLocalizations.of(Get.key.currentContext!)!.txt_price} ${UserSession.getStringFromSession(UserSession.currencySymbol)} ${homeController.waitingList[index].totalPrice}"
                                      : "${AppLocalizations.of(Get.key.currentContext!)!.txt_price} ${homeController.waitingList[index].totalPrice} ${UserSession.getStringFromSession(UserSession.currencySymbol)}",
                                  style: homeSheetDetailTextStyle),
                            ],
                          ),
                        const Spacer(),
                        Row(
                          children: [
                            Text("${homeController.waitingList[index].name}",
                                style: homeSheetDetailTextStyle),
                            const SizedBox(width: 5),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: (homeController
                                                .waitingList[index].profilePic
                                                .toString() ==
                                            "0" ||
                                        homeController.waitingList[index]
                                                .profilePic ==
                                            null)
                                    ? Image.asset(
                                        "assets/images/userErrImg.png",
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        AppConstents.baseUrl +
                                            homeController
                                                .waitingList[index].profilePic
                                                .toString(),
                                        height: 50,
                                        width: 50,
                                      )),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    pickupDropoffRow(
                        AppConstents.pickupLocationIcon,
                        "${AppLocalizations.of(Get.key.currentContext!)!.txt_from_upr} : ${homeController.waitingList[index].pickupAddress} ",
                        2,
                        pickupDroppHeadingStyle),
                    const SizedBox(height: 8),
                    if (data.rideType == "1" || data.rideType == "0")
                      pickupDropoffRow(
                          AppConstents.dropoffLocationIcon,
                          "${AppLocalizations.of(Get.key.currentContext!)!.txt_to_upr} : ${homeController.waitingList[index].dropAddress}",
                          2,
                          pickupDroppHeadingStyle),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 140,
                          child: GreyButton(
                              onPressed: () {
                                rejectLead(index);
                              },
                              title:
                                  AppLocalizations.of(Get.key.currentContext!)!
                                      .txt_decline),
                        ),
                        SizedBox(
                          width: 140,
                          child: CommonButton(
                              color: ConstColor.codeTextButtonColor,
                              txtStyle: buttonBlackTitle,
                              onPressed: () {
                                acceptRequest(index);
                              },
                              title:
                                  AppLocalizations.of(Get.key.currentContext!)!
                                      .txt_accept),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.white,
              );
            },
          )
        : Container());
  }

  scheduleRideList() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(
              () => homeController.isSchedule.value == true
                  ? Container(
                      margin:
                          const EdgeInsetsDirectional.only(end: 10, bottom: 7),
                      child: InkWell(
                          onTap: () {
                            homeController.page = 1;
                            homeController.isLoading.value = true;
                            homeController.scheduleRideList.value = [];
                            homeController.getScheduleRideList();
                          },
                          child: Stack(
                            children: [
                              Container(
                                child: Image.asset(
                                  "assets/images/icon_schedule.png",
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                ),
                              ),
                              Positioned(
                                  // top: -20,
                                  left: 20,
                                  // top: -5,
                                  child: homeController.scheduleCount.value == 0
                                      ? const SizedBox.shrink()
                                      : Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xffF9CB38),
                                            border: Border.all(
                                              color: const Color(0xffF9CB38),
                                              width: 1,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              homeController.scheduleCount.value
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ))
                            ],
                          )),
                    )
                  : Container(),
            ),
            Obx(() => homeController.isSchedule.value == true
                ? Container(
                    margin: EdgeInsetsDirectional.only(end: 18, bottom: 7),
                    child: InkWell(
                      onTap: () async {
                        if (Platform.isIOS) {
                          LocationPermission s =
                              await Geolocator.checkPermission();
                          print("location permission..   " + s.toString());
                          if (s == LocationPermission.denied ||
                              s == LocationPermission.deniedForever) {
                            //s = await Geolocator.requestPermission();..
                            Location.locationPermission();
                          } else if (s != LocationPermission.always ||
                              s != LocationPermission.whileInUse) {
                            print('Location Enable home');
                            homeController.fetchCurrentLocation();
                          }
                        } else {
                          Permission.location.isGranted.then((value) {
                            print("val Permission.location  $value");
                            if (value) {
                              print('Location Enable mapwidget');
                              homeController.fetchCurrentLocation();
                            } else {
                              print('Location Disable');
                              Location.locationPermission();
                            }
                          });
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: ConstColor.accentColor,
                            borderRadius: BorderRadius.circular(50)),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/current_location.png",
                          height: 25,
                          width: 25,
                          color: ConstColor.blackcodeTextButtonColor,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  )
                : Container()),
          ],
        ),
        Stack(
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: bottomSheetDecoration,
              padding: EdgeInsetsDirectional.only(top: 24),
              child: SingleChildScrollView(
                controller: scheduleRideScrollController,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsetsDirectional.only(
                            start: 40, end: 22, bottom: 3),
                        child: Text(
                          AppConstents().ScheduleRide,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: ConstColor.accentColor,
                              fontSize: 18,
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                          child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: homeController.scheduleRideList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = homeController.scheduleRideList[index];
                          print("data index..   ${data.toJson()}");
                          return Container(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 22, end: 22, top: 8, bottom: 10),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Column(children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Image.asset(
                                                      AppConstents
                                                          .pickupLocationIcon,
                                                      height: 14,
                                                      width: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        data.pickupAddress
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        style:
                                                            formHeadingStyle),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                                child: Text(
                                                    data.scheduledDate == null
                                                        ? ""
                                                        : dateTime(data),
                                                    style: formHeadingStyle))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Image.asset(
                                                      AppConstents
                                                          .dropoffLocationIcon,
                                                      height: 14,
                                                      width: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        data.dropAddress
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        style:
                                                            formHeadingStyle),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                                child: Text(
                                                    AppLocalizations.of(Get.key
                                                                .currentContext!)!
                                                            .txt_price +
                                                        " € ${data.totalPrice}",
                                                    style: formHeadingStyle))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: 140,
                                              child: CommonButton(
                                                  onPressed: () {
                                                    //acceptRequest();
                                                    homeController.acceptRide(
                                                        data.sId.toString(),
                                                        index);
                                                  },
                                                  title: AppLocalizations.of(Get
                                                          .key.currentContext!)!
                                                      .txt_accept),
                                            ),
                                            SizedBox(
                                              width: 140,
                                              child: GreyButton(
                                                  onPressed: () {
                                                    homeController
                                                        .scheduleRideList
                                                        .removeAt(index);

                                                    SocketConnection.sendMessage(
                                                        "getScheduledRideCount",
                                                        {});

                                                    if (homeController
                                                            .scheduleRideList
                                                            .length <=
                                                        0) {
                                                      homeController
                                                          .isLeadVisible
                                                          .value = false;
                                                      homeController.isSchedule
                                                          .value = false;
                                                    }
                                                  },
                                                  title: AppLocalizations.of(Get
                                                          .key.currentContext!)!
                                                      .txt_decline),
                                            ),
                                          ],
                                        )
                                      ]),
                                    )
                                  ]));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            color: Colors.white,
                          );
                        },
                      ))
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                homeController.isSchedule.value = false;
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                    height: 22,
                    // height: 18,
                    width: 22,
                    transform: Matrix4.translationValues(-10.0, -10.0, 0.0),
                    child: const Icon(
                      Icons.cancel_rounded,
                      color: Colors.red,
                    )),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  String dateTime(BookingList data) {
    print("data.scheduledDate... " + data.scheduledDate.toString());
    final dateUS = DateTime.parse(data.scheduledDate.toString()).toLocal();
    var date = DateFormat('MMMM dd, yyyy HH:mm').format(dateUS);
    print("date time...   " + date.toString());
    return date;
  }

  draggableViewItem() {
    print("draggable list...   ");
    return Obx(() => Container(
        alignment: Alignment.bottomCenter,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  homeController.isLeadVisible.value == true
                      ? Container(
                          margin: const EdgeInsetsDirectional.only(
                              end: 18, bottom: 7),
                          child: InkWell(
                            onTap: () async {
                              if (Platform.isIOS) {
                                LocationPermission s =
                                    await Geolocator.checkPermission();
                                print(
                                    "location permission..   " + s.toString());
                                if (s == LocationPermission.denied ||
                                    s == LocationPermission.deniedForever) {
                                  //s = await Geolocator.requestPermission();..
                                  Location.locationPermission();
                                } else if (s != LocationPermission.always ||
                                    s != LocationPermission.whileInUse) {
                                  print('Location Enable home');
                                  homeController.fetchCurrentLocation();
                                }
                              } else {
                                Permission.location.isGranted.then((value) {
                                  if (value) {
                                    homeController.fetchCurrentLocation();
                                  } else {
                                    Location.locationPermission();
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: ConstColor.accentColor,
                                  borderRadius: BorderRadius.circular(50)),
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/images/current_location.png",
                                height: 25,
                                width: 25,
                                color: ConstColor.blackcodeTextButtonColor,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
              Container(
                // height: 400,
                alignment: AlignmentDirectional.bottomStart,
                color: Colors.transparent,
                child: Container(
                  decoration: bottomSheetDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //  mainAxisSize:
                    //    MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          width: 72,
                          height: 3,
                          decoration: BoxDecoration(
                              color: ConstColor.bottomSheetLineColor,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12),
                          child: currentWaitingList()),
                    ],
                  ),
                ),
              )
            ])));
  }

  getData() {
    homeController.currentBookingList();
    profileController.getProfileRequest();
  }

  marqueeCondition() {
    print(
        "UserSession.getStringFromSession(UserSession.keyUserStatus)..    ${profileController.driverStatus.value}");
    if (profileController.driverStatus.value == "0") {
      return Container(
          color: Colors.red,
          height: 25,
          alignment: AlignmentDirectional.center,
          // margin: const EdgeInsetsDirectional.only(
          //     top: 10, bottom: 10),
          child: Marquee(
            text: AppConstents().txtDeactivateDriverMarquee,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
            scrollAxis: Axis.horizontal, //scroll direction
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: 20.0,
            velocity: 50.0, //speed
            pauseAfterRound: Duration(seconds: 1),
            startPadding: 10.0,
            accelerationDuration: Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ));
    } else if (profileController.driverStatus.value == "2") {
      return Container(
          color: Colors.red,
          height: 25,
          alignment: AlignmentDirectional.center,
          // margin: const EdgeInsetsDirectional.only(
          //     top: 10, bottom: 10),
          child: Marquee(
            text: AppConstents().txtAccountDeactivated,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
            scrollAxis: Axis.horizontal, //scroll direction
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: 20.0,
            velocity: 50.0, //speed
            pauseAfterRound: Duration(seconds: 1),
            startPadding: 10.0,
            accelerationDuration: Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ));
    } else {
      return Container();
    }
  }
}

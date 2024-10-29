import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:madr_driver/constents/package_extend.dart';
import 'package:madr_driver/constents/socketConnectionDialog.dart';
import 'package:madr_driver/design/auth_design/custom_widget/commonbutton.dart';
import 'package:madr_driver/design/dashboard/controller/accept_ride_controller.dart';
import 'package:madr_driver/design/dashboard/controller/home_controller.dart';
import 'package:madr_driver/design/dashboard/model/booking_info.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../Chat/inbox_controller.dart';
import '../utils/app_constents.dart';
import '../utils/user_session.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SocketConnection {
  static Socket? socket;
  //static dynamic rideComletedData;
  // static bool isSocketRequested = false;

  static var homeController = Get.put(HomeController());
  // static var requestData = {}.obs;

//   showCallkitIncoming(String uuid) async {
//   final params = CallKitParams(
//     id: uuid,
//     nameCaller: "New Request from : "+requestData['bookingData']['name'],
//     appName: "madr DriverApp",
//     avatar: AppConstents.baseUrl+requestData['bookingData']['profile_pic'],
//     handle: requestData['bookingData']['booking_id'],
//     type: 0,
//     duration: 100000,
//     textAccept: 'Accept',
//     textDecline: 'Decline',
//     // missedCallNotification: const NotificationParams(
//     //   showNotification: true,
//     //   isShowCallback: true,
//     //   subtitle: 'Missed call',
//     //   callbackText: 'Call back',
//     // ),
//     extra: <String, dynamic>{'userId': requestData['bookingData']['booking_id']},
//     headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
//     android: const AndroidParams(
//       isCustomNotification: true,
//       isShowLogo: false,
//       ringtonePath: 'system_ringtone_default',
//       backgroundColor: '#0955fa',
//       backgroundUrl: 'assets/test.png',
//       actionColor: '#4CAF50',
//       textColor: '#ffffff',
//     ),
//     ios: const IOSParams(
//       iconName: 'CallKitLogo',
//       handleType: '',
//       supportsVideo: true,
//       maximumCallGroups: 1,
//       maximumCallsPerCallGroup: 1,
//       audioSessionMode: 'default',
//       audioSessionActive: true,
//       audioSessionPreferredSampleRate: 44100.0,
//       audioSessionPreferredIOBufferDuration: 0.005,
//       supportsDTMF: true,
//       supportsHolding: true,
//       supportsGrouping: false,
//       supportsUngrouping: false,
//       ringtonePath: 'system_ringtone_default',
//     ),
//   );
//   await FlutterCallkitIncoming.showCallkitIncoming(params);
// }

  setupEventListeners() {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      print("call kit event  ..  " + event!.body.toString());
      switch (event.event) {
        case Event.actionCallAccept:
          // Handle call accept
          requestAcceptKit(event.body['id']);
          break;
        case Event.actionCallDecline:
          // Handle call decline
          requestDeclineKit(event.body['id']);
          break;
        case Event.actionCallEnded:
        default:
          break;
      }
    });
  }

  requestAcceptKit(bookingId) {
    SocketConnection.sendMessage("bookingRequestAccept", {
      "booking_id": bookingId,
      "driver_lat": UserSession.getDoubleInSession(UserSession.keyCurrentLat),
      "driver_long": UserSession.getDoubleInSession(UserSession.keyCurrentLng),
    });
    Get.log("in bookingRequestAccept");
    homeController.waitingList.removeWhere(
        (element) => element.bookingId?.contains(bookingId) ?? false);
  }

  requestDeclineKit(bookingId) {
    Get.log("in rejectLead");

    SocketConnection.sendMessage(
        "bookingDeclineByDriver", {"booking_id": bookingId});

    Get.log("in bookingDeclineByDriver");
    homeController.waitingList.removeWhere(
        (element) => element.bookingId?.contains(bookingId) ?? false);

    if (homeController.waitingList.length <= 0) {
      homeController.isLeadVisible.value = false;
    }
  }

  static connectToServer() {
    // print("connect to server . main.  $socket  ");
    print(
        "connect to server . main.  ${UserSession.getBoolFromSession(UserSession.keyIsLoggedIn)}  ");
    if (UserSession.getBoolFromSession(UserSession.keyIsLoggedIn) == true) {
      if (socket != null) {
        if (socket!.connected == false) {
          socket = io(AppConstents.socketBaseUrl, <String, dynamic>{
            'transports': ['websocket'],
            'autoConnect': false,
            'query': {
              'token':
                  UserSession.getStringFromSession(UserSession.keyUserToken)
            }
          });
          //isSocketRequested = true;
          socket!.connect();

          print(
              "socket connection calling .. main   ${socket!.connected}    ${socket!.id}");
        } else {
          print('connected id : ${socket!.id}');
        }
      } else {
        socket = io(AppConstents.socketBaseUrl, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
          'query': {
            'token': UserSession.getStringFromSession(UserSession.keyUserToken)
          }
        });
        // isSocketRequested = true;
        socket!.connect();

        print(
            "socket connection calling ..  main  ${socket!.connected}   ${socket!.id} ");
      }
    }

    socket!.on('connect', (_) {
      print('connect connect : ${socket!.id}');
    });

    socket!.on("newRequest", (textData) async {
      print(">>>>>>>>> newRequest .. >>>>>>>>.$textData");
      var rest = json.encode(textData);
      print("current booking newRequest...   $rest");
      var restdecode = json.decode(rest);
      // requestData.value = restdecode;
      log("current booking newRequest...   $restdecode");
      log(" homeController.waitingList..    ${homeController.waitingList.length}");

      homeController.updateNewRequest(restdecode['bookingData']);
    });

    socket!.on("bookingAccepted", (data) {
      print("bookingAccepted $data");
      // showFlutterToast(message: "Booking Accepted");

      var rest = json.encode(data);
      var restDecode = json.decode(rest);
      BookingInfo bookingInfoList = BookingInfo.fromJson(restDecode);
      print("booking accept..   " +
          bookingInfoList.bookingData!.pickupLat.toString());
      UserSession.setIntInSession(UserSession.keyCurrentBookingStatus, 1);
      //Get.delete<HomeController>();
      homeController.locationSubscription!.cancel();
      homeController.homeMapController.dispose();
      // Future.delayed(Duration(seconds: 8), () {
      Get.offAndToNamed("AcceptRideScreen", arguments: bookingInfoList);

      // });
    });

    socket!.on("packageExpired", (data) async {
      print("packageExpired,,  .. $data");
      if (Get.isDialogOpen ?? false) {
      } else {
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: const PackageExtend(isKm: true),
          ),
        );
      }
    });
    socket!.on('disconnect', (_) {
      print('disconnect null: ${socket!.id}');
      socket!.disconnect();
      Future.delayed(const Duration(seconds: 2), () {
        Helper.verifyInternet().then((intenet) async {
          // ignore: unnecessary_null_comparison
          print("internet at socket..  $intenet");
          if (intenet) {
            print("  Get.isDialogOpen .. ${Get.isDialogOpen}");
            if (Get.isDialogOpen == false) {
              if (UserSession.getBoolFromSession(UserSession.keyIsLoggedIn) ==
                  true) {
                print("socket connection class socket connection dialog...  ");
                Get.dialog(WillPopScope(
                    onWillPop: () async => false,
                    child: SocketConnectionDialog()));
              }
            } else {}
          }
        });
      });
    });

    socket!.on("bookingCancel", (data) async {
      print("booking cancel..  ${socket!.id}");
      print("booking cancel.. data    ${data["booking_id"]}");
      if (Platform.isAndroid) {
        await FlutterCallkitIncoming.endCall(data["booking_id"]);
      }
      // showFlutterToast(message: "Booking Cancelled");
      if (Get.currentRoute == "AcceptRideScreen" ||
          UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus) !=
              0) {
        print("booking cancel.. data 111   ${data["booking_id"]}");
        if (homeController.waitingList.isNotEmpty) {
          print("booking cancel.. data 222   ${data["booking_id"]}");
          homeController.waitingList
              .removeWhere((item) => item.bookingId == data["booking_id"]);
          if (homeController.waitingList.isEmpty) {
            homeController.isLeadVisible.value = false;
          }
        }
        print("booking cancel.. data  33  ${data["booking_id"]}");
        if (UserSession.getStringFromSession(UserSession.keyCurrentBookingId) ==
            data["booking_id"]) {
          UserSession.setIntInSession(UserSession.keyCurrentBookingStatus, 0);

          Get.offAllNamed("HomeScreen");
        }
      } else {
        print("booking cancel.. data 44   ${data["booking_id"]}");
        if (homeController.waitingList.isNotEmpty) {
          homeController.waitingList
              .removeWhere((item) => item.bookingId == data["booking_id"]);
          if (homeController.waitingList.isEmpty) {
            homeController.isLeadVisible.value = false;
          }
        } else {
          print("booking cancel.. data 55   ${data["booking_id"]}");
        }
      }
    });

    socket!.on("acceptedByAnotherDriver", (data) async {
      print("acceptedByAnotherDriver");
      if (Platform.isAndroid) {
        await FlutterCallkitIncoming.endCall(data["booking_id"]);
      }
      homeController.waitingList
          .removeWhere((item) => item.bookingId == data["booking_id"]);
      if (homeController.waitingList.length == 0) {
        homeController.isLeadVisible.value = false;
      }
    });

    SocketConnection.socket!.on('updatedExtendedBookingInfo', (data) {
      print("AHFIKHUHFOI $data");
      var acceptRideController = Get.find<AcceptRideController>();
      if (data['extendType'].toString() == "0") {
        acceptRideController.updateNotify(0);
        print(
            "update booking id.. ${acceptRideController.data.bookingData!.bookingId}");
        acceptRideController.data.reactive.update((value) {
          value?.bookingData!.km = data['km'].toString();
          value?.bookingData!.time = data['time'].toString();
          value?.bookingData!.totalPrice = data['total_price'].toString();
          print("update booking id..11 ${value!.bookingData!.bookingId}");
        });

        showFlutterToast(message: AppConstents().txtRenewedPackage);
        print(
            "update booking id.. ${acceptRideController.data.bookingData!.bookingId}");
      } else {
        showFlutterToast(message: AppConstents().txtBearPerKm);
      }
      print("Get.isDialogOpen...   ${Get.isDialogOpen}");
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    });

    SocketConnection.socket!.on("paymentReceived", (data) {
      print("in paymentReceived listner $data");
      var acceptRideController = Get.find<AcceptRideController>();
      UserSession.setIntInSession(UserSession.keyCurrentBookingStatus, 0);
      // var controller = Get.find<AcceptRideController>();
      acceptRideController.startLocation.value = null;
      acceptRideController.endLocation.value = null;
      acceptRideController.polylines.value = {};
      acceptRideController.markers.value = {};
      acceptRideController.locationSubscription?.cancel();
      acceptRideController.mapController.dispose();
      // acceptRideController.onRejectLead();
      Get.offAndToNamed("RideCompletedScreen", arguments: data);
    });

    SocketConnection.socket!.on('cancelBookingByDriver', (data) async {
      print("data get $data");
      var acceptRideController = Get.find<AcceptRideController>();
      UserSession.setIntInSession(UserSession.keyCurrentBookingStatus, 0);
      acceptRideController.locationSubscription?.cancel();
      //controller.onRejectLead();
      Get.offNamedUntil("HomeScreen", ModalRoute.withName('HomeScreen'));
    });

    SocketConnection.socket!.on("chat_count", (data) async {
      print("chat_count ..call  $data");
      var acceptRideController = Get.find<AcceptRideController>();
      if (Get.currentRoute == "AcceptRideScreen") {
        if (Get.currentRoute == "InboxScreen") {
          acceptRideController.chatCount.value = 0;
        } else {
          acceptRideController.chatCount.value = data['count'];
        }
      }
    });

    SocketConnection.socket!.on("verifyOtpCallback", (responseData) {
      print(">>>>>>>>>>>>>>>>>:::::::::::::::::::::$responseData");
      var acceptRideController = Get.find<AcceptRideController>();
      if (responseData['succeeded'] == true) {
        acceptRideController.rideStatus.value = 2;
        UserSession.setIntInSession(UserSession.keyCurrentBookingStatus, 2);
        acceptRideController.locationIntialization();
        Future.delayed(Duration(seconds: 5), () {
          acceptRideController.locationSubscription?.resume();
        });

        acceptRideController.KmPreviousLocation.value =
            acceptRideController.wayLocation.value;
      } else {
        showFlutterToast(
            message:
                AppLocalizations.of(Get.key.currentContext!)!.val_valid_otp);
      }
    });

    SocketConnection.socket!.on("bookingDone", (endBookingData) {
      print("=--=-=>> bookingDone data $endBookingData");
      var acceptRideController = Get.find<AcceptRideController>();
      if (Get.currentRoute == "AcceptRideScreen") {
        acceptRideController.rideStatus.value = 3;

        acceptRideController.clearCache();
        UserSession.setIntInSession(UserSession.keyCurrentBookingStatus, 3);
        var rest = json.encode(endBookingData);
        var restDecode = json.decode(rest);
        print(" bookingData total_price " +
            restDecode['bookingData']['total_price'].toString());
        //data.up
        acceptRideController.totalPrice.value =
            double.parse(restDecode['bookingData']['total_price'].toString());
      }
    });

    SocketConnection.socket!.on("waiting_time_start", (data) async {
      print("data.. waiting time ..  " + data.toString());
      var acceptRideController = Get.find<AcceptRideController>();
      if (Get.currentRoute == "AcceptRideScreen") {
        if (data['booking_id'] ==
            acceptRideController.data.bookingData!.bookingId) {
          acceptRideController.rideStatus.value = 1;
          acceptRideController.waitUser.value = 1;
        }
      }
    });

    socket!.on("scheduledRideCount", (data) async {
      print("schedul count ..  $data");
      log("scheduledRideCount ..  $data   ${data["count"]}");
      homeController.scheduleCount.value = data["count"];
    });

    socket!.on("recieved_message", (data) async {
      print("recieved_message ..call  ${data}");
      if (Get.currentRoute == "InboxScreen") {
        var localData = await json.decode(data);
        var inboxController = Get.find<InboxController>();
        inboxController.receiveMsg(data);
        sendMessage("message_read", {"chat_id": localData["_id"]});
      }
    });

    socket!.on("payment_confirmation", (data) {
      print("payment_confirmation..  " + data.toString());
      if (UserSession.getStringFromSession(UserSession.keyCurrentBookingId) ==
          data["_id"]) {
        print("..    Get.isDialogOpen..   " + Get.isDialogOpen.toString());
        if (Get.isDialogOpen ?? false) {
        } else {
          Get.dialog(
            WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  contentPadding: EdgeInsets.all(15.0),
                  actionsPadding: EdgeInsets.all(15),
                  title: Text(
                    AppConstents().txtCashReceived,
                  ),
                  //content: Text('This is a dialog.'),
                  actions: [
                    CommonButton(
                      width: 65,
                      // txtStyle: loginStyle,
                      onPressed: () {
                        Get.back(); // Close the dialog
                      },
                      title: AppConstents().txtNo,
                    ),
                    CommonButton(
                      width: 65,
                      // txtStyle: loginStyle,
                      onPressed: () {
                        Get.back();
                        SocketConnection.sendMessage("booking_payment", {
                          "booking_id": data["_id"],
                          "payment_method": "Cash",
                          "payment_mode": "Cash",
                          "transaction_id": "0"
                        });
                      },
                      title: AppConstents().txtYes,
                    ),
                  ],
                )),
          );
        }
      }
    });
  }

  static void sendMessage(String event, var data) {
    log(" connect send msg ..  ${socket!.connected}   $event");
    log(" connect send msg ..  ${socket}   $event");
    print(" connect send  " +
        UserSession.getBoolFromSession(UserSession.isDialogOpen).toString());

    if (UserSession.getBoolFromSession(UserSession.isDialogOpen) == false) {
      if (socket!.connected == true) {
        socket!.emit(event, data);
      } else {
        // connectToServer();
        // socket!.emit(event, data);
      }
    }
    // Helper.verifyInternet().then((intenet) async {
    //   // ignore: unnecessary_null_comparison
    //   print("internet at socket..  $intenet");
    //   if (intenet) {
    //     try {
    //       if (socket!.connected == true) {
    //         socket!.emit(event, data);
    //       } else {
    //         NetworkServices networkServices = NetworkServices();
    //         var response = await networkServices.getProfileCall();
    //         print("response server..    " + response.responseCode.toString());
    //         //showFlutterToast(message: AppConstents().txtServerNotCon);
    //         print("Get.currentRoute...   " + Get.currentRoute.toString());
    //         //if (Get.currentRoute == "") {}
    //         connectToServer();
    //         socket!.emit(event, data);
    //       }
    //     } catch (e) {
    //       print("response server.  exp..  " + e.toString());
    //     }
    //   }
    // });
  }
}

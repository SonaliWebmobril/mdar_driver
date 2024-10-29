import 'dart:developer';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:madr_driver/design/settings/controller/profile_controller.dart';
import 'package:madr_driver/design/settings/controller/wallet_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:madr_driver/socket_connection/socket_connection.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../design/dashboard/controller/home_controller.dart';
import '../utils/user_session.dart';

class FirebaseNotification {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  HomeController homeController = HomeController();
  var profileController = Get.put(ProfileController());

  Future<void> showFlutterNotificationMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', //id
        'High Importance Notifications', // title
        playSound: true,
        importance: Importance.high);

    const settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settingsIOS = DarwinInitializationSettings(
      // onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: settingsAndroid,
      iOS: settingsIOS,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          "FirebaseMessaging.onMessage.listen 11  ${message.data['status'].toString()}");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? apple = message.notification?.apple;
      print("notification..   " + notification.toString());
      print("notification..   " + android.toString());
      print("notification..   " + apple.toString());
      if (notification != null && android != null) {
        if (message.data['status'] == null) {
          if (message.data['user_status'] != null) {
            if (message.data['user_status'] == "0") {
              UserSession.setStringInSession(UserSession.keyUserStatus, "0");
              profileController.driverStatus.value = "0";
            } else if (message.data['user_status'] == "1") {
              UserSession.setStringInSession(UserSession.keyUserStatus, "1");
              profileController.driverStatus.value = "1";
            } else if (message.data['user_status'] == "2") {
              UserSession.setStringInSession(UserSession.keyUserStatus, "2");
              profileController.driverStatus.value = "2";
            }
          } else if (message.data['wallet_status'] != null) {
            if (message.data['wallet_status'] == "1") {
              if (Get.currentRoute == "WalletScreen") {
                var walletController = Get.find<WalletController>();
                walletController.getList();
              }
            }
          }
        } else {
          print("status status..  " + message.data['status'].toString());
          if (message.data['status'] == "1") {
            print("status 0..  ");
            await homeController.BookingStatus();

            Permission.location.isGranted.then((value) {
              print("val Permission.location  $value");
              if (value) {
                print('Location Enable mapwidget');
              } else {
                print('Location Disable');
              }
            });
          } else if (message.data['status'] == "4") {
          } else if (message.data['status'] == "11") {
          } else if (message.data['status'] == "0") {
            var devicePushTokenVoIP =
                await FlutterCallkitIncoming.getDevicePushTokenVoIP();
            print("devicePushTokenVoIP .   " + devicePushTokenVoIP);
            showCallkitIncoming(
                message.data['booking_id'],
                message.data['booking_id'],
                message.data['name'],
                message.data['profile_pic']);
          }
        }

        if (message.data['delete'] != null) {
          if (message.data['delete'] == "1") {
            showAdminDeleteDialog();
          }
        }
        if (message.data['status'] != null) {
          if (message.data['status'] == "-10") {
            await FlutterCallkitIncoming.endCall(message.data["booking_id"]);
          } else {}
        }

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: const Color(0xff000000),
                playSound: true,
                icon: '@mipmap/ic_launcher',
                largeIcon: const DrawableResourceAndroidBitmap(
                    '@drawable/launch_background'),
              ),
              // iOS: DarwinNotificationDetails(),
            ),
            payload: message.data['status'].toString());

        // await flutterLocalNotificationsPlugin.initialize(
        //   initializationSettings,
        //   onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
        // );
      } else if (notification != null && apple != null) {
        print("apple notification..   " +
            message.data.toString() +
            "    " +
            message.notification.toString());
        if (message.data['status'] == null) {
          if (message.data['user_status'] != null) {
            if (message.data['user_status'] == "0") {
              UserSession.setStringInSession(UserSession.keyUserStatus, "0");
              profileController.driverStatus.value = "0";
            } else if (message.data['user_status'] == "1") {
              UserSession.setStringInSession(UserSession.keyUserStatus, "1");
              profileController.driverStatus.value = "1";
            } else if (message.data['user_status'] == "2") {
              UserSession.setStringInSession(UserSession.keyUserStatus, "2");
              profileController.driverStatus.value = "2";
            }
          } else if (message.data['wallet_status'] != null) {
            if (message.data['wallet_status'] == "1") {
              if (Get.currentRoute == "WalletScreen") {
                var walletController = Get.find<WalletController>();
                walletController.getList();
              }
            }
          }
        } else {
          if (message.data['status'] == "1") {
            print("status 0..  " + message.data['status'].toString());

            await homeController.BookingStatus();

            Permission.location.isGranted.then((value) {
              print("val Permission.location  $value");
              if (value) {
                print('Location Enable mapwidget');
              } else {
                print('Location Disable');
              }
            });
          } else if (message.data['status'] == "4") {
          } else if (message.data['status'] == "11") {}
          //  else if(message.data['status'] == "0"){
          //  var devicePushTokenVoIP = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
          //  print("devicePushTokenVoIP .   " +devicePushTokenVoIP);
          //   showCallkitIncoming(message.data['booking_id'], message.data['booking_id'], message.data['name'], message.data['profile_pic']);
          // }
        }

        if (message.data['delete'] != null) {
          if (message.data['delete'] == "1") {
            showAdminDeleteDialog();
          }
        }

        // flutterLocalNotificationsPlugin.show(
        //     notification.hashCode,
        //     notification.title,
        //     notification.body,
        //     NotificationDetails(
        //       iOS: DarwinNotificationDetails(),
        //     ),
        //     payload: message.data['status'].toString());

        // await flutterLocalNotificationsPlugin.initialize(
        //   initializationSettings,
        //   onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
        // );
      }

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    _handlePayload(id, payload);
  }

  void _onDidReceiveNotificationResponse(NotificationResponse details) {
    print(
        "notification response...   ${details.notificationResponseType.name}");
    print("notification response...   ${details.id}");
    print("notification response...   ${details.payload}");
    print(
        "notification response...   ${details.notificationResponseType.name}");

    print("  islogin,,   " +
        UserSession.getBoolFromSession(UserSession.keyIsLoggedIn).toString());

    if (UserSession.getBoolFromSession(UserSession.keyIsLoggedIn) == true) {
      _handlePayload(details.id ?? -1, details.payload);
    }
  }

  _handlePayload(int notificationId, String? payload) async {
    if (payload != null) {
      print('received empty payload' + payload.toString());

      if (payload == '0') {
        //- New Request
        log("status 0..  ");

        await homeController.BookingStatus();

        Permission.location.isGranted.then((value) {
          print("val Permission.location  " + value.toString());
          if (value) {
            print('Location Enable mapwidget');
          } else {
            print('Location Disable');
          }
        });
      } else if (payload == '-2') {
        //- New Request
        log("status 0..  ");
        await homeController.BookingStatus();
        Permission.location.isGranted.then((value) {
          print("val Permission.location  " + value.toString());
          if (value) {
            print('Location Enable mapwidget');
          } else {
            print('Location Disable');
          }
        });
      } else if (payload == '-1') {
        //- Cancel Booking
        print("status -1 ..  ");
        log("status 0..  ");

        await homeController.BookingStatus();

        Permission.location.isGranted.then((value) {
          print("val Permission.location  " + value.toString());
          if (value) {
            print('Location Enable mapwidget');
          } else {
            print('Location Disable');
          }
        });
      } else if (payload == '1') {
      } else if (payload == '2') {
        //- scheduled-ride
        log("status 0..  ");

        await homeController.BookingStatus();
        Permission.location.isGranted.then((value) {
          print("val Permission.location  $value");
          if (value) {
            print('Location Enable mapwidget');
          } else {
            print('Location Disable');
          }
        });
      } else if (payload == '3') {
      } else if (payload == '4') {
        await homeController.BookingStatus();

        Permission.location.isGranted.then((value) {
          print("val Permission.location  $value");
          if (value) {
            // Get.back();22
            print('Location Enable mapwidget');
          } else {
            print('Location Disable');
          }
        });
      } else if (payload == '5') {
      } else if (payload == '6') {
      } else if (payload == "11") {
      } else {
        print("FirebaseMessaging onMessageOpenedApp");
        // if (message.data['type'] == 'chat') {
        Get.toNamed("NotificationScreen");
      }
      return;
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    log('A bg msg : $message.messageId');
  }

  _handleMessage(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    log(" FirebaseMessaging onMessageOpenedApp");
    if (notification != null && android != null) {
      print("notification..   " + notification.toString());
      print("message...  " + message.data['status']);

      if (message.data['status'] == '0') {
        //- New Request
        log("status 0..  ");

        await homeController.BookingStatus();

        Permission.location.isGranted.then((value) {
          print("val Permission.location  " + value.toString());
          if (value) {
            print('Location Enable mapwidget');
          } else {
            print('Location Disable');
          }
        });
      } else if (message.data['status'] == '-2') {
      } else if (message.data['status'] == '-1') {
        //- Cancel Booking
        print("status -1 ..  ");
        log("status 0..  ");

        await homeController.BookingStatus();

        Permission.location.isGranted.then((value) {
          print("val Permission.location  " + value.toString());
          if (value) {
            // Get.back();
            print('Location Enable mapwidget');
          } else {
            print('Location Disable');
          }
        });
      } else if (message.data['status'] == '1') {
      } else if (message.data['status'] == '2') {
        //- scheduled-ride
        log("status 0..  ");

        await homeController.BookingStatus();

        Permission.location.isGranted.then((value) {
          print("val Permission.location  " + value.toString());
          if (value) {
            // Get.back();
            print('Location Enable mapwidget');
          } else {
            print('Location Disable');
          }
        });
      } else if (message.data['status'] == '3') {
      } else if (message.data['status'] == '4') {
        //- Booking Complete & payment recived
      } else if (message.data['status'] == '5') {
      } else if (message.data['status'] == '6') {}
    }
  }

  showCallkitIncoming(String uuid, bookingid, username, profile) async {
    final params = CallKitParams(
      id: uuid,
      nameCaller: "${AppConstents().txtNewRequestFrom} : " + username,
      appName: "madr DriverApp",
      avatar: AppConstents.baseUrl + profile,
      handle: bookingid,
      type: 0,
      duration: 100000,
      textAccept: AppLocalizations.of(Get.key.currentContext!)!.txt_accept,
      textDecline: AppLocalizations.of(Get.key.currentContext!)!.txt_decline,
      // missedCallNotification: const NotificationParams(
      //   showNotification: true,
      //   isShowCallback: true,
      //   subtitle: 'Missed call',
      //   callbackText: 'Call back',
      // ),
      extra: <String, dynamic>{'userId': bookingid},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: 'assets/test.png',
          actionColor: '#4CAF50',
          textColor: '#ffffff',
          isShowFullLockedScreen: true),
      ios: const IOSParams(
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 10,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  showAdminDeleteDialog() {
    print("show dialog..  ");
    return Get.dialog(
      barrierDismissible: false,
      WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(AppConstents().txtUnauthorizeLogin),
            content: Text(AppConstents().txtAdminDelete),
            actions: [
              TextButton(
                onPressed: () async {
                  await UserSession.clearSession();
                  SocketConnection.socket?.disconnect();
                  SocketConnection.socket?.dispose();
                  Get.offNamedUntil("LoginScreen", (route) => false);
                },
                child:
                    Text(AppLocalizations.of(Get.key.currentContext!)!.txt_ok),
              ),
            ],
          )),
    );
  }
}

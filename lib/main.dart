import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:madr_driver/routes.dart';
import 'package:madr_driver/socket_connection/socket_connection.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/user_session.dart';
import 'constents/BroadcastData.dart';
import 'design/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/l10n.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  await UserSession.init();
  FlutterError.onError = (errorDetails) {
    // If you wish to record a "non-fatal" exception, please use `FirebaseCrashlytics.instance.recordFlutterError` instead
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SocketConnection().setupEventListeners();
  FBroadcast.instance().register("network", (value, callback) {
    print("network value...   $value");
    BroadcastData().data(value);
  });
  // if (Platform.isAndroid) {
  //   await GoogleMapsFlutterAndroid()
  //       .initializeWithRenderer(AndroidMapRenderer.latest);
  // }
  //Get.lazyPut( ()=> AppMapController());
//  Get.lazyPut<AppMapController>(() => AppMapController());
  UserSession.setBoolInSession(UserSession.isDialogOpen, false);
//  ChuckerFlutter.showOnRelease = true;
  // await Upgrader.clearSavedSettings();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Platform.isAndroid) {
    await UserSession.init();
    await Firebase.initializeApp();
    if (message.data['status'] == '0') {
      // var devicePushTokenVoIP = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
      print("devicePushTokenVoIP .   ${message.data}");
      showCallkitIncoming(
          message.data['booking_id'],
          message.data['booking_id'],
          message.data['name'],
          message.data['profile_pic']);
    }
  }
}

showCallkitIncoming(String uuid, bookingid, username, profile) async {
  final params = CallKitParams(
    id: uuid,
    nameCaller: getCallerName(username),
    appName: "madr DriverApp",
    avatar: AppConstents.baseUrl + profile,
    handle: bookingid,
    type: 0,
    duration: 100000,
    textAccept: getAcceptVal(),
    textDecline: getRejectVal(),
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
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 1,
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

String getCallerName(username) {
  print(" keyLocalLng ${UserSession.getLng(UserSession.keyLocalLng)}");
  if (UserSession.getLng(UserSession.keyLocalLng) == "en") {
    return "New Request : " + username;
  } else if (UserSession.getLng(UserSession.keyLocalLng) == "es") {
    return "Nueva solicitud : " + username;
  } else if (UserSession.getLng(UserSession.keyLocalLng) == "pt") {
    return "Novo pedido : " + username;
  } else {
    return "New Request : " + username;
  }
}

String getAcceptVal() {
  if (UserSession.getLng(UserSession.keyLocalLng) == "en") {
    return "Accept";
  } else if (UserSession.getLng(UserSession.keyLocalLng) == "es") {
    return "Aceptar";
  } else if (UserSession.getLng(UserSession.keyLocalLng) == "pt") {
    return "Aceitar";
  } else {
    return "Accept";
  }
}

String getRejectVal() {
  if (UserSession.getLng(UserSession.keyLocalLng) == "en") {
    return "Reject";
  } else if (UserSession.getLng(UserSession.keyLocalLng) == "es") {
    return "Rechazar";
  } else if (UserSession.getLng(UserSession.keyLocalLng) == "pt") {
    return "Declínio";
  } else {
    return "Reject";
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [ChuckerFlutter.navigatorObserver],
      debugShowCheckedModeBanner: false,
      locale: Locale(UserSession.getLng(UserSession.keyLocalLng)),
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: 'madr Driver App',
      theme: ThemeData(
          primarySwatch: primaryBlack,
          // codeTextButtonColor: ConstColor.accentColor,
          fontFamily: 'Bahnschrift',
          useMaterial3: false),
      // builder: (context, child) {
      //   return UpgradeAlert(
      //     upgrader: Upgrader(
      //       minAppVersion: "2.0"
      //     ),
      //     child: child,
      //   );
      // },
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }

  // MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);
  final MaterialColor primaryBlack = const MaterialColor(
    0xff4D4D4D,
    <int, Color>{
      50: Color(0xff676767),
      100: Color(0xff676767),
      200: Color(0xff676767),
      300: Color(0xff676767),
      400: Color(0xff676767),
      500: Color(0xff676767),
      600: Color(0xff676767),
      700: Color(0xff676767),
      800: Color(0xff676767),
      900: Color(0xff676767),
    },
  );
}

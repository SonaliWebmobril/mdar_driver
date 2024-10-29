import 'package:flutter/widgets.dart';
import 'package:madr_driver/design/auth_design/design/doc_next_upload.dart';
import 'package:madr_driver/design/auth_design/design/live_photo_screen.dart';
import 'package:madr_driver/design/auth_design/design/login_screen.dart';
import 'package:madr_driver/design/auth_design/design/select_country.dart';
import 'package:madr_driver/design/auth_design/design/thank_u_screen.dart';
import 'package:madr_driver/design/auth_design/design/verification_Screen.dart';
import 'package:madr_driver/design/auth_design/design/web_view.dart';

import 'package:madr_driver/design/settings/design/add_new_doc.dart';
import 'package:madr_driver/design/settings/design/bank_information.dart';
import 'package:madr_driver/design/settings/design/edit_profile_screen.dart';
import 'package:madr_driver/design/settings/design/setting_screen.dart';
import 'package:madr_driver/design/settings/design/support_screen.dart';
import 'package:madr_driver/design/settings/design/uploaded_doc_info.dart';
import 'package:madr_driver/design/settings/design/my_trip/my_trip_details_screen.dart';
import 'package:madr_driver/design/settings/design/my_trip/my_trip_screen.dart';
import 'package:madr_driver/Chat/inbox.dart';
import 'package:madr_driver/design/settings/design/wallet_history.dart';
import 'package:madr_driver/design/settings/design/wallet_screen.dart';

import 'design/auth_design/design/docment_upload.dart';
import 'design/auth_design/design/social_login_screen.dart';
import 'design/auth_design/design/take_document_screen.dart';
import 'design/notification/notification.dart';
import 'design/settings/design/change_language.dart';
import 'design/settings/design/transection/transection_screen.dart';
import 'package:madr_driver/design/dashboard/design/home_screen.dart';

import 'design/dashboard/design/accept_ride.dart';
import 'design/dashboard/design/ride_completed.dart';
import 'design/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  // UpgradeAlert(
  //         upgrader: Upgrader(
  //           dialogStyle: UpgradeDialogStyle.material,
  //           minAppVersion: "0.0.1",
  //           canDismissDialog: false,
  //           showIgnore: false,
  //           showLater: false,
  //           debugLogging: true,
  //           showReleaseNotes: true,
  //           debugDisplayAlways: true,
  //           willDisplayUpgrade: ({appStoreVersion, required display, installedVersion, minAppVersion}) {
  //             print("will display upgrader");
  //           },
  //         ),
  //         child: LoginScreen(),
  //       ),
  SelectCountry.routeName: (context) => const SelectCountry(),
  VerficationScreen.routeName: (context) => const VerficationScreen(),
  SocialLoginScreen.routeName: (context) => const SocialLoginScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
  BankInformatoinScreen.routeName: (context) => const BankInformatoinScreen(),
  TransectionHistroyScreen.routeName: (context) =>
      const TransectionHistroyScreen(),
  MyTripScreen.routeName: (context) => const MyTripScreen(),
  MyTripDetailsScreen.routeName: (context) => const MyTripDetailsScreen(),
  SupportScreen.routeName: (context) => const SupportScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  //  UpgradeAlert(
  //     upgrader: Upgrader(
  //       dialogStyle: UpgradeDialogStyle.material,
  //       minAppVersion: "0.0.1",
  //       canDismissDialog: false,
  //       showIgnore: false,
  //       showLater: false,
  //       debugLogging: true,
  //       showReleaseNotes: true,
  //       debugDisplayAlways: true,
  //       willDisplayUpgrade: ({appStoreVersion, required display, installedVersion, minAppVersion}) {
  //         print("will display upgrader");
  //       },
  //     ),
  //     child: HomeScreen(),
  //   ),
  AcceptRideScreen.routeName: (context) => const AcceptRideScreen(),
  RideCompletedScreen.routeName: (context) => const RideCompletedScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  DocmentUploadScreen.routeName: (context) => const DocmentUploadScreen(),
  DocumentUploadScreen2.routeName: (context) => const DocumentUploadScreen2(),
  TakeDocumnetScreen.routeName: (context) => const TakeDocumnetScreen(),
  AddNewDocumentScreen.routeName: (context) => const AddNewDocumentScreen(),
  UploadedDocInfoScreen.routeName: (context) => const UploadedDocInfoScreen(),
  ThankYouScreen.routeName: (context) => const ThankYouScreen(),
  InboxScreen.routeName: (context) => const InboxScreen(),
  ChangeLanguage.routeName: (context) => const ChangeLanguage(),
  LivePhotoScreen.routeName: (context) => const LivePhotoScreen(),
  WalletScreen.routeName: (context) => const WalletScreen(),
  WalletHistory.routeName: (context) => const WalletHistory(),
  WebViewScreen.routeName: ((context) => const WebViewScreen()),
};

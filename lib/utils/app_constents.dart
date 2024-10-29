// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:madr_driver/utils/const_color.dart';

class AppConstents {
  AppConstents();

// development

  static const String baseUrl = "http://52.22.241.165:10036/";
  static const String socketBaseUrl = "http://52.22.241.165:10036/";

// production
//  static const String baseUrl = "https://taxi.wdrive.es/";
//  static const String socketBaseUrl = "https://taxi.wdrive.es:10000/";
  //client

  static const String googleApiKey = "AIzaSyAVtBD-U5-jXU2L4zCdrSuaWxDlZyvsIv4";

  //************************images*********************/

  //static const String splashScreenGif = "assets/images/logo.png";
  static const String splashScreenGif = "assets/images/taxi_logo.png";
  //static const String splashScreenBg = "assets/images/splash_bg.png";
  static const String splashScreenBg = "assets/images/taxi_logo.png";
  static const String AppBg = "assets/images/app_bg.png";
  static const String mapBgImg = "assets/images/map_bg.png";
  static const String blueBgImg = "assets/images/blue_bg.png";
  static const String blackBgImg = "assets/images/black_bg.png";
  static const String blackRightBgImg = "assets/images/black_right_bg.png";
  //static const String appLogo = "assets/images/logo.png";
  static const String appLogo = "assets/images/taxi_logo.png";
  static const String whiteAppLogo = "assets/images/white_logo.png";
  static const String googleIcon = "assets/images/g_plus.png";
  static const String fbIcon = "assets/images/facebook_icon.png";
  static const String appleIcon = "assets/images/apple_icon.png";
  static const String downArrow = "assets/images/down_black_arrow.png";
  static const String mapHomeScrren = "assets/images/home_map.png";
  static const String notificationBell = "assets/images/bell_iocn.png";
  static const String arrowBack = "assets/images/back_image.png";
  static const String draweImage = "assets/images/drawer.png";
  static const String editImage = "assets/images/edit_icon.png";
  static const String pickupLocationIcon = "assets/images/richlocationicon.png";
  static const String dropoffLocationIcon =
      "assets/images/startlocationicon.png";
  static const String greyArrowIcon = "assets/images/grey_arrow.png";
  static const String dividerLineIcon = "assets/images/divider_line.png";
  static const String taxiIcon = "assets/images/taxi.png";
  static const String gTaxiIcon = "assets/images/g_taxi.png";
  static const String gpsPinIcon = "assets/images/gps_pin.png";
  static const String recentIcon = "assets/images/recent.png";
  static const String taxiMapIcon = "assets/images/taxi_map.png";
  static const String rideWaitMapIcon = "assets/images/ride_wait.png";
  static const String completeIcon = "assets/images/success_icon.png";
  static const String arrowFarword = "assets/images/arrow_forward.png";
  static const String callIcon = "assets/images/call.png";
  static const String chatIcon = "assets/images/chat.png";
  static const String priceBg = "assets/images/price_back.png";
  static const String uploadIcon = "assets/images/uploadIcon.png";

//*****************text const*************************/

  String enterqueries =
      AppLocalizations.of(Get.key.currentContext!)!.txt_pls_enter_queries;
  //  AppLocalizations.of(Get.key.currentContext!)!.txt_pls_enter_queries;
  String queregreater =
      AppLocalizations.of(Get.key.currentContext!)!.txt_query_length;
  // AppLocalizations.of(Get.key.currentContext!)!.txt_query_length_10_digit;

  //******* Live Photo Screen */

  String TakeLivePhoto =
      AppLocalizations.of(Get.key.currentContext!)!.txt_take_live_photo;
  String LoadingCamera =
      AppLocalizations.of(Get.key.currentContext!)!.txt_loading_camera;
  String Retake = AppLocalizations.of(Get.key.currentContext!)!.txt_retake;
  String Cancel = AppLocalizations.of(Get.key.currentContext!)!.txt_cancel;
  String Confirm = AppLocalizations.of(Get.key.currentContext!)!.txt_confirm;
  String NoBooking =
      AppLocalizations.of(Get.key.currentContext!)!.txt_no_booking_for_schedule;
  String ScheduleRide =
      AppLocalizations.of(Get.key.currentContext!)!.txt_schedule_ride;
  String ScheduledRides =
      AppLocalizations.of(Get.key.currentContext!)!.txt_scheduled_rides;
  String MyTrip = AppLocalizations.of(Get.key.currentContext!)!.txt_my_trip;
  String CancelRide =
      AppLocalizations.of(Get.key.currentContext!)!.txt_cancel_ride;
  String PaymentPending =
      AppLocalizations.of(Get.key.currentContext!)!.txt_payment_pending;
  String Accepted = AppLocalizations.of(Get.key.currentContext!)!.txt_accepted;
  String RidePending =
      AppLocalizations.of(Get.key.currentContext!)!.txt_ride_pending;
  String Wallet = AppLocalizations.of(Get.key.currentContext!)!.txt_wallet;
  String SendRequest =
      AppLocalizations.of(Get.key.currentContext!)!.txt_send_request;
  String NoteRemark =
      AppLocalizations.of(Get.key.currentContext!)!.txt_note_remark;
  String WithdrawalAmount =
      AppLocalizations.of(Get.key.currentContext!)!.txt_withdrawal_amt;
  String ToatlAmount =
      AppLocalizations.of(Get.key.currentContext!)!.txt_total_amt;
  String History = AppLocalizations.of(Get.key.currentContext!)!.txt_history;
  String Skip = AppLocalizations.of(Get.key.currentContext!)!.txt_skip;
  String success_txt =
      AppLocalizations.of(Get.key.currentContext!)!.txt_success;
  String EnterAmt = AppLocalizations.of(Get.key.currentContext!)!.txt_enter_amt;
  String ValidAmt =
      AppLocalizations.of(Get.key.currentContext!)!.txt_enter_valid_amt;
  String OwnerName =
      AppLocalizations.of(Get.key.currentContext!)!.txt_owner_name;
  String EnterOwnerName =
      AppLocalizations.of(Get.key.currentContext!)!.txt_enter_owner_name;
  String ValidOwnerName =
      AppLocalizations.of(Get.key.currentContext!)!.txt_enter_valid_owner_name;
  String ValidMakerName =
      AppLocalizations.of(Get.key.currentContext!)!.txt_enter_valid_maker_name;
  String ValidColorName =
      AppLocalizations.of(Get.key.currentContext!)!.txt_valid_color_name;
  String EnterColorName =
      AppLocalizations.of(Get.key.currentContext!)!.txt_enter_color_name;
  String RequestMode =
      AppLocalizations.of(Get.key.currentContext!)!.txt_request_mode;
  String RequestPending =
      AppLocalizations.of(Get.key.currentContext!)!.txt_request_pending;
  String RequestDecline =
      AppLocalizations.of(Get.key.currentContext!)!.txt_request_decline;
  String RequestDate =
      AppLocalizations.of(Get.key.currentContext!)!.txt_request_date;
  String RequestStatus =
      AppLocalizations.of(Get.key.currentContext!)!.txt_request_status;
  String validName =
      AppLocalizations.of(Get.key.currentContext!)!.txt_enter_vaild_name;
  String txtUpdate = AppLocalizations.of(Get.key.currentContext!)!.txt_update;
  String txtEnterDetails =
      AppLocalizations.of(Get.key.currentContext!)!.txt_enter_details_of_your;
  String txtUploadPhoto =
      AppLocalizations.of(Get.key.currentContext!)!.txt_upload_photo_of_your;
  String txtVehicle = AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle;
  String txtSelectMinOne =
      AppLocalizations.of(Get.key.currentContext!)!.txt_select_min_one_img;
  String txtDetails = AppLocalizations.of(Get.key.currentContext!)!.txt_details;
  String txtInProgress =
      AppLocalizations.of(Get.key.currentContext!)!.txt_in_progress;
  String completeRide =
      AppLocalizations.of(Get.key.currentContext!)!.txt_complete_ride;
  String yourRideCompleted =
      AppLocalizations.of(Get.key.currentContext!)!.txt_your_ride_completed;
  String RideCompleted =
      AppLocalizations.of(Get.key.currentContext!)!.txt_ride_completed;
  String securityDeposit =
      AppLocalizations.of(Get.key.currentContext!)!.txt_security_deposit;
  String completeSecurityDeposit = AppLocalizations.of(Get.key.currentContext!)!
      .txt_complete_security_deposit_process;
  String checkedDepositOption =
      AppLocalizations.of(Get.key.currentContext!)!.txt_checked_pay_later;
  String doneOnlinePayment = AppLocalizations.of(Get.key.currentContext!)!
      .txt_already_done_online_payment;
  String choosePaymentMethod =
      AppLocalizations.of(Get.key.currentContext!)!.txt_choose_pay_menthod;
  String payNowButton =
      AppLocalizations.of(Get.key.currentContext!)!.txt_pay_now;
  String doDepositeLater =
      AppLocalizations.of(Get.key.currentContext!)!.txt_do_later;
  String genderPreferences =
      AppLocalizations.of(Get.key.currentContext!)!.txt_gender_pref;
  String genderPreferencesDetail = AppLocalizations.of(Get.key.currentContext!)!
      .txt_gender_you_want_to_prefer;
  String txtMale = AppLocalizations.of(Get.key.currentContext!)!.txt_male;
  String txtFemale = AppLocalizations.of(Get.key.currentContext!)!.txt_female;
  String txtOther = AppLocalizations.of(Get.key.currentContext!)!.txt_other;
  String txtNoPref = AppLocalizations.of(Get.key.currentContext!)!.txt_no_pref;
  String txtUpdateDetails =
      AppLocalizations.of(Get.key.currentContext!)!.txt_update_details_of_user;
  String txtCriminalRecordCertificate =
      AppLocalizations.of(Get.key.currentContext!)!
          .txt_criminal_record_certificate;
  String txtCriminalRecord =
      AppLocalizations.of(Get.key.currentContext!)!.txt_criminal_record;
  String txtUpdateYour =
      AppLocalizations.of(Get.key.currentContext!)!.txt_update_your;
  String txtDocument =
      AppLocalizations.of(Get.key.currentContext!)!.txt_document;
  String txtSelectGender =
      AppLocalizations.of(Get.key.currentContext!)!.txt_select_your_gender;
  String txtGender = AppLocalizations.of(Get.key.currentContext!)!.txt_gender;
  String txtRideType =
      AppLocalizations.of(Get.key.currentContext!)!.txt_ride_type;
  String txtReject = AppLocalizations.of(Get.key.currentContext!)!.txt_rejected;
  String txtKm = AppLocalizations.of(Get.key.currentContext!)!.txt_km;
  String txtSelectReason =
      AppLocalizations.of(Get.key.currentContext!)!.txt_select_reason;
  String txtSelectGenderPreference =
      AppLocalizations.of(Get.key.currentContext!)!.txt_select_gender_pref;
  // static const String txtVerifyYourDoc = "Once we will verify your documents,";
  // static const String txtNotifyYou = "we will notify you.";
  // String txtActiveAfterVerification =
  //     "After verification your account will be active";
  String txtUpdateDocuments =
      AppLocalizations.of(Get.key.currentContext!)!.txt_update_documents;
  String txtAreYouSureToLogout =
      AppLocalizations.of(Get.key.currentContext!)!.txt_are_you_sure_to_logout;
  String txtMyRides =
      AppLocalizations.of(Get.key.currentContext!)!.txt_my_rides;
  String txtRating = AppLocalizations.of(Get.key.currentContext!)!.txt_rating;
  String txtDailyRide =
      AppLocalizations.of(Get.key.currentContext!)!.txt_daily_ride;
  String txtRentalRide =
      AppLocalizations.of(Get.key.currentContext!)!.txt_rental_ride;
  String txtReasonField =
      AppLocalizations.of(Get.key.currentContext!)!.txt_enter_your_reason;
  String txtRideTypeSelection =
      AppLocalizations.of(Get.key.currentContext!)!.txt_select_ride_type;
  String txtDeactivateDriverMarquee =
      AppLocalizations.of(Get.key.currentContext!)!.txt_profile_under_review;
  String txtAccountDeactivated = AppLocalizations.of(Get.key.currentContext!)!
      .txt_your_account_deactivateed;
  String txtAcceptTerms =
      AppLocalizations.of(Get.key.currentContext!)!.txt_accept_terms_privacy;
  String txtCheckTerms = AppLocalizations.of(Get.key.currentContext!)!
      .txt_please_accept_terms_privacy;
  String thanksForRegistration =
      AppLocalizations.of(Get.key.currentContext!)!.txt_thanks_for_registering;
  String checkStatusOnStatusBar = AppLocalizations.of(Get.key.currentContext!)!
      .txt_application_under_review_check_status;
  String updateDetails =
      AppLocalizations.of(Get.key.currentContext!)!.txt_update_details;
  String txtRideDetail =
      AppLocalizations.of(Get.key.currentContext!)!.txt_ride_details;
  String txtMpesa = AppLocalizations.of(Get.key.currentContext!)!.txt_online;
  //AppLocalizations.of(Get.key.currentContext!)!.txt_mpesa;
  String txtImage = AppLocalizations.of(Get.key.currentContext!)!.txt_image;
  String txtConnectivityAndRetry = AppLocalizations.of(Get.key.currentContext!)!
      .txt_check_internet_try_again;
  String txtNoNetwork =
      AppLocalizations.of(Get.key.currentContext!)!.txt_oops_no_internet;
  String txtPackageComplete =
      AppLocalizations.of(Get.key.currentContext!)!.txt_package_complete_renew;
  String txtCompleteRide =
      AppLocalizations.of(Get.key.currentContext!)!.txt_complete_ride;
  String txtWaitForResp =
      AppLocalizations.of(Get.key.currentContext!)!.txt_wait_for_response;
  String txtRideCompleteIn =
      AppLocalizations.of(Get.key.currentContext!)!.txt_ride_complete_in;
  String txtSomethingWrong =
      AppLocalizations.of(Get.key.currentContext!)!.txt_something_went_wrong;
  String txtRefreshPage =
      AppLocalizations.of(Get.key.currentContext!)!.txt_refresh_page_try_later;
  String txtPermissionRequired =
      AppLocalizations.of(Get.key.currentContext!)!.txt_permission_required;
  String txtEnablePermission =
      AppLocalizations.of(Get.key.currentContext!)!.txt_enable_permission;
  String txtPickCountry =
      AppLocalizations.of(Get.key.currentContext!)!.txt_pick_your_country;
  String txtCompleteSecurityDeposit =
      AppLocalizations.of(Get.key.currentContext!)!
          .txt_complete_security_deposit_process;
  String txtCantUpdateRide =
      AppLocalizations.of(Get.key.currentContext!)!.txt_cant_update_ride_type;
  String txtCheckConnectionTimeout =
      AppLocalizations.of(Get.key.currentContext!)!.txt_check_connect_timeout;
  String txtTimeoutExcep =
      AppLocalizations.of(Get.key.currentContext!)!.txt_timeout_exception;
  String txtRequestCancel = AppLocalizations.of(Get.key.currentContext!)!
      .txt_request_cancel_from_user;
  String txtWrongResponse =
      AppLocalizations.of(Get.key.currentContext!)!.txt_getting_wrong_response;
  String txtConnectionError =
      AppLocalizations.of(Get.key.currentContext!)!.txt_connection_error;
  String txtContactAdmin = AppLocalizations.of(Get.key.currentContext!)!
      .txt_server_not_connected_contact_admin;
  String txtServerNotCon =
      AppLocalizations.of(Get.key.currentContext!)!.txt_socket_not_connect;
  String txtRenewedPackage =
      AppLocalizations.of(Get.key.currentContext!)!.txt_user_renewed_package;
  String txtBearPerKm =
      AppLocalizations.of(Get.key.currentContext!)!.txt_bear_per_km;
  String txtWaitForUser =
      AppLocalizations.of(Get.key.currentContext!)!.txt_wait_for_user;
  String txtBySigning =
      AppLocalizations.of(Get.key.currentContext!)!.txt_bysigning_you_accept;
  String txtTermsOfService =
      AppLocalizations.of(Get.key.currentContext!)!.txt_terms_service;
  String txtAnd = AppLocalizations.of(Get.key.currentContext!)!.txt_and;
  String txtPrivacyPolicy =
      AppLocalizations.of(Get.key.currentContext!)!.txt_privacy_policy;
  String txtCashReceived =
      AppLocalizations.of(Get.key.currentContext!)!.txt_cash_received;
  String txtNo = AppLocalizations.of(Get.key.currentContext!)!.txt_no;
  String txtYes = AppLocalizations.of(Get.key.currentContext!)!.txt_yes;
  String txtClickTakePhoto =
      AppLocalizations.of(Get.key.currentContext!)!.txt_click_to_take_photo;
  String txtEnterotp =
      AppLocalizations.of(Get.key.currentContext!)!.txt_enter_otp;
  String cameraSettingPermission = AppLocalizations.of(Get.key.currentContext!)!
      .txt_camera_setting_permission;
  String gallerySettingPermission =
      AppLocalizations.of(Get.key.currentContext!)!
          .txt_gallery_setting_permission;
  String txtUnauthorizeLogin =
      AppLocalizations.of(Get.key.currentContext!)!.txt_unauthorized_login;
  String txtReLogin =
      AppLocalizations.of(Get.key.currentContext!)!.txt_login_detect;
  String locationSettingPermission =
      AppLocalizations.of(Get.key.currentContext!)!
          .txt_location_setting_permission;

  String txtDelete =
      AppLocalizations.of(Get.key.currentContext!)!.txt_delete_account;
  String txtAreYouSureToDelete =
      AppLocalizations.of(Get.key.currentContext!)!.txt_sure_to_delete;
  String txtOpenWith =
      AppLocalizations.of(Get.key.currentContext!)!.txt_open_with;
  String txtNewRequestFrom =
      AppLocalizations.of(Get.key.currentContext!)!.txt_new_request_from;
  String txtVehicleAssign =
      AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_assign;
  String txtAdminDelete =
      AppLocalizations.of(Get.key.currentContext!)!.txt_admin_delete;
  String txtCity = "City";
  String txtWriteReview =
      AppLocalizations.of(Get.key.currentContext!)!.txt_write_comment;
  String txtRateUser = "Rate User";
  String txtSubscriptionPlan = "Subscription Plan";
  String txtFranchise = "Membership/Franchise";

  List cancelReasonList = [
    {
      'name': AppLocalizations.of(Get.key.currentContext!)!.txt_driver_denied,
      'id': "0",
    },
    {
      'name': AppLocalizations.of(Get.key.currentContext!)!.txt_expected_time,
      'id': "1",
    },
    {
      'name': AppLocalizations.of(Get.key.currentContext!)!
          .txt_unable_to_contact_user,
      'id': "2",
    },
    {
      'name':
          AppLocalizations.of(Get.key.currentContext!)!.txt_reason_not_listed,
      'id': "3",
    },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_expected_time,
    //   'id': "4",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_unable_to_contact_user,
    //   'id': "5",
    // },
  ];

  List languageList = [
    {
      'name': AppLocalizations.of(Get.key.currentContext!)!.txt_english,
      'value': "0",
      'icon': "assets/images/uk.png",
    },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_portuguese,
    //   'value': "1",
    //   'icon': "assets/images/portugal.png",
    // },
    {
      'name': AppLocalizations.of(Get.key.currentContext!)!.txt_arabic,
      'value': "2",
      'icon': "assets/images/arabic.png",
    },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_urdu,
    //   'value': "3",
    //   'icon': "assets/images/urdu.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_hindi,
    //   'value': "4",
    //   'icon': "assets/images/india.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_spanish,
    //   'value': "2",
    //   'icon': "assets/images/spain.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_mandarim,
    //   'value': "6",
    //   'icon': "assets/images/mandarim.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_french,
    //   'value': "7",
    //   'icon': "assets/images/france.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_afrikaans,
    //   'value': "8",
    //   'icon': "assets/images/afrikaans.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_bengali,
    //   'value': "9",
    //   'icon': "assets/images/bengali.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_russian,
    //   'value': "10",
    //   'icon': "assets/images/russia.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_japanese,
    //   'value': "11",
    //   'icon': "assets/images/japan.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_turkish,
    //   'value': "12",
    //   'icon': "assets/images/turkey.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_swahili,
    //   'value': "13",
    //   'icon': "assets/images/swahili.png",
    // },
    // {
    //   'name': AppLocalizations.of(Get.key.currentContext!)!.txt_italian,
    //   'value': "14",
    //   'icon': "assets/images/italy.png",
    // },
  ];
}

 

//common loder indicator*********//

class ProgressHUD extends StatelessWidget {
  final Widget child;
  final inAsyncCall;
  final double opacity;
  final Color color;

  const ProgressHUD({
    Key? key,
    required this.child,
    required this.inAsyncCall,
    this.opacity = 0.5,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          const Center(
              child: CircularProgressIndicator(
            color: ConstColor.codeBackgroundColor,
          )),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}

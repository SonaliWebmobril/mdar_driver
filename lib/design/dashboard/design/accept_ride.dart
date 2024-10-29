import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';
import '../../../constents/package_extend.dart';
import '../../../socket_connection/socket_connection.dart';
import '../../../utils/const_color.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/style.dart';
import '../../../utils/toast.dart';
import '../../../utils/user_session.dart';
import '../../auth_design/custom_widget/commonbutton.dart';
import '../../settings/controller/profile_controller.dart';
import '../../settings/design/setting_screen.dart';
import '../controller/accept_ride_controller.dart';
import 'map_widget/map_polylines.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AcceptRideScreen extends StatefulWidget {
  static String routeName = "AcceptRideScreen";

  const AcceptRideScreen({Key? key}) : super(key: key);

  @override
  State<AcceptRideScreen> createState() => _AcceptRideScreenState();
}

class _AcceptRideScreenState extends State<AcceptRideScreen> {
  var acceptRideController = Get.put(AcceptRideController());
  var profileController = Get.put(ProfileController());
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // print(" homeprint..  accept ride initial dispose..  " +
    //     Get.arguments.toString());
    acceptRideController.data = Get.arguments;
    print(" homeprint..  accept ride initial dispose..  " +
        acceptRideController.data.bookingData.toString());

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      acceptRideController.totalPrice.value = double.parse(
          acceptRideController.data.bookingData!.totalPrice!.toString());
      acceptRideController.locationIntialization();
      acceptRideController.etCancelFocusNode.value
          .addListener(_onTextFieldFocusChange);

      acceptRideController.waitUser.value =
          acceptRideController.data.bookingData!.waitUser!;
      int currentStatus =
          UserSession.getIntFromSession(UserSession.keyCurrentBookingStatus)!;
      print("accept ride..currentStatus..   " + currentStatus.toString());
      if (currentStatus == 0 || currentStatus == 1) {
        acceptRideController.rideStatus.value = 0;
      } else if (currentStatus == 2) {
        acceptRideController.rideStatus.value = 2;
      } else if (currentStatus == 3) {
        acceptRideController.rideStatus.value = 3;
      }
      print("accept ride..initial..   ${acceptRideController.data}");
      if (acceptRideController.data.bookingData!.packageStatus.toString() ==
          "1") {
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
    });

    Future.delayed(Duration(seconds: 5), () {
      if (Get.currentRoute == "AcceptRideScreen") {
        SocketConnection.sendMessage("get_chat_count",
            {"booking_id": acceptRideController.data.bookingData!.bookingId});
      }
    });

    UserSession.setStringInSession(UserSession.keyCurrentBookingId,
        acceptRideController.data.bookingData!.bookingId.toString());
    profileController.getProfileRequest();
  }

  void _onTextFieldFocusChange() {
    if (acceptRideController.etCancelFocusNode.value.hasFocus) {
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("accept ride..dispose..   " +
        acceptRideController.mapController.mapId.toString());
    _scrollController.dispose();
    acceptRideController.dispose();
    Get.delete<AcceptRideController>(force: true);
    // acceptRideController.onRejectLead();
    // acceptRideController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild.... ");
    print(
        "datatatatatatatta ${acceptRideController.data.bookingData!.profilePic.toString()}");
    return WillPopScope(
        onWillPop: acceptRideController.onLoginBackPressed,
        child: Scaffold(
          backgroundColor: ConstColor.blackcodeTextButtonColor,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  // height: 150,
                  color: ConstColor.blackcodeTextButtonColor,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsetsDirectional.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 5),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              page: SettingsScreen(),
                                              animationType:
                                                  "SlideTransition"));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: acceptRideController
                                                  .data.bookingData!.profilePic
                                                  .toString() !=
                                              "0"
                                          ? CachedNetworkImage(
                                              width: 60,
                                              height: 60,
                                              imageUrl: AppConstents.baseUrl +
                                                  acceptRideController.data
                                                      .bookingData!.profilePic
                                                      .toString(),
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            )
                                          : Image.asset(
                                              "assets/images/userErrImg.png",
                                              height: 50,
                                              width: 50,
                                              // color: Colors.white,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${acceptRideController.data.bookingData!.name.toString()}",
                                          style: homeSheetDetailTextStyle),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                          "${acceptRideController.data.bookingData!.mobile.toString()}",
                                          style: homeSheetDetailTextStyle),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => InkWell(
                                  onTap: () {
                                    Get.toNamed("InboxScreen", arguments: {
                                      'page_from': 'in_ride',
                                      'booking_id': acceptRideController
                                          .data.bookingData!.bookingId,
                                      'other_user_name': acceptRideController
                                          .data.bookingData!.name,
                                      // 'other_user_id':
                                      //     acceptRideController.data.driverId,
                                      // 'user_id': acceptRideController.data.userId,
                                    });
                                    acceptRideController.chatCount.value = 0;
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        margin:
                                            EdgeInsetsDirectional.only(end: 10),
                                        decoration: const BoxDecoration(
                                          color: ConstColor.iconColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.all(
                                                  8.0),
                                          child: Image.asset(
                                            AppConstents.chatIcon,
                                            height: 18.86,
                                            width: 14.14,
                                          ),
                                        ),
                                      ),
                                      acceptRideController.chatCount.value != 0
                                          ? Container(
                                              width: 16,
                                              height: 16,
                                              transform:
                                                  Matrix4.translationValues(
                                                      26.0, -5.0, 0.0),
                                              alignment:
                                                  AlignmentDirectional.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                acceptRideController
                                                    .chatCount.value
                                                    .toString(),
                                                style: TextStyle(fontSize: 11),
                                              ))
                                          : Container()
                                    ],
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                UrlLauncher.launchUrl(
                                    Uri.parse(
                                        "tel: ${acceptRideController.data.bookingData!.mobile}"),
                                    mode: LaunchMode.externalApplication);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: ConstColor.iconColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.all(8.0),
                                  child: Image.asset(
                                    AppConstents.callIcon,
                                    height: 18.86,
                                    width: 14.14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            pickupDropoffRow(
                                AppConstents.pickupLocationIcon,
                                "${acceptRideController.data.bookingData!.pickupAddress} ",
                                3,
                                pickupDroppHeadingStyle),
                            const SizedBox(height: 8),
                            if (acceptRideController
                                        .data.bookingData!.dropAddress !=
                                    "" &&
                                acceptRideController
                                        .data.bookingData!.dropAddress !=
                                    null)
                              pickupDropoffRow(
                                  AppConstents.dropoffLocationIcon,
                                  "${acceptRideController.data.bookingData!.dropAddress} ",
                                  3,
                                  pickupDroppHeadingStyle),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.maxFinite,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          MapPolylines(),
                          SingleChildScrollView(
                              child: Container(
                            child: Container(
                              // height: 200,
                              alignment: AlignmentDirectional.bottomStart,
                              color: Colors.transparent,
                              child: Container(
                                decoration: bottomSheetDecoration,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Container(
                                        width: 72,
                                        height: 3,
                                        decoration: BoxDecoration(
                                            color:
                                                ConstColor.bottomSheetLineColor,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Obx(() => Container(
                                        // padding:
                                        //     const EdgeInsetsDirectional.symmetric(
                                        //         horizontal: 25),
                                        child: rideView())),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          Container(
                            // right: 10,
                            // top: 170,
                            alignment: AlignmentDirectional.topEnd,
                            child: InkWell(
                              onTap: () async {
                                Get.log("in launchurl");
                                // acceptRideController.navigation();
                                acceptRideController.mapNavigate();
                              },
                              child: Container(
                                margin: EdgeInsetsDirectional.only(
                                    start: 8, end: 8, top: 22, bottom: 5),
                                padding: EdgeInsetsDirectional.only(
                                    start: 8, end: 8, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  // color: ConstColor.bluecodeTextButtonColor,
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: const LinearGradient(
                                    begin: AlignmentDirectional.topEnd,
                                    end: AlignmentDirectional.bottomStart,
                                    colors: [
                                      ConstColor.iconColor,
                                      ConstColor.iconColor,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Transform.rotate(
                                      angle: 180 * 0.6 / 180,
                                      child: const Icon(
                                        Icons.navigation,
                                        size: 24,
                                        color: ConstColor.accentColor,
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(
                                              Get.key.currentContext!)!
                                          .txt_navigate,
                                      style: uploadButtonTitleStyle,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }

  Widget pickupOTPScreen() {
    return Column(
      children: [
        const SizedBox(
          width: 15,
        ),
        Text(AppLocalizations.of(Get.key.currentContext!)!.txt_enter_otp,
            style: homeSheetDetailTextStyle),
        const SizedBox(width: 15),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.70,
          child: PinCodeTextField(
            keyboardType: TextInputType.number,
            textStyle: const TextStyle(color: ConstColor.accentColor),
            length: 4,
            obscureText: false,
            animationType: AnimationType.fade,
            cursorColor: Colors.white,
            pinTheme: PinTheme(
              borderWidth: 1,
              inactiveFillColor: ConstColor.blackcodeTextButtonColor,
              activeFillColor: ConstColor.blackcodeTextButtonColor,
              selectedFillColor: ConstColor.blackcodeTextButtonColor,
              selectedColor: ConstColor.accentColor,
              activeColor: ConstColor.accentColor,
              inactiveColor: Colors.grey,
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10),
              fieldHeight: 50,
              fieldWidth: 50,
            ),
            animationDuration: const Duration(milliseconds: 300),
            //backgroundColor: ConstColor.accentColor,
            enableActiveFill: true,
            // controller: textEditingController,
            onCompleted: (v) {
              debugPrint("Completed");
            },
            onChanged: (value) {
              // setState(() {
              acceptRideController.otpController.text = value;
              // });
            },
            beforeTextPaste: (text) {
              return true;
            },
            appContext: context,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CommonButton(
            onPressed: () {
              acceptRideController.verifyOtp();
            },
            title:
                AppLocalizations.of(Get.key.currentContext!)!.txt_start_ride),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  rideView() {
    print(
        "acceptRideController.rideStatus.value   ..  ${acceptRideController.rideStatus.value.toString()}   ${acceptRideController.waitUser.value.toString()}");
    if (acceptRideController.rideStatus.value == 0 &&
        acceptRideController.waitUser.value == 0) {
      return Column(
        children: [
          // const SizedBox(width: 5),
          // Text(
          //     AppLocalizations.of(Get.key.currentContext!)!.txt_customer_pickup,
          //     style: homeSheetDetailTextStyle),
          const SizedBox(width: 5),
          const SizedBox(
            height: 10,
          ),
          CommonButton(
              width: 180,
              color: ConstColor.codeTextButtonColor,
              txtStyle: buttonBlackTitle,
              onPressed: () {
                SocketConnection.sendMessage("driverWaitingForUser", {
                  "booking_id": acceptRideController.data.bookingData!.bookingId
                });
                // UserSession.setBoolInSession(UserSession.waitUser, true);
              },
              title: AppConstents().txtWaitForUser),
          //  title: AppLocalizations.of(Get.key.currentContext!)!.txt_yes),
          const SizedBox(
            height: 10,
          ),
          GreyButton(
              onPressed: () {
                log("data ${acceptRideController.data}");
                Get.bottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ), StatefulBuilder(builder: (context, setState) {
                  return Container(
                    // color: Colors.transparent,
                    padding: EdgeInsetsDirectional.only(top: 10),
                    decoration: const BoxDecoration(
                        color: ConstColor.blackcodeTextButtonColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0))),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Container(
                                width: 72,
                                height: 3,
                                decoration: BoxDecoration(
                                    color: ConstColor.diividerColor,
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                AppLocalizations.of(Get.key.currentContext!)!
                                    .txt_reason_cancellation,
                                style: appbarTextStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              child: ListView.separated(
                                  // controller: _scrollController,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      selected: index ==
                                          acceptRideController
                                              .selectedtIndex.value,
                                      onTap: () {
                                        // setState(() {
                                        acceptRideController
                                                .cancelReasonTxt.value =
                                            AppConstents()
                                                    .cancelReasonList[index]
                                                ['name'];
                                        acceptRideController
                                                .cancelReasonId.value =
                                            AppConstents()
                                                .cancelReasonList[index]['id'];
                                        acceptRideController
                                            .selectedtIndex.value = index;
                                        if (AppConstents()
                                                    .cancelReasonList[index]
                                                ['id'] ==
                                            "3") {
                                          acceptRideController
                                              .textFieldForReason.value = true;
                                          _scrollToBottom();
                                        } else {
                                          acceptRideController
                                              .textFieldForReason.value = false;
                                        }
                                        // });
                                        // Navigator.of(context).pop();
                                      },
                                      trailing: Obx(
                                        () => Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              gradient: index ==
                                                      acceptRideController
                                                          .selectedtIndex.value
                                                  ? const LinearGradient(
                                                      begin:
                                                          AlignmentDirectional
                                                              .topEnd,
                                                      end: AlignmentDirectional
                                                          .bottomStart,
                                                      colors: [
                                                        ConstColor
                                                            .blueSecondaryColor,
                                                        ConstColor
                                                            .bluecodeTextButtonColor,
                                                      ],
                                                    )
                                                  : const LinearGradient(
                                                      colors: [
                                                          Colors.transparent,
                                                          Colors.transparent,
                                                        ])),
                                          child: Icon(
                                            Icons.check,
                                            color: index ==
                                                    acceptRideController
                                                        .selectedtIndex.value
                                                ? ConstColor.accentColor
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        AppConstents().cancelReasonList[index]
                                            ['name'],
                                        style: cancelBottomSheetTextStyle,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      color: ConstColor.accentColor,
                                    );
                                  },
                                  itemCount:
                                      AppConstents().cancelReasonList.length),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Obx(
                              () => acceptRideController
                                          .textFieldForReason.value ==
                                      true
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color.fromARGB(
                                              218, 255, 255, 255)),
                                      margin:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 15),
                                      child: TextField(
                                        controller: acceptRideController
                                            .etCancelReason.value,
                                        focusNode: acceptRideController
                                            .etCancelFocusNode.value,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsetsDirectional.symmetric(
                                                  horizontal: 20, vertical: 10),
                                          border: InputBorder.none,
                                          counterText:
                                              "${acceptRideController.etReasonLength.value}/250",
                                        ),
                                        maxLines: 3,
                                        maxLength: 250,
                                        cursorColor:
                                            ConstColor.blackcodeTextButtonColor,
                                        onChanged: (val) {
                                          acceptRideController
                                                  .etReasonLength.value =
                                              acceptRideController
                                                  .etCancelReason
                                                  .value
                                                  .text
                                                  .length;
                                        },
                                      ),
                                    )
                                  : Container(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                                margin: EdgeInsetsDirectional.only(
                                    start: 80, end: 80),
                                child: GreyButton(
                                    onPressed: () {
                                      log("cancelReasonTxt ${acceptRideController.cancelReasonTxt.value}");

                                      if (acceptRideController
                                          .cancelReasonTxt.value.isNotEmpty) {
                                        if (acceptRideController
                                                .cancelReasonId.value ==
                                            "3") {
                                          if (acceptRideController
                                              .etCancelReason
                                              .value
                                              .text
                                              .isNotEmpty) {
                                            SocketConnection.sendMessage(
                                                "bookingCancelByDriver", {
                                              'booking_id': acceptRideController
                                                  .data.bookingData!.bookingId,
                                              'reasonOfCancel':
                                                  acceptRideController
                                                      .etCancelReason
                                                      .value
                                                      .text,
                                            });
                                          } else {
                                            showFlutterToast(
                                                message: AppConstents()
                                                    .txtReasonField);
                                          }
                                        } else {
                                          SocketConnection.sendMessage(
                                              "bookingCancelByDriver", {
                                            'booking_id': acceptRideController
                                                .data.bookingData!.bookingId,
                                            'reasonOfCancel':
                                                acceptRideController
                                                    .cancelReasonTxt.value,
                                          });
                                        }
                                      } else {
                                        showFlutterToast(
                                            message:
                                                AppConstents().txtSelectReason);
                                      }
                                    },
                                    title: AppConstents().CancelRide))
                          ],
                        ),
                      ),
                    ),
                  );
                }));

                // Get.back();
              },
              title: AppConstents().CancelRide),

          // title: AppLocalizations.of(Get.key.currentContext!)!.txt_no),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    } else if ((acceptRideController.rideStatus.value == 1 ||
            acceptRideController.rideStatus.value == 0) &&
        acceptRideController.waitUser.value == 1) {
      // pickupOTPScreen();
      return Column(
        children: [
          const SizedBox(
            width: 15,
          ),
          Text(AppLocalizations.of(Get.key.currentContext!)!.txt_enter_otp,
              style: homeSheetDetailTextStyle),
          const SizedBox(width: 15),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.70,
            child: PinCodeTextField(
              keyboardType: TextInputType.number,
              textStyle: const TextStyle(color: ConstColor.accentColor),
              length: 4,
              obscureText: false,
              animationType: AnimationType.fade,
              cursorColor: Colors.white,
              pinTheme: PinTheme(
                borderWidth: 1,
                inactiveFillColor: ConstColor.blackcodeTextButtonColor,
                activeFillColor: ConstColor.blackcodeTextButtonColor,
                selectedFillColor: ConstColor.blackcodeTextButtonColor,
                selectedColor: ConstColor.accentColor,
                activeColor: ConstColor.accentColor,
                inactiveColor: Colors.grey,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 50,
                fieldWidth: 50,
              ),
              animationDuration: const Duration(milliseconds: 300),
              //backgroundColor: ConstColor.accentColor,
              enableActiveFill: true,
              // controller: textEditingController,
              onCompleted: (v) {
                debugPrint("Completed");
              },
              onChanged: (value) {
                // setState(() {
                acceptRideController.otpController.text = value;
                // });
              },
              beforeTextPaste: (text) {
                return true;
              },
              appContext: context,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CommonButton(
              width: 180,
              color: ConstColor.codeTextButtonColor,
              txtStyle: buttonBlackTitle,
              onPressed: () {
                acceptRideController.verifyOtp();
              },
              title:
                  AppLocalizations.of(Get.key.currentContext!)!.txt_start_ride),

          const SizedBox(
            height: 10,
          ),
          GreyButton(
              onPressed: () {
                log("data ${acceptRideController.data}");
                Get.bottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ), StatefulBuilder(builder: (context, setState) {
                  return Container(
                    // color: Colors.transparent,
                    padding: EdgeInsetsDirectional.only(top: 10),
                    decoration: const BoxDecoration(
                        color: ConstColor.blackcodeTextButtonColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0))),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Container(
                                width: 72,
                                height: 3,
                                decoration: BoxDecoration(
                                    color: ConstColor.diividerColor,
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                AppLocalizations.of(Get.key.currentContext!)!
                                    .txt_reason_cancellation,
                                style: appbarTextStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              child: ListView.separated(
                                  // controller: _scrollController,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      selected: index ==
                                          acceptRideController
                                              .selectedtIndex.value,
                                      onTap: () {
                                        // setState(() {
                                        acceptRideController
                                                .cancelReasonTxt.value =
                                            AppConstents()
                                                    .cancelReasonList[index]
                                                ['name'];
                                        acceptRideController
                                                .cancelReasonId.value =
                                            AppConstents()
                                                .cancelReasonList[index]['id'];
                                        acceptRideController
                                            .selectedtIndex.value = index;
                                        if (AppConstents()
                                                    .cancelReasonList[index]
                                                ['id'] ==
                                            "3") {
                                          acceptRideController
                                              .textFieldForReason.value = true;
                                          _scrollToBottom();
                                        } else {
                                          acceptRideController
                                              .textFieldForReason.value = false;
                                        }
                                        // });
                                        // Navigator.of(context).pop();
                                      },
                                      trailing: Obx(
                                        () => Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              gradient: index ==
                                                      acceptRideController
                                                          .selectedtIndex.value
                                                  ? const LinearGradient(
                                                      begin:
                                                          AlignmentDirectional
                                                              .topEnd,
                                                      end: AlignmentDirectional
                                                          .bottomStart,
                                                      colors: [
                                                        ConstColor
                                                            .blueSecondaryColor,
                                                        ConstColor
                                                            .bluecodeTextButtonColor,
                                                      ],
                                                    )
                                                  : const LinearGradient(
                                                      colors: [
                                                          Colors.transparent,
                                                          Colors.transparent,
                                                        ])),
                                          child: Icon(
                                            Icons.check,
                                            color: index ==
                                                    acceptRideController
                                                        .selectedtIndex.value
                                                ? ConstColor.accentColor
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        AppConstents().cancelReasonList[index]
                                            ['name'],
                                        style: cancelBottomSheetTextStyle,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      color: ConstColor.accentColor,
                                    );
                                  },
                                  itemCount:
                                      AppConstents().cancelReasonList.length),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Obx(
                              () => acceptRideController
                                          .textFieldForReason.value ==
                                      true
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color.fromARGB(
                                              218, 255, 255, 255)),
                                      margin:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 15),
                                      child: TextField(
                                        controller: acceptRideController
                                            .etCancelReason.value,
                                        focusNode: acceptRideController
                                            .etCancelFocusNode.value,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsetsDirectional.symmetric(
                                                  horizontal: 20, vertical: 10),
                                          border: InputBorder.none,
                                          counterText:
                                              "${acceptRideController.etReasonLength.value}/250",
                                        ),
                                        maxLines: 3,
                                        maxLength: 250,
                                        cursorColor:
                                            ConstColor.blackcodeTextButtonColor,
                                        onChanged: (val) {
                                          acceptRideController
                                                  .etReasonLength.value =
                                              acceptRideController
                                                  .etCancelReason
                                                  .value
                                                  .text
                                                  .length;
                                        },
                                      ),
                                    )
                                  : Container(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                                margin: EdgeInsetsDirectional.only(
                                    start: 80, end: 80),
                                child: GreyButton(
                                    onPressed: () {
                                      log("cancelReasonTxt ${acceptRideController.cancelReasonTxt.value}");

                                      if (acceptRideController
                                          .cancelReasonTxt.value.isNotEmpty) {
                                        if (acceptRideController
                                                .cancelReasonId.value ==
                                            "3") {
                                          if (acceptRideController
                                              .etCancelReason
                                              .value
                                              .text
                                              .isNotEmpty) {
                                            SocketConnection.sendMessage(
                                                "bookingCancelByDriver", {
                                              'booking_id': acceptRideController
                                                  .data.bookingData!.bookingId,
                                              'reasonOfCancel':
                                                  acceptRideController
                                                      .etCancelReason
                                                      .value
                                                      .text,
                                            });
                                          } else {
                                            showFlutterToast(
                                                message: AppConstents()
                                                    .txtReasonField);
                                          }
                                        } else {
                                          SocketConnection.sendMessage(
                                              "bookingCancelByDriver", {
                                            'booking_id': acceptRideController
                                                .data.bookingData!.bookingId,
                                            'reasonOfCancel':
                                                acceptRideController
                                                    .cancelReasonTxt.value,
                                          });
                                        }
                                      } else {
                                        showFlutterToast(
                                            message:
                                                AppConstents().txtSelectReason);
                                      }
                                    },
                                    title: AppConstents().CancelRide))
                          ],
                        ),
                      ),
                    ),
                  );
                }));

                // Get.back();
              },
              title: AppConstents().CancelRide),

          // title: AppLocalizations.of(Get.key.currentContext!)!.txt_no),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    } else if (acceptRideController.rideStatus.value == 2) {
      return Container(
        margin: const EdgeInsetsDirectional.only(
            top: 15, bottom: 40, start: 90, end: 90),
        child: CommonButton(
            color: ConstColor.codeTextButtonColor,
            txtStyle: buttonBlackTitle,
            onPressed: () {
              acceptRideController.completedBooking();
            },
            title: AppConstents().completeRide),
      );
    } else if (acceptRideController.rideStatus.value == 3) {
      // rideComplete();
      return Column(
        children: [
          Obx(() => Container(
              margin: const EdgeInsetsDirectional.only(
                  top: 5, bottom: 2, start: 50, end: 50),
              child: Text(
                UserSession.getStringFromSession(
                            UserSession.currencyPosition) ==
                        "0"
                    ? "${AppConstents().ToatlAmount} : ${UserSession.getStringFromSession(UserSession.currencySymbol)} ${double.parse(acceptRideController.totalPrice.value.toString()).toStringAsFixed(2)}"
                    : "${AppConstents().ToatlAmount} : ${double.parse(acceptRideController.totalPrice.value.toString()).toStringAsFixed(2)} ${UserSession.getStringFromSession(UserSession.currencySymbol)}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ))),
          Container(
              margin: const EdgeInsetsDirectional.only(
                  top: 15, bottom: 5, start: 50, end: 50),
              child: CommonButton(
                  width: 180,
                  color: ConstColor.codeTextButtonColor,
                  txtStyle: buttonBlackTitle,
                  onPressed: () {},
                  title: AppLocalizations.of(Get.key.currentContext!)!
                      .txt_wait_for_payment)),
          Container(
              margin: const EdgeInsetsDirectional.only(
                  top: 5, bottom: 20, start: 50, end: 50),
              child: GreyButton(
                  onPressed: () {
                    Get.dialog(
                      WillPopScope(
                          onWillPop: () async => false,
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
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
                                  SocketConnection.sendMessage(
                                      "booking_payment", {
                                    "booking_id": acceptRideController
                                        .data.bookingData!.bookingId,
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
                  },
                  title: AppConstents().txtCashReceived))
        ],
      );
    }
  }
}

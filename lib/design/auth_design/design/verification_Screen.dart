// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/style.dart';
import '../../../utils/toast.dart';
import '../../../utils/user_session.dart';
import '../../controller/auth_controller.dart';
import '../custom_widget/commonbutton.dart';
import 'package:get/get.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerficationScreen extends StatefulWidget {
  static String routeName = "VerficationScreen";
  const VerficationScreen({Key? key}) : super(key: key);

  @override
  State<VerficationScreen> createState() => _VerficationScreenState();
}

class _VerficationScreenState extends State<VerficationScreen> {
  var authCoontroller = Get.find<AuthController>();
  bool stopTimer = false;
  var f = NumberFormat('00');
  int _minutes = 2;
  int _seconds = 00;
  Timer? _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
    UserSession.isCurrentLoading = authCoontroller.isLoading;
  }

  @override
  void dispose() {
    _stopTimer();
    authCoontroller.otpConttroller.clear();
    super.dispose();
  }

  bool obsecureTextShow = true;

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _seconds = 00;
      _minutes = 2;
      stopTimer = false;
    }
  }

  void _startTimer() {
    // log('_startTimer');

    if (_timer != null) {
      _stopTimer();
    }
    if (_minutes > 0) {
      _seconds = _minutes * 60;
    }
    if (_seconds > 60) {
      _minutes = (_seconds / 60).floor();
      _seconds -= (_minutes * 60);
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _seconds = 59;
            _minutes--;
          } else {
            _timer!.cancel();

            stopTimer = true;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return
          //  Container(
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   decoration: authBgDecoration,
          //   child:
          ProgressHUD(
        inAsyncCall: authCoontroller.isLoading.value,
        child: Scaffold(
            backgroundColor: ConstColor.codeBackgroundColor,
            appBar: AppBar(
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: IconButton(
                    onPressed: () {
                      Get.back(canPop: true);
                    },
                    icon: Image.asset(
                      AppConstents.arrowBack,
                      color: ConstColor.accentColor,
                      height: 20,
                      width: 20,
                    )),
              ),
              backgroundColor: Colors.transparent,
            ),

            // resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(start: 30, end: 30),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const BlueCurveLogoWidget(),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.center,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        AppLocalizations.of(Get.key.currentContext!)!
                            .txt_verification,
                        style: loginHeadingStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.red,
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 25),
                    alignment: AlignmentDirectional.center,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        AppLocalizations.of(Get.key.currentContext!)!
                            .txt_enter_code_we_sent,
                        textAlign: TextAlign.center,
                        style: black14Normal400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.red,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Text(
                        AppConstents().txtEnterotp,
                        textAlign: TextAlign.center,
                        style: black14Normal400,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // AllInputDesign(
                          //   inputHeaderName: "Enter OTP",
                          //   controller: authCoontroller.otpConttroller,
                          //   keyBoardType: TextInputType.number,
                          //   textInputAction: TextInputAction.next,
                          //   hintText: "",
                          //   maxlength: 4,
                          // ),

                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ConstColor.accentColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Stack(
                                children: [
                                  PinCodeTextField(
                                    keyboardType: TextInputType.number,
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ConstColor.codeFieldTextColor),
                                    length: 4,
                                    obscureText: false,
                                    animationType: AnimationType.fade,
                                    cursorColor: ConstColor.codeFieldTextColor,
                                    cursorHeight: 16,
                                    autoFocus: true,
                                    pinTheme: PinTheme(
                                      borderWidth: 1,
                                      inactiveFillColor: ConstColor.accentColor,
                                      activeFillColor: ConstColor.accentColor,
                                      selectedFillColor: ConstColor.accentColor,
                                      selectedColor: ConstColor.accentColor,
                                      activeColor: ConstColor.accentColor,
                                      inactiveColor: ConstColor.accentColor,
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      fieldHeight: 26,
                                      fieldOuterPadding:
                                          EdgeInsetsDirectional.only(
                                              start: 5, end: 5, top: 5),
                                    ),
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    //backgroundColor: ConstColor.accentColor,
                                    enableActiveFill: true,
                                    // controller: textEditingController,
                                    onCompleted: (v) {
                                      debugPrint("Completed");
                                      otpValidation();
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        authCoontroller.otpConttroller.text =
                                            value;
                                      });
                                      debugPrint(value);
                                    },
                                    beforeTextPaste: (text) {
                                      return true;
                                    },
                                    appContext: context,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // SizedBox(
                                      //   width: 50,
                                      // ),
                                      Container(
                                        width: 2,
                                        height: 22,
                                        margin:
                                            EdgeInsetsDirectional.only(top: 5),
                                        alignment: Alignment.center,
                                        color: ConstColor.codeFieldTextColor,
                                      ),
                                      // SizedBox(
                                      //   width: 55,
                                      // ),
                                      Container(
                                        width: 2,
                                        height: 22,
                                        margin:
                                            EdgeInsetsDirectional.only(top: 5),
                                        alignment: Alignment.center,
                                        color: ConstColor.codeFieldTextColor,
                                      ),
                                      // SizedBox(
                                      //   width: 55,
                                      // ),
                                      Container(
                                        width: 2,
                                        height: 22,
                                        margin:
                                            EdgeInsetsDirectional.only(top: 5),
                                        alignment: Alignment.center,
                                        color: ConstColor.codeFieldTextColor,
                                      )
                                    ],
                                  )
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 1),
                                // color: Colors.red,
                                // alignment: AlignmentDirectional.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 4, vertical: 4),
                                  child: stopTimer == false
                                      ? Text(
                                          "${f.format(_minutes)} : ${f.format(_seconds)}",
                                          textAlign: TextAlign.right,
                                          style: black14Normal400,
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              stopTimer = true;
                                              _startTimer();
                                            });

                                            authCoontroller
                                                .resendOtpRequestApi();
                                            log("stopTimer $stopTimer");
                                          },
                                          child: Text(
                                            AppLocalizations.of(
                                                    Get.key.currentContext!)!
                                                .txt_resend_otp,
                                            textAlign: TextAlign.right,
                                            style: black14Normal400,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 39),
                          // CommonButton(
                          //   onPressed: () {
                          //     FocusScope.of(context).unfocus();
                          //     log("verify click");

                          //     otpValidation();
                          //     // Get.toNamed("HomeScreen");
                          //   },
                          //   title: AppLocalizations.of(Get.key.currentContext!)!
                          //       .txt_verify,
                          // ),
                          // const SizedBox(height: 25),
                        ]),
                  )
                ],
              ),
            )),
      );
    });
  }

  void otpValidation() async {
    var otpErrorMessage = await authCoontroller.otpValidationError();
    if (authCoontroller.otpConttroller.text.toString().trim().length == 4) {
      Helper.verifyInternet().then((intenet) async {
        // ignore: unnecessary_null_comparison
        if (intenet != null && intenet) {
          await authCoontroller.verifyOtpRequestApi();
        } else {
          Helper.createSnackBar(context);
        }
      });
    } else if (otpErrorMessage.toString().isNotEmpty) {
      // ignore: use_build_context_synchronously
      showFlutterToast(message: otpErrorMessage.toString());
    }
  }
}

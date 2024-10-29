import 'package:flutter/material.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/user_session.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/style.dart';
import '../../../utils/toast.dart';
import '../../controller/auth_controller.dart';
import '../custom_widget/commonbutton.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SocialLoginScreen extends StatefulWidget {
  static String routeName = "SocialLoginScreen";
  const SocialLoginScreen({Key? key}) : super(key: key);

  @override
  State<SocialLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SocialLoginScreen> {
  var authController = Get.find<AuthController>();
  String lastCountryCode = "";
  String lastCountryName = "";

  @override
  void initState() {
    super.initState();
    UserSession.isCurrentLoading = authController.isLoading;
    lastCountryCode = authController.phoneCodeController.value.text;
    lastCountryName = authController.selectedCountryCode.value;
  }

  @override
  void dispose() {
    authController.socialPhoneController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // decoration: const BoxDecoration(
            //     image: DecorationImage(
            //   image: AssetImage(AppConstents.splashScreenBg),
            //   fit: BoxFit.fill,
            // )),
            child: ProgressHUD(
              inAsyncCall: authController.isLoading.value,
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  resizeToAvoidBottomInset: false,
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 120,
                        ),
                        const BlueCurveLogoWidget(),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 50),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              AppLocalizations.of(Get.key.currentContext!)!
                                  .txt_almost_done,
                              textAlign: TextAlign.center,
                              style: black16Bold600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          margin: EdgeInsetsDirectional.only(
                              start: 50, end: 50, top: 20),
                          child: Column(children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsetsDirectional.only(
                                    start: 2, bottom: 5),
                                child: Text(
                                  AppLocalizations.of(Get.key.currentContext!)!
                                      .txt_mobile_number,
                                  style: small500TextBlack,
                                )),
                            Obx(
                              () => Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Container(
                                  //   height: 49,
                                  //   // color: Colors.red,
                                  //   decoration: whiteBg,
                                  //   alignment:
                                  //       AlignmentDirectional.bottomCenter,
                                  //   child: CountryListPick(
                                  //     useSafeArea: false,
                                  //     theme: CountryTheme(
                                  //         isShowFlag: true,
                                  //         isShowTitle: false,
                                  //         isShowCode: false,
                                  //         isDownIcon: true,
                                  //         alphabetTextColor: Colors.black,
                                  //         labelColor: Colors.black

                                  //         // showEnglishName: true,
                                  //         ),
                                  //     initialSelection: authController
                                  //         .selectedCountryCode.value,
                                  //     onChanged: (code) {
                                  //       // setState(() {
                                  //       authController.selectedCountryCode
                                  //           .value = code!.code.toString();
                                  //       authController.phoneCodeController
                                  //           .text = code.dialCode.toString();
                                  //       //});
                                  //     },
                                  //   ),
                                  // ),
                                  InkWell(
                                      onTap: () {
                                        Get.toNamed("SelectCountry");
                                      },
                                      child: Container(
                                          height: 37,
                                          width: 65,
                                          margin: EdgeInsetsDirectional.only(
                                              start: 1, end: 8),
                                          // color: Colors.red,
                                          decoration: blackBg,
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                authController
                                                    .selectedCountryFlag.value,
                                                width: 28,
                                                height: 28,
                                              ),
                                              Container(
                                                child: const Icon(
                                                  Icons.arrow_drop_down_sharp,
                                                  size: 20,
                                                  color: ConstColor.accentColor,
                                                ),
                                              )
                                            ],
                                          ))),
                                  // Expanded(
                                  //   child: AllInputDesign(
                                  //     inputHeaderName: AppLocalizations.of(
                                  //             Get.key.currentContext!)!
                                  //         .txt_mobile_number,
                                  //     controller:
                                  //         authController.socialPhoneController,
                                  //     keyBoardType: TextInputType.phone,
                                  //     textInputAction: TextInputAction.next,
                                  //     hintText: "",
                                  //     prefixText: authController
                                  //         .phoneCodeController.text,
                                  //     maxlength: 17,
                                  //   ),
                                  // ),

                                  Expanded(
                                    child: Container(
                                      height: 37,
                                      // width: 45,
                                      decoration: blackBg,
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: TextFormField(
                                        maxLength: 17,
                                        textAlign: TextAlign.start,
                                        readOnly: false,
                                        cursorColor: ConstColor.accentColor,
                                        // onSaved: widget.onSaved,
                                        textInputAction: TextInputAction.next,

                                        style: const TextStyle(
                                          color: ConstColor.accentColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.8,
                                        ),
                                        keyboardType: TextInputType.phone,
                                        // validator: (val) =>
                                        //     widget.validator(val, widget.validatorFieldValue),
                                        controller: authController
                                            .socialPhoneController,

                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          counterText: "",
                                          filled: true,
                                          prefixText: authController
                                              .phoneCodeController.value.text,
                                          prefixStyle: const TextStyle(
                                            color: ConstColor.accentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.8,
                                          ),
                                          hintText: '',
                                          hintStyle: const TextStyle(
                                              color: ConstColor.blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),

                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 12),
                                          // focusedBorder: OutlineInputBorder(
                                          //   // borderRadius: BorderRadius.circular(15),
                                          //   borderSide: const BorderSide(
                                          //       color: ConstColor.codeFieldColor, width: 0.2),
                                          // ),
                                          // enabledBorder: OutlineInputBorder(
                                          //   //  borderRadius: BorderRadius.circular(15),
                                          //   borderSide: const BorderSide(
                                          //       color: ConstColor.codeFieldColor, width: 0.2),
                                          // ),
                                          // border: OutlineInputBorder(
                                          //     // borderRadius: BorderRadius.circular(15),
                                          //     borderSide: const BorderSide(
                                          //         color: ConstColor.codeFieldColor, width: 0.2))
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            CommonButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();

                                doValidatePhone();
                              },
                              title:
                                  AppLocalizations.of(Get.key.currentContext!)!
                                      .txt_submit,
                            ),
                            const SizedBox(height: 25),
                          ]),
                        )
                      ],
                    ),
                  )),
            ),
          ));
    });
  }

  void doValidatePhone() async {
    String errorMessage = await authController.socialLoginValidation();

    if (errorMessage.toString().isNotEmpty) {
      showFlutterToast(message: errorMessage.toString());
    } else {
      Helper.verifyInternet().then((intenet) async {
        // ignore: unnecessary_null_comparison
        if (intenet != null && intenet) {
          await authController.socialMobileUpdate();
        } else {
          Helper.createSnackBar(context);
        }
      });
    }
  }
}

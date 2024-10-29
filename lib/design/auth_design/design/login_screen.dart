import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../utils/const_color.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/style.dart';
import '../../../l10n/l10n.dart';
import '../../../utils/toast.dart';
import '../../../utils/user_session.dart';
import '../../controller/auth_controller.dart';
import '../custom_widget/commonbutton.dart';
import 'package:get/get.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    UserSession.isCurrentLoading = authController.isLoading;
    print("phoneCodeController..   " +
        authController.phoneCodeController.value.text.toString());
    print("socket at login screen..   ");
  }

  var selectedLanguage =
      AppLocalizations.of(Get.key.currentContext!)!.txt_select_lng;
  bool obsecureTextShow = true;

  DateTime? backBtnPressTime;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  var fb = FacebookLogin();

  late final Widget Function(BuildContext context, CountryCode countryCode)?
      customCountries;

  @override
  void dispose() {
    // authController.phoneController.clear();
    super.dispose();
    print("login dispose...");
    authController.isLoading.value = false;
  }

  Future<bool> _onLoginBackPressed() async {
    // //log("=-=->> ${SystemNavigator.pop()}");
    DateTime CurrentTime = DateTime.now();
    bool backButton = backBtnPressTime == null ||
        CurrentTime.difference(backBtnPressTime!) > const Duration(seconds: 3);
    //  //log(":backButton ${backButton}");
    if (backButton) {
      backBtnPressTime = CurrentTime;
      showFlutterToast(
          message:
              AppLocalizations.of(Get.key.currentContext!)!.txt_double_click,
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    Get.offAll("/");
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ProgressHUD(
          inAsyncCall: authController.isLoading.value,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: ConstColor.codeBackgroundColor,
                    // decoration: const BoxDecoration(
                    //     image: DecorationImage(
                    //   image: AssetImage(AppConstents.splashScreenBg),
                    //   fit: BoxFit.fill,
                    // )),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      // children: [
                      // SingleChildScrollView(
                      //   child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        const BlueCurveLogoWidget(),
                        const SizedBox(
                          height: 26,
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 20),
                          alignment: AlignmentDirectional.center,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              AppLocalizations.of(context)!.txt_login,
                              style: loginHeadingStyle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsetsDirectional.only(
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

                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Get.toNamed("SelectCountry");
                                      },
                                      child: Container(
                                          height: 37,
                                          width: 70,
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                  start: 1, end: 8),
                                          decoration: blackBg,
                                          // color: Colors.red,
                                          // padding:
                                          //     const EdgeInsetsDirectional.only(
                                          //         start: 10),
                                          // decoration: whiteBg,
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                authController
                                                    .selectedCountryFlag.value,
                                                width: 28,
                                                // height: 40,
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(start: 2),
                                                child: const Icon(
                                                  Icons.arrow_drop_down,
                                                  size: 20,
                                                  color: ConstColor
                                                      .codeFieldTextColor,
                                                ),
                                              )
                                            ],
                                          ))),
                                  Expanded(
                                    child: Container(
                                      height: 37,
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: TextFormField(
                                        maxLength: 17,
                                        textAlign: TextAlign.start,
                                        readOnly: false,
                                        cursorColor:
                                            ConstColor.codeFieldTextColor,
                                        textInputAction: TextInputAction.next,
                                        style: const TextStyle(
                                          color: ConstColor.codeFieldTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.8,
                                        ),
                                        keyboardType: TextInputType.phone,
                                        controller:
                                            authController.phoneController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          counterText: "",
                                          filled: true,
                                          prefixText: authController
                                              .phoneCodeController.value.text,
                                          prefixStyle: const TextStyle(
                                            color:
                                                ConstColor.codeFieldTextColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.8,
                                          ),
                                          hintText: '',
                                          hintStyle: const TextStyle(
                                              color: ConstColor.blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          fillColor: ConstColor.accentColor,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 12),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: ConstColor.accentColor,
                                                width: 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            CommonButton(
                              width: 200,
                              onPressed: () {
                                FocusScope.of(context).unfocus();

                                doValidatePhone();
                              },
                              title:
                                  AppLocalizations.of(Get.key.currentContext!)!
                                      .txt_submit,
                            ),
                            const SizedBox(height: 50),
                            // SizedBox(
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 1, vertical: 1),
                            //     child: Text(
                            //       AppLocalizations.of(Get.key.currentContext!)!
                            //           .txt_continue_with,
                            //       style: black14Normal500,
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 10),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Platform.isAndroid == true
                            //         ? InkWell(
                            //             onTap: () {
                            //               signInWithGoogle();
                            //             },
                            //             child: socialIconsButton(
                            //                 AppConstents.googleIcon),
                            //           )
                            //         : InkWell(
                            //             onTap: () {
                            //               signInWithApple();
                            //             },
                            //             child: socialIconsButton(
                            //                 AppConstents.appleIcon),
                            //           ),
                            //     const SizedBox(
                            //       width: 25,
                            //     ),
                            //     InkWell(
                            //       onTap: () {
                            //         facebookSignIn();
                            //       },
                            //       child: socialIconsButton(AppConstents.fbIcon),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 50,
                            // ),
                            Container(
                                decoration: blackBg,
                                // color: Colors.red,
                                height: 35,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    Get.bottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ), StatefulBuilder(
                                            builder: (context, setState) {
                                      return Container(
                                        color: Colors.transparent,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 200,
                                          decoration: const BoxDecoration(
                                              color: ConstColor
                                                  .codeBackgroundColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(12.0),
                                                  topRight:
                                                      Radius.circular(12.0))),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Center(
                                              //   child: Container(
                                              //     width: 72,
                                              //     height: 3,
                                              //     decoration: BoxDecoration(
                                              //         color: ConstColor
                                              //             .diividerColor,
                                              //         borderRadius:
                                              //             BorderRadius
                                              //                 .circular(50)),
                                              //   ),
                                              // ),
                                              // const SizedBox(
                                              //   height: 15,
                                              // ),
                                              // Container(
                                              //   alignment:
                                              //       AlignmentDirectional
                                              //           .center,
                                              //   child: Text(
                                              //     AppLocalizations.of(Get.key
                                              //             .currentContext!)!
                                              //         .txt_select_lng,
                                              //     style:
                                              //         largeSizeTextstyleGreen,
                                              //   ),
                                              // ),
                                              // const SizedBox(
                                              //   height: 15,
                                              // ),
                                              // Expanded(
                                              //   child:
                                              ListView.separated(
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      selected: index ==
                                                          UserSession.getLngIndex(
                                                              UserSession
                                                                  .keyLocalIndex),
                                                      onTap: () {
                                                        final locale = L10n
                                                            .all[index]
                                                            .languageCode;

                                                        UserSession.setLng(
                                                            UserSession
                                                                .keyLocalLng,
                                                            locale);
                                                        UserSession.setLngIndex(
                                                            UserSession
                                                                .keyLocalIndex,
                                                            index);

                                                        print(
                                                            "  selected local..   " +
                                                                locale
                                                                    .toString());

                                                        Get.updateLocale(
                                                            Locale(locale));

                                                        Get.offAndToNamed(
                                                            "LoginScreen");
                                                      },
                                                      trailing: Container(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                gradient: index ==
                                                                        (UserSession.getLngIndex(UserSession
                                                                            .keyLocalIndex))
                                                                    ? const LinearGradient(
                                                                        begin: AlignmentDirectional
                                                                            .topEnd,
                                                                        end: Alignment
                                                                            .bottomLeft,
                                                                        colors: [
                                                                          ConstColor
                                                                              .codeFieldTextColor,
                                                                          ConstColor
                                                                              .codeFieldTextColor,
                                                                        ],
                                                                      )
                                                                    : const LinearGradient(
                                                                        colors: [
                                                                            Colors.transparent,
                                                                            Colors.transparent,
                                                                          ])),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 18,
                                                          color: index ==
                                                                  (UserSession.getLngIndex(
                                                                      UserSession
                                                                          .keyLocalIndex))
                                                              ? ConstColor
                                                                  .accentColor
                                                              : Colors
                                                                  .transparent,
                                                        ),
                                                      ),
                                                      leading: Image.asset(
                                                        AppConstents()
                                                                .languageList[
                                                            index]['icon'],
                                                        width: 22,
                                                        height: 22,
                                                      ),
                                                      title: Text(
                                                        AppConstents()
                                                                .languageList[
                                                            index]['name'],
                                                        style: white18Bold500,
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const Divider(
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                  itemCount: AppConstents()
                                                      .languageList
                                                      .length),
                                              //)
                                            ],
                                          ),
                                        ),
                                      );
                                    }));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                                Get.key.currentContext!)!
                                            .txt_select_lng,
                                        style: fieldText12Normal500,
                                        // selectedLanguage.toString(),
                                      ),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Image.asset(
                                        color: ConstColor.codeFieldTextColor,
                                        height: 10,
                                        width: 10,
                                        AppConstents.downArrow,
                                      )
                                    ],
                                  ),
                                )),
                          ]),
                        )
                      ],
                      // ),
                    )
                    //  ],
                    ),
              )));
    });
  }

  void doValidatePhone() async {
    // authController.languageIdcontroller.text = "6317125c702ef1f992854bee";

    String errorMessage = await authController.loginValidation();

    if (errorMessage.toString().isNotEmpty) {
      // ignore: use_build_context_synchronously
      showFlutterToast(message: errorMessage.toString());
    } else {
      Helper.verifyInternet().then((intenet) async {
        // ignore: unnecessary_null_comparison
        if (intenet != null && intenet) {
          await authController.loginResuestApi();
        } else {
          Helper.createSnackBar(context);
        }
      });
    }
  }

  void facebookSignIn() async {
    print("fb.isLoggedIn..  " + fb.isLoggedIn.toString());

    fb.logOut();
    fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]).then((res) async {
      print("facebook status..  " + res.toString());
      switch (res.status) {
        case FacebookLoginStatus.success:
          print("facebook response..   ${fb.getUserProfile()}");

          // authController.languageIdcontroller.text = "6317125c702ef1f992854bee";

          fb.getUserProfile().then((value) {
            print("value.  fb..   $value");
            if (value != null) {
              authController.socialId.value = value.userId.toString();
              authController.socialType.value = "facebook";
              authController.socialName.value = value.name.toString();
              authController.socialEmail.value = "";
              authController.socialMobile.value = "";

              authController.socialLogin();
            } else {
              authController.socialId.value =
                  res.accessToken!.userId.toString();
              authController.socialType.value = "facebook";
              authController.socialName.value = "";
              authController.socialEmail.value = "";
              authController.socialMobile.value = "";

              authController.socialLogin();
            }
          });

          break;
        case FacebookLoginStatus.cancel:
          /* hideLoader();*/
          showFlutterToast(
              message: AppLocalizations.of(Get.key.currentContext!)!
                  .txt_user_cancel_process);

          break;
        case FacebookLoginStatus.error:
          // hideLoader();
          showFlutterToast(message: res.error!.developerMessage.toString());

          break;
      }
    }).catchError((e) {
      // hideLoader();
      showFlutterToast(message: e.toString());

      print(e);
    });
  }

  signInWithGoogle() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      await _googleSignIn.signIn().then((result) {
        print("SIGNIN RESULT...   $result");
        if (result != null) {
          print("SIGNIN RESULT...   $result");
          result.authentication.then((googleKey) async {
            print("google key..  $googleKey");
            if (_googleSignIn.currentUser != null) {
              print("google sign in ..   ${_googleSignIn.currentUser}");

              // authController.languageIdcontroller.text =
              //     "6317125c702ef1f992854bee";
              authController.socialId.value =
                  _googleSignIn.currentUser!.id.toString();
              authController.socialType.value = "google";
              authController.socialName.value =
                  _googleSignIn.currentUser!.displayName.toString();
              authController.socialEmail.value =
                  _googleSignIn.currentUser!.email.toString();
              authController.socialMobile.value = "";

              authController.socialLogin();
            }
          });
        }
      });
    } catch (e) {
      // hideLoader();
      print("Exception - base.dart - _signInWithGoogle():$e");
    }
  }

  signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // ignore: avoid_print
      print(
          "sogn in with apple .... 11 ${credential.authorizationCode}   ${credential.email}    ${credential.familyName}    ${credential.givenName}     ${credential.identityToken}    ${credential.state}     ${credential.userIdentifier}");

      authController.socialId.value = credential.userIdentifier.toString();
      authController.socialType.value = "apple";
      authController.socialName.value = credential.familyName.toString();
      authController.socialEmail.value = credential.email.toString();
      authController.socialMobile.value = "";

      authController.socialLogin();
    } catch (e) {
      // hideLoader();
      print("Exception - base.dart - _signInWithGoogle():" + e.toString());
    }
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/style.dart';
import 'package:madr_driver/utils/user_session.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/const_color.dart';
import '../../../utils/toast.dart';
import '../../auth_design/custom_widget/commonbutton.dart';
import '../../auth_design/custom_widget/formfield_widget.dart';
import '../controller/profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  static String routeName = "EditProfileScreen";
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var profileController = Get.find<ProfileController>();
  String imagePath = "";

  getFtyeImage(type) async {
    try {
      if (type == ImageSource.camera) {
        PermissionStatus permissionStatus = await Permission.camera.status;
        log("permissionStatus.. 11 $permissionStatus");
        if (permissionStatus.isLimited ||
            permissionStatus.isPermanentlyDenied ||
            permissionStatus.isRestricted) {
          log("permissionStatus.. denied ");
          Get.back();
          showFlutterToast(message: AppConstents().cameraSettingPermission);

          // showDialog(
          //     context: Get.key.currentContext!,
          //     barrierDismissible: false,
          //     builder: (BuildContext context) => AlertDialog(
          //         title: Text(AppLocalizations.of(Get.key.currentContext!)!
          //             .txt_camera_permission),
          //         content: Container(
          //             color: Colors.white,
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Container(
          //                     child: Text(
          //                   AppLocalizations.of(Get.key.currentContext!)!
          //                       .txt_permission_camera,
          //                   style: const TextStyle(
          //                       fontSize: 16, fontWeight: FontWeight.w400),
          //                 )),
          //                 InkWell(
          //                   onTap: () {
          //                     Get.back();
          //                     FocusManager.instance.primaryFocus?.unfocus();
          //                     openAppSettings();
          //                   },
          //                   child: Container(
          //                       decoration: linearColorDecoration,
          //                       margin: const EdgeInsetsDirectional.only(
          //                           top: 15, bottom: 10),
          //                       padding: const EdgeInsetsDirectional.only(
          //                           start: 55, end: 55, top: 8, bottom: 8),
          //                       child: Text(
          //                           AppLocalizations.of(
          //                                   Get.key.currentContext!)!
          //                               .txt_setting,
          //                           style: const TextStyle(
          //                               fontSize: 16,
          //                               fontWeight: FontWeight.w600,
          //                               color: Colors.white))),
          //                 ),
          //                 InkWell(
          //                     onTap: () {
          //                       Get.back();
          //                       FocusManager.instance.primaryFocus?.unfocus();
          //                     },
          //                     child: Container(
          //                       child: Text(
          //                           AppLocalizations.of(
          //                                   Get.key.currentContext!)!
          //                               .txt_im_sure,
          //                           style: const TextStyle(
          //                             fontSize: 14,
          //                             fontWeight: FontWeight.w600,
          //                           )),
          //                     ))
          //               ],
          //             ))));
        } else if (permissionStatus.isGranted) {
          log(type.toString());
          Get.back();
          FocusManager.instance.primaryFocus?.unfocus();
          ImageController.instance.cropImageFromFile(type).then((value) {
            log(value!.path.toString());
            imagePath = value.path;
            String fileName = value.path.split('/').last;

            profileController.updateUserProfileImgReq(value.path, fileName);
            setState(() {});
          });
        } else if (permissionStatus.isDenied) {
          Get.back();
          FocusManager.instance.primaryFocus?.unfocus();
          var data = await Permission.camera.request();
          if (data == PermissionStatus.granted) {
            ImageController.instance.cropImageFromFile(type).then((value) {
              log(value!.path.toString());
              imagePath = value.path;
              String fileName = value.path.split('/').last;

              profileController.updateUserProfileImgReq(value.path, fileName);
              setState(() {});
            });
          } else {
            showFlutterToast(message: AppConstents().cameraSettingPermission);
          }
        }
      } else if (type == ImageSource.gallery) {
        if (Platform.isIOS || Platform.isAndroid) {
          Get.back();
          ImageController.instance.cropImageFromFile(type).then((value) {
            log(value!.path.toString());
            imagePath = value.path;
            String fileName = value.path.split('/').last;

            profileController.updateUserProfileImgReq(value.path, fileName);
            setState(() {});
          });
        } else {
          PermissionStatus permissionStatus =
              await Permission.storage.request();
          log("permissionStatus..222  $permissionStatus");
          if (permissionStatus.isLimited ||
              permissionStatus.isDenied ||
              permissionStatus.isRestricted) {
            Get.back();
            FocusManager.instance.primaryFocus?.unfocus();
            showFlutterToast(message: AppConstents().gallerySettingPermission);
          } else if (permissionStatus.isGranted) {
            log(type.toString());
            Get.back();
            FocusManager.instance.primaryFocus?.unfocus();

            ImageController.instance.cropImageFromFile(type).then((value) {
              log(value!.path.toString());
              imagePath = value.path;
              String fileName = value.path.split('/').last;

              profileController.updateUserProfileImgReq(value.path, fileName);
              setState(() {});
            });
          } else if (permissionStatus.isPermanentlyDenied) {
            showFlutterToast(message: AppConstents().gallerySettingPermission);
          }
        }
      }
    } catch (e) {
      print("Exception - profile_picture.dart - selectImageFromGallery()$e");
    }
  }

  @override
  void initState() {
    // profileController.getProfileRequest();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserSession.isCurrentLoading = profileController.isLoading;

      profileController.genderlist.value = [
        AppConstents().txtMale,
        AppConstents().txtFemale,
        // AppConstents().txtOther
      ];
      profileController.genderTxt.value = AppConstents().txtMale;

      profileController.driverTypeList.value = [
        AppConstents().txtDailyRide,
        // AppConstents().txtRentalRide
      ];
      // profileController.rideTypeTxt.value = AppConstents().txtDailyRide;

      profileController.emailController.text =
          UserSession.getStringFromSession(UserSession.keyUserEmail) ?? "";
      profileController.nameController.text =
          UserSession.getStringFromSession(UserSession.keyUserName) ?? "";
      profileController.phoneController.text =
          UserSession.getStringFromSession(UserSession.keyUserMobile) ?? "";
      profileController.mobileController.text =
          UserSession.getStringFromSession(UserSession.keyUserMobile) ?? "";
      profileController.countryCodeController.text =
          UserSession.getStringFromSession(UserSession.keyUserCountryCode) ??
              "";
      String rideType =
          UserSession.getStringFromSession(UserSession.keyRideType) ?? "0";
      debugPrint("DABKDHBJ $rideType");
      if (rideType == '0') {
        profileController.rideTypeTxt.value = AppConstents().txtDailyRide;
      } else {
        profileController.rideTypeTxt.value = AppConstents().txtRentalRide;
      }
      // profileController.rideTypeTxt.value = AppConstents().txtDailyRide;
      profileController.genderTxt.value =
          UserSession.getStringFromSession(UserSession.keyUserGender) ?? "";
      profileController.profilePic.value =
          UserSession.getStringFromSession(UserSession.keyUserProfile) ?? "";
      profileController.isLoading.value = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("==-=-=->>> ${profileController.genderTxt.value}");
    return Obx(() {
      return ProgressHUD(
          inAsyncCall: profileController.isLoading.value,
          child: Scaffold(
              backgroundColor: ConstColor.accentColor,
              appBar: ReusableWidgets.getAppBar(
                  AppLocalizations.of(Get.key.currentContext!)!
                      .txt_edit_profile),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    prifileWidget(context),
                    const SizedBox(height: 20),
                    EditProfileAllInputDesing(
                      controller: profileController.nameController,
                      keyBoardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      hintText: AppLocalizations.of(Get.key.currentContext!)!
                          .txt_name,
                      maxlength: 35,
                    ),
                    const SizedBox(height: 20),
                    EditProfileAllInputDesing(
                      controller: profileController.emailController,
                      keyBoardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: AppLocalizations.of(Get.key.currentContext!)!
                          .txt_email,
                      // maxlength: 40,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      alignment: Alignment.center,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 42,
                          margin: const EdgeInsetsDirectional.only(
                              start: 20, end: 20),
                          padding: const EdgeInsetsDirectional.only(
                              start: 10, end: 10),
                          alignment: AlignmentDirectional.centerStart,
                          decoration: BoxDecoration(
                              // color: ConstColor.codeHeadingColor,
                              border: Border.all(
                                  color: ConstColor.codeFieldTextColor),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "${profileController.countryCodeController.value.text} ${profileController.phoneController.value.text}",
                            style: const TextStyle(
                              color: ConstColor.blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              // letterSpacing: 0.8,
                            ),
                          )),
                    ),
                    // Padding(
                    //   padding: const EdgeInsetsDirectional.only(start: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment
                    //         .center, // Aligns items in the center vertically
                    //     children: [
                    //       Container(
                    //         width: 120,
                    //         height: 45,
                    //         child: EditProfileAllInputDesing(
                    //           readonly: true,
                    //           controller:
                    //               profileController.countryCodeController,
                    //           keyBoardType: TextInputType.phone,
                    //           textInputAction: TextInputAction.done,
                    //           maxlength: 5,
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //           width:
                    //               10), // Add space between country code and phone number
                    //       Expanded(
                    //         child: EditProfileAllInputDesing(
                    //           readonly: true,
                    //           controller: profileController.phoneController,
                    //           keyBoardType: TextInputType.phone,
                    //           textInputAction: TextInputAction.done,
                    //           hintText:
                    //               AppLocalizations.of(Get.key.currentContext!)!
                    //                   .txt_phone_number,
                    //           maxlength: 17,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Padding(
                    //   padding: EdgeInsetsDirectional.only(start: 20),
                    //   // alignment: AlignmentDirectional.center,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // EditProfileAllInputDesing(
                    //       //   readonly: true,
                    //       //   controller: profileController.countryCodeController,
                    //       //   keyBoardType: TextInputType.emailAddress,
                    //       //   textInputAction: TextInputAction.next,
                    //       //   hintText:
                    //       //       AppLocalizations.of(Get.key.currentContext!)!
                    //       //           .txt_phone_number,
                    //       //   // maxlength: 40,
                    //       // ),
                    //       // Expanded(
                    //       //   child: EditProfileAllInputDesing(
                    //       //     readonly: true,
                    //       //     controller: profileController.phoneController,
                    //       //     keyBoardType: TextInputType.emailAddress,
                    //       //     textInputAction: TextInputAction.next,
                    //       //     hintText:
                    //       //         AppLocalizations.of(Get.key.currentContext!)!
                    //       //             .txt_phone_number,
                    //       //     // maxlength: 40,
                    //       //   ),
                    //       // ),
                    //       Container(
                    //         width: 120,
                    //         height: 45,
                    //         child: EditProfileAllInputDesing(
                    //           readonly: true,
                    //           controller:
                    //               profileController.countryCodeController,
                    //           keyBoardType: TextInputType.phone,
                    //           textInputAction: TextInputAction.done,
                    //           maxlength: 2,
                    //         ),
                    //       ),
                    //       // Column(
                    //       //   children: [
                    //       //     Container(
                    //       //         height: 45,
                    //       //         width: 45,
                    //       //         alignment: AlignmentDirectional.center,
                    //       //         child: TextFormField(
                    //       //           controller:
                    //       //               profileController.countryCodeController,
                    //       //           keyboardType: TextInputType.phone,
                    //       //           textInputAction: TextInputAction.done,
                    //       //           enabled: false,
                    //       //           style: const TextStyle(
                    //       //             color: ConstColor.blackColor,
                    //       //             fontSize: 15,
                    //       //             fontWeight: FontWeight.w600,
                    //       //             // letterSpacing: 0.8,
                    //       //           ),
                    //       //           decoration: InputDecoration(
                    //       //             border: InputBorder.none,
                    //       //             hintStyle: appbarTextStyle,
                    //       //             // contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                    //       //           ),
                    //       //         )),
                    //       //     Container(
                    //       //       margin: const EdgeInsetsDirectional.symmetric(
                    //       //           horizontal: 15),
                    //       //       width: 55,
                    //       //       height: 2,
                    //       //       color: ConstColor.blackColor,
                    //       //     )
                    //       //   ],
                    //       // ),

                    const SizedBox(height: 30),
                    Container(
                        margin: const EdgeInsetsDirectional.only(
                            start: 30, end: 30),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          AppConstents().txtGender,
                          style: black16Bold600,
                        )),
                    const SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: 200,
                      margin:
                          const EdgeInsetsDirectional.only(start: 15, end: 15),
                      alignment: AlignmentDirectional.topStart,
                      child: RadioGroup<String>.builder(
                        direction: Axis.horizontal,
                        groupValue: profileController.genderTxt.value,
                        horizontalAlignment: MainAxisAlignment.center,
                        activeColor: ConstColor.blackColor,
                        fillColor: ConstColor.blackColor,
                        onChanged: (value) {
                          if (kDebugMode) {
                            print("gender preference ,,,   $value");
                          } else {
                            print("gender preference ,,,  11 $value");
                          }
                          profileController.genderTxt.value = value ?? '';
                        },
                        items: profileController.genderlist,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: ConstColor.blackColor,
                        ),
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    // Container(
                    //     margin: const EdgeInsetsDirectional.only(
                    //         start: 30, end: 30),
                    //     alignment: AlignmentDirectional.centerStart,
                    //     child: Text(
                    //       AppConstents().txtRideType,
                    //       style: black16Bold600,
                    //     )),
                    // const SizedBox(height: 10),
                    // Container(
                    //   height: 40,
                    //   margin:
                    //       const EdgeInsetsDirectional.only(start: 15, end: 15),
                    //   alignment: AlignmentDirectional.topStart,
                    //   child: RadioGroup<String>.builder(
                    //     direction: Axis.horizontal,
                    //     groupValue: profileController.rideTypeTxt.value,
                    //     horizontalAlignment: MainAxisAlignment.spaceBetween,
                    //     activeColor: ConstColor.blackColor,
                    //     fillColor: ConstColor.blackColor,
                    //     onChanged: (value) {
                    //       profileController.rideTypeTxt.value = value ?? '';
                    //     },
                    //     items: profileController.driverTypeList,
                    //     textStyle: const TextStyle(
                    //       fontSize: 14,
                    //       color: ConstColor.blackColor,
                    //     ),
                    //     itemBuilder: (item) => RadioButtonBuilder(
                    //       item,
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 80),
                    CommonButton(
                      width: 180,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        updateProfilevalidate();
                      },
                      title: AppLocalizations.of(Get.key.currentContext!)!
                          .txt_done,
                    ),
                  ],
                ),
              ))));
    });
  }

  Widget prifileWidget(BuildContext context) {
    print("imagePath.. imagePath  ..   " + imagePath.toString());
    print("imagePath.. imagePath  ..   " +
        profileController.profilePic.value.toString());
    return GestureDetector(
      onTap: () {
        openCamerGallertPopUp();
      },
      child: Container(
        alignment: AlignmentDirectional.center,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Obx(() => Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(72),
                      child: profileController.isUploadingImg.value == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : imagePath.toString().isNotEmpty
                              ? Image.file(
                                  File(imagePath),
                                  height: 72,
                                  width: 72,
                                  fit: BoxFit.fill,
                                )
                              : (profileController.profilePic.value
                                          .toString()
                                          .isEmpty ||
                                      profileController.profilePic.value ==
                                          "0" ||
                                      profileController.profilePic.value ==
                                          "null")
                                  ? Icon(
                                      Icons.account_circle,
                                      color: ConstColor.blackColor,
                                      size: 67,
                                    )
                                  // Image.asset(
                                  //     "assets/images/userErrImg.png",
                                  //     height: 60,
                                  //     width: 60,
                                  //     fit: BoxFit.fill,
                                  //   )
                                  : Image.network(
                                      profileController.profilePic.value
                                          .toString(),
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.fill,
                                    )),
                )),
            Positioned(
                bottom: 4,
                left: MediaQuery.of(context).size.width * 0.54,
                child: Image.asset(
                  "assets/images/camera_image.png",
                  color: ConstColor.codeFieldTextColor,
                  height: 25,
                  width: 25,
                ))
          ],
        ),
      ),
    );
  }

  void updateProfilevalidate() async {
    String errorText = await profileController.validationProfile();

    if (errorText.toString().isNotEmpty) {
      showFlutterToast(message: errorText.toString());
    }
    //  else if ((UserSession.getIntFromSession(
    //             UserSession.keyCurrentBookingStatus) !=
    //         0) &&
    //     (UserSession.getStringFromSession(UserSession.keyRideType) !=
    //         profileController.driverType())) {
    //   showFlutterToast(message: AppConstents().txtCantUpdateRide);
    // }
    else {
      Helper.verifyInternet().then((intenet) async {
        // ignore: unnecessary_null_comparison
        if (intenet != null && intenet) {
          await profileController.updateProfileRequest();
        } else {
          Helper.createSnackBar(context);
        }
      });
    }
  }

  openCamerGallertPopUp() {
    Platform.isIOS
        ? showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(Get.key.currentContext!)!.txt_cancel,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  onPressed: () {
                    getFtyeImage(ImageSource.camera);
                  },
                  child: Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_camera,
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    getFtyeImage(ImageSource.gallery);
                  },
                  child: Text(AppLocalizations.of(Get.key.currentContext!)!
                      .txt_gallery),
                ),
              ],
            ),
          )
        : showModalBottomSheet<void>(
            context: context,
            backgroundColor: ConstColor.codeFieldColor,
            builder: (BuildContext context) {
              return SafeArea(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      title: Text(AppLocalizations.of(Get.key.currentContext!)!
                          .txt_camera),
                      onTap: () {
                        getFtyeImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                        title: Text(
                            AppLocalizations.of(Get.key.currentContext!)!
                                .txt_gallery),
                        onTap: () {
                          getFtyeImage(ImageSource.gallery);
                        }),
                  ],
                ),
              );
            },
          );
  }
}

class ImageController {
  static ImageController get instance => ImageController();
  final ImagePicker _picker = ImagePicker();
  late File imageFileFromLibrary;
  Future<CroppedFile?> cropImageFromFile(type) async {
    if (type == ImageSource.gallery) {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, requestFullMetadata: false);
      imageFileFromLibrary = File(pickedFile!.path);
    } else if (type == ImageSource.camera) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      imageFileFromLibrary = File(pickedFile!.path);
    }

    // Start crop iamge then take the file.
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFileFromLibrary.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );

    // var _compressedImage = await AppHelper.compress(image: croppedFile);

    return croppedFile;
  }
}

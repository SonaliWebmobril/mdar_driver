import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/app_constents.dart';
import 'package:http/http.dart' as http;
import '../../../services/api_sevices.dart';
import '../../../utils/user_session.dart';
import '../design/edit_profile_screen.dart';

class SupportController extends GetxController {
  var isLoading = false.obs;
  NetworkServices networkServices = NetworkServices();
  Rx<TextEditingController> etSupport = TextEditingController().obs;
  RxInt etSupportLength = 0.obs;
  RxString fileName = "".obs;
  RxString path = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    log("disp controller");
    super.dispose();
  }

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
            path.value = value.path;
            fileName.value = value.path.split('/').last;
            log("message fileName ${fileName.value} ...path... ${path.value}");
          });
        } else if (permissionStatus.isDenied) {
          Get.back();
          FocusManager.instance.primaryFocus?.unfocus();
          Permission.camera.request();
        }
      } else if (type == ImageSource.gallery) {
        if (Platform.isIOS || Platform.isAndroid) {
          Get.back();
          ImageController.instance.cropImageFromFile(type).then((value) {
            log(value!.path.toString());
            path.value = value.path;
            fileName.value = value.path.split('/').last;
            log("message fileName ${fileName.value} ...path... ${path.value}");
          });
        } else {
          Get.back();
          PermissionStatus permissionStatus =
              await Permission.storage.request();
          log("permissionStatus..222  " + permissionStatus.toString());
          if (permissionStatus.isLimited ||
              permissionStatus.isDenied ||
              permissionStatus.isRestricted) {
            Get.back();
            FocusManager.instance.primaryFocus?.unfocus();
            showFlutterToast(message: AppConstents().gallerySettingPermission);
            // showDialog(
            //     context: Get.key.currentContext!,
            //     barrierDismissible: false,
            //     builder: (BuildContext context) => AlertDialog(
            //         title: Text(AppLocalizations.of(Get.key.currentContext!)!
            //             .txt_gallery_permission),
            //         content: Container(
            //             color: Colors.white,
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 Container(
            //                     child: Text(
            //                   AppLocalizations.of(Get.key.currentContext!)!
            //                       .txt_permision_gallery,
            //                   style: const TextStyle(
            //                       fontSize: 16, fontWeight: FontWeight.w400),
            //                 )),
            //                 InkWell(
            //                   onTap: () {
            //                     Get.back();
            //                     FocusManager.instance.primaryFocus?.unfocus();
            //                     Permission.storage.request();
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
            //                               .txt_retry,
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
              path.value = value.path;
              fileName.value = value.path.split('/').last;
              log("message fileName ${fileName.value} ...path... ${path.value}");
            });
          } else if (permissionStatus.isPermanentlyDenied) {
            //  openAppSettings();
            showFlutterToast(message: AppConstents().gallerySettingPermission);
          }
        }
      }
    } catch (e) {
      print("Exception - profile_picture.dart - selectImageFromGallery()$e");
    }
  }

  Future<void> requestSendQueries() async {
    update();
    try {
      var headers = {
        'authorization':
            'bearer ${UserSession.getStringFromSession(UserSession.keyUserToken)}'
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('${AppConstents.baseUrl}send_query'));
      request.fields.addAll({'message': etSupport.value.text.toString()});
      if (path.value.toString().isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('document', path.value));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      final responseJson = jsonDecode(await response.stream.bytesToString());
      print("response json...   $responseJson");
      if (response.statusCode == 200) {
        // supportResponseModel = SupportResponseModel.fromJson(responseJson);
        showFlutterToast(message: responseJson['ResponseMessage']);
        isLoading(false);
        path.value = "";
        fileName.value = "";
        etSupport.value.text = "";
        etSupportLength.value = 0;
        update();
      } else {
        // supportResponseModel = SupportResponseModel.fromJson(responseJson);
        isLoading(false);
        update();
      }
    } catch (e) {
      isLoading(false);
      update();
      log(e.toString());
    }
  }

  String doValidate() {
    if (etSupport.value.text.toString().isEmpty) {
      return AppConstents().enterqueries;
    }
    if (etSupport.value.text.toString().trim().length < 10) {
      return AppConstents().queregreater;
    }

    return "";
  }
}

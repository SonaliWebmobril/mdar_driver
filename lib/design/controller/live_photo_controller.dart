import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/style.dart';
import '../../services/api_sevices.dart';
import '../../utils/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:path_provider/path_provider.dart';

import '../settings/design/edit_profile_screen.dart';

class LivePhotoController extends GetxController {
  late Rx<CameraController?> _controller;
  late RxBool isCameraInitialize;
  RxInt changeCamera = 1.obs;
  var path = "".obs;
  var filename = "".obs;
  NetworkServices networkServices = NetworkServices();
  var isLoading = false.obs;

  LivePhotoController() {
    _controller = Rx<CameraController?>(null);
    isCameraInitialize = RxBool(false);
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> updateProfile() async {
    try {
      print("update image,.. ");
      final response =
          await networkServices.udateProfilePick(path.value, filename.value);
      print("update image,..   " + response.toString());
      print("update image,..  response code  ");
      print("update image,..   " + (response['ResponseCode'].toString()));
      if (response['ResponseCode'] == 200) {
        isLoading.value = false;
        path.value = "";
        filename.value = "";
        Get.offAndToNamed("ThankYouScreen");
      } else {
        isLoading.value = false;
        showFlutterToast(message: response['ResponseMessage']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  CameraController? get controller => _controller.value;
  // bool get isCameraInitialized => isCameraInitialize.value;

  Future<String?> onTakePicture() async {
    try {
      XFile file = await controller!.takePicture();

      // Save the image to the application documents directory
      String savedImagePath = await _saveImageToDocumentsDirectory(file.path);
      return savedImagePath;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<String> _saveImageToDocumentsDirectory(String imagePath) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/ompariwar';
    await Directory(dirPath).create(recursive: true);

    final String fileName =
        'captured_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String filePath = '$dirPath/$fileName';

    print("save file path...  " + filePath.toString());

    // Read the image file
    final Uint8List imageBytes = File(imagePath).readAsBytesSync();
    img.Image image = img.decodeImage(imageBytes)!;

    // Check the EXIF orientation and apply the necessary transformation
    // if (image.exif.hasOrientation ?? false) {
    //   image = img.exif.rotate(image);
    // }

    // Write the corrected image back to the file
    File(filePath).writeAsBytesSync(img.encodeJpg(image));

    return filePath;
  }

  // Future<void> loadCamera() async {
  //   PermissionStatus permissionStatus = await Permission.camera.request();
  //   if (permissionStatus.isGranted) {
  //     List<CameraDescription> cameras = await availableCameras();
  //     if (cameras.isNotEmpty) {
  //       _controller.value = CameraController(
  //         cameras[changeCamera.value],
  //         ResolutionPreset.medium,
  //         enableAudio: false,
  //       );
  //       await _controller.value!.initialize();
  //       _isCameraInitialized.value = true;
  //     } else {
  //       print("No cameras found.");
  //     }
  //   } else {
  //     print("Camera permission denied.");
  //   }
  // }

  Future<void> loadCamera() async {
    PermissionStatus permissionStatus = await Permission.camera.status;
    print("permissionStatus..222  " + permissionStatus.toString());
    if (permissionStatus.isLimited ||
        permissionStatus.isPermanentlyDenied ||
        permissionStatus.isRestricted) {
      // Get.back();
      FocusManager.instance.primaryFocus?.unfocus();
      showDialog(
          context: Get.key.currentContext!,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(Get.key.currentContext!)!
                  .txt_camera_permission),
              content: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          child: Text(
                        AppLocalizations.of(Get.key.currentContext!)!
                            .txt_permission_camera,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      )),
                      InkWell(
                        onTap: () {
                          Get.back();
                          FocusManager.instance.primaryFocus?.unfocus();
                          // Permission.camera.request();
                          openAppSettings();
                        },
                        child: Container(
                            decoration: linearColorDecoration,
                            margin: const EdgeInsetsDirectional.only(
                                top: 15, bottom: 10),
                            padding: const EdgeInsetsDirectional.only(
                                start: 55, end: 55, top: 8, bottom: 8),
                            child: Text(
                                AppLocalizations.of(Get.key.currentContext!)!
                                    .txt_retry,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white))),
                      ),
                      InkWell(
                          onTap: () {
                            Get.back();
                            //Get.offAndToNamed("LoginScreen");
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Container(
                            child: Text(
                                AppLocalizations.of(Get.key.currentContext!)!
                                    .txt_im_sure,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                )),
                          ))
                    ],
                  ))));
    } else if (permissionStatus.isGranted) {
      // List<CameraDescription> cameras = await availableCameras();
      // if (cameras.isNotEmpty) {
      //   _controller.value = CameraController(
      //       cameras[changeCamera.value], ResolutionPreset.medium,
      //       enableAudio: false);
      //   await _controller.value!.initialize();
      //   isCameraInitialize.value = true;
      // } else {
      //   print("No cameras found.");
      // }

      ImageController.instance
          .cropImageFromFile(ImageSource.camera)
          .then((value) async {
        if (value != null) {
          print("value.. .  " + value.path.toString());
          // path.value = value.path;
           String compressedImagePath = await compressAndSendPath(File(value.path.toString()));
           path.value = compressedImagePath;
           isCameraInitialize.value = true;
        }
        //  String fileName = value.path.split('/').last;

        //profileController.updateUserProfileImgReq(value.path, fileName);
        // setState(() {});
      });
    } else if (permissionStatus.isDenied) {
      // Get.back();
      //FocusManager.instance.primaryFocus?.unfocus();
      Permission.camera.request();
    }
  }

  cameraEnable() async {
    ImageController.instance
        .cropImageFromFile(ImageSource.camera)
        .then((value) async {
      print("value.. .  " + value!.path.toString());
      //path.value = value.path;
     // isCameraInitialize.value = true;
        print("value.. .  " + value.path.toString());
        // path.value = value.path;
         String compressedImagePath = await compressAndSendPath(File(value.path.toString()));
         print("value compress..  "+compressedImagePath);
         path.value = compressedImagePath;
         isCameraInitialize.value = true;
     });
  }

  Future<String> compressAndSendPath(File originalImagePath,
    {int quality = 80}) async {
  Uint8List originalBytes = await originalImagePath.readAsBytes();
  // Compress the image
  List<int> compressedData = await FlutterImageCompress.compressWithList(
    originalBytes,
    minHeight: 1920,
    minWidth: 1080,
    quality: quality,
  );
  // Create a new file for the compressed image
  String compressedImagePath = originalImagePath.path.replaceAll('.jpg', '_compressed.jpg');
  File compressedFile = File(compressedImagePath);

  // Write the compressed data to the new file
  await compressedFile.writeAsBytes(compressedData);

  // Return the path to the compressed image file
  return compressedImagePath;
}

  @override
  void dispose() {
    _controller.value?.dispose();
    super.dispose();
  }
}

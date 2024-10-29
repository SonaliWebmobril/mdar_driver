import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/const_color.dart';
import '../../../utils/app_constents.dart';
import '../../controller/live_photo_controller.dart';
import '../custom_widget/commonbutton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakelock/wakelock.dart';

class LivePhotoScreen extends StatefulWidget {
  static String routeName = "LivePhotoScreen";
  const LivePhotoScreen({Key? key}) : super(key: key);

  @override
  State<LivePhotoScreen> createState() => LivePhotoState();
}

class LivePhotoState extends State<LivePhotoScreen>
    with WidgetsBindingObserver {
  final LivePhotoController livePhotoController =
      Get.put(LivePhotoController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Wakelock.enable();
    livePhotoController.path.value = "";
    livePhotoController.isCameraInitialize = RxBool(false);
    livePhotoController.loadCamera();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    // livePhotoController.controller?.dispose();
    Wakelock.disable();
    print("dispose..   live photo");
    Permission.camera.status.then((value) {
      print("permissionStatus..222  " + value.toString());
      if (value.isGranted) {
        livePhotoController.isCameraInitialize.value = true;
        //livePhotoController.cameraEnable();
      } else {
        livePhotoController.isCameraInitialize.value = false;
        // livePhotoController.loadCamera();
        //livePhotoController.controller!.dispose();
      }
    });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print("::::::::::::::$state");

  //   if (state == AppLifecycleState.resumed) {
  //     print("***************>>>>>>>>>>>>>>>>::::::::::::::AppLifecycleState");
  //     Permission.camera.status.then((value) {
  //       print("permissionStatus..222  " + value.toString());
  //       if (value.isGranted) {
  //         //livePhotoController.isCameraInitialize.value = true;
  //        // livePhotoController.cameraEnable();
  //       } else {
  //         livePhotoController.isCameraInitialize.value = false;
  //         // livePhotoController.loadCamera();
  //         //livePhotoController.controller!.dispose();
  //       }
  //     });
  //   } else if (state == AppLifecycleState.inactive) {
  //     // livePhotoController.controller!.dispose();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print("build live photo..");
    return WillPopScope(
        onWillPop: () async {
          var value = await Get.offAllNamed("LoginScreen");
          return value as bool;
        },
        child: SafeArea(
            child: Scaffold(
                body: Container(
                    color: ConstColor.codeBackgroundColor,
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsetsDirectional.only(
                            top: 15, bottom: 15, start: 40, end: 20),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  AppConstents().TakeLivePhoto,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.offAndToNamed("ThankYouScreen");
                              },
                              child: Container(
                                padding: const EdgeInsetsDirectional.only(
                                    top: 6, bottom: 6, start: 18, end: 18),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: AlignmentDirectional.topEnd,
                                    end: AlignmentDirectional.bottomStart,
                                    colors: [
                                      ConstColor.blueSecondaryColor,
                                      ConstColor.bluecodeTextButtonColor,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  AppConstents().Skip,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container(child: Obx(() {
                        if (livePhotoController.isCameraInitialize.value ==
                            false) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text(
                              //   AppConstents().txtPermissionRequired,
                              //   style: const TextStyle(
                              //       fontSize: 16, color: Colors.white),
                              // ),
                              ElevatedButton(
                                onPressed: () {
                                  livePhotoController.loadCamera();
                                },
                                child: Text(AppConstents().txtClickTakePhoto),
                              ),
                            ],
                          );
                        } else if (livePhotoController.path != "") {
                          return Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      child: Image.file(File(
                                          livePhotoController.path.value)))),
                              Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      bottom: 20, start: 20, end: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        child: CommonButton(
                                            onPressed: () {
                                              livePhotoController
                                                  .cameraEnable();
                                            },
                                            title: AppConstents().Retake),
                                      ),
                                      SizedBox(
                                        width: 140,
                                        child: CommonButton(
                                            onPressed: () {
                                              livePhotoController
                                                  .updateProfile();
                                            },
                                            title: AppLocalizations.of(
                                                    Get.key.currentContext!)!
                                                .txt_upload),
                                      ),
                                    ],
                                  ))
                            ],
                          );
                        } else {
                          print("initializeinitialize");
                          return Container();

                          // return Stack(children: [
                          //   FutureBuilder<void>(
                          //       future: livePhotoController.controller!
                          //           .initialize(),
                          //       builder: (context, snapshot) {
                          //         print(
                          //             "initializeinitialize..   ${snapshot.connectionState}");
                          //         if (snapshot.connectionState ==
                          //             ConnectionState.done) {
                          //           return livePhotoController.controller!
                          //               .buildPreview();
                          //         } else {
                          //           return Center(
                          //               child: Container(
                          //                   width: 60,
                          //                   height: 60,
                          //                   child:
                          //                       CircularProgressIndicator()));
                          //         }
                          //       }),
                          // ]);
                        }
                      }))),
                      Obx(() => (livePhotoController.controller != null &&
                              livePhotoController.path.value == "")
                          ? Container(
                              alignment: Alignment.bottomCenter,
                              child: Row(children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    livePhotoController
                                        .onTakePicture()
                                        .then((value) {
                                      livePhotoController.path.value = value!;
                                      livePhotoController.filename.value =
                                          value.split('/').last;
                                    });
                                  },
                                  child: Container(
                                    transform: Matrix4.translationValues(
                                        0.0, 0.0, 0.0),
                                    // width: 80,
                                    height: 80,
                                    alignment: Alignment.center,
                                    margin:
                                        EdgeInsetsDirectional.only(bottom: 15),
                                    child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Image.asset(
                                          "assets/images/camera_click.png",
                                          height: 80,
                                          width: 80,
                                          color: Colors.white,
                                        )),
                                  ),
                                ))
                              ]),
                            )
                          : Container())
                    ])))));
  }
}

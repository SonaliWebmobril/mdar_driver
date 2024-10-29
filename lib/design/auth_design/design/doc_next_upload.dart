import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/style.dart';
import 'package:madr_driver/design/auth_design/custom_widget/commonbutton.dart';
import 'package:madr_driver/utils/docs_tile.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/toast.dart';
import '../../../utils/user_session.dart';
import '../../controller/document_upload_controller.dart';

class DocumentUploadScreen2 extends StatefulWidget {
  static String routeName = "DocumentUploadScreen2";
  const DocumentUploadScreen2({super.key});

  @override
  State<DocumentUploadScreen2> createState() => _DocumentUploadScreen2State();
}

class _DocumentUploadScreen2State extends State<DocumentUploadScreen2> {
  DocumentUploadController documentUploadController =
      Get.put(DocumentUploadController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserSession.isCurrentLoading = documentUploadController.isLoading;
  }

  genderType(String value) {
    print("gender yourGender,...  " + value);
    if (value == AppConstents().txtMale) {
      return "0";
    } else if (value == AppConstents().txtFemale) {
      return "1";
    } else if (value == AppConstents().txtNoPref) {
      return "2";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    log("dec next upload dispose......  ");
    // documentUploadController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ProgressHUD(
          inAsyncCall: documentUploadController.isMpesaLoading.value,
          child: SafeArea(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  // decoration: authBgDecoration,
                  color: ConstColor.codeBackgroundColor,
                  child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: IconButton(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: ConstColor.codeFieldTextColor,
                                  )),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 20),
                              child: Column(children: [
                                Container(
                                    child: Padding(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(
                                                    Get.key.currentContext!)!
                                                .txt_vehicle_inspection,
                                            style: drawerTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(Get
                                                                .key
                                                                .currentContext!)!
                                                            .txt_valid_from,
                                                        style:
                                                            loginFormHeadingStyle,
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Stack(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .bottomEnd,
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              // showMe(context);
                                                              documentUploadController
                                                                      .InspectionFrom
                                                                      .value =
                                                                  await documentUploadController
                                                                      .selectDate(
                                                                          context,
                                                                          "from",
                                                                          "inspection");

                                                              documentUploadController.DriverDocumentUpload(
                                                                  AppLocalizations.of(Get
                                                                          .key
                                                                          .currentContext!)!
                                                                      .txt_vehicle_inspec,
                                                                  "Vehicle Inspection",
                                                                  "",
                                                                  documentUploadController
                                                                          .InspectionFrontImage
                                                                      .toString(),
                                                                  "",
                                                                  documentUploadController
                                                                          .InspectionFrom
                                                                      .toString(),
                                                                  "");
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 140,
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .only(
                                                                      top: 5,
                                                                      bottom: 5,
                                                                      start: 8,
                                                                      end: 5),
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .centerStart,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: ConstColor
                                                                    .accentColor,
                                                              ),
                                                              child: Obx(
                                                                () => Text(
                                                                  documentUploadController
                                                                      .InspectionFrom
                                                                      .value,
                                                                  // focusNode: AlwaysDisabledFocusNode(),
                                                                  // decoration:
                                                                  //     const InputDecoration(enabledBorder: InputBorder.none),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13),
                                                                  // controller: dateAssign("from"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                              onTap: () async {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                // showMe(context);
                                                                documentUploadController
                                                                        .InspectionFrom
                                                                        .value =
                                                                    await documentUploadController.selectDate(
                                                                        context,
                                                                        "from",
                                                                        "inspection");

                                                                documentUploadController.DriverDocumentUpload(
                                                                    AppLocalizations.of(Get
                                                                            .key
                                                                            .currentContext!)!
                                                                        .txt_vehicle_inspec,
                                                                    "Vehicle Inspection",
                                                                    "",
                                                                    documentUploadController
                                                                            .InspectionFrontImage
                                                                        .toString(),
                                                                    "",
                                                                    documentUploadController
                                                                            .InspectionFrom
                                                                        .toString(),
                                                                    "");
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    AlignmentDirectional
                                                                        .centerEnd,
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ]),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(Get
                                                              .key
                                                              .currentContext!)!
                                                          .txt_upload_image,
                                                      style:
                                                          loginFormHeadingStyle,
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            documentUploadController
                                                                    .InspectionFrontImage =
                                                                await documentUploadController
                                                                    .cameraGallery(
                                                                        false);
                                                            if (documentUploadController
                                                                        .InspectionFrontImage ==
                                                                    null ||
                                                                documentUploadController
                                                                        .InspectionFrontImage ==
                                                                    "") {
                                                              documentUploadController
                                                                  .isInspectionFrontUpload
                                                                  .value = false;
                                                            } else {
                                                              documentUploadController
                                                                  .isInspectionFrontUpload
                                                                  .value = true;
                                                            }

                                                            documentUploadController.DriverDocumentUpload(
                                                                AppLocalizations
                                                                        .of(Get
                                                                            .key
                                                                            .currentContext!)!
                                                                    .txt_vehicle_inspec,
                                                                "Vehicle Inspection",
                                                                "",
                                                                documentUploadController
                                                                        .InspectionFrontImage
                                                                    .toString(),
                                                                "",
                                                                documentUploadController
                                                                        .InspectionFrom
                                                                    .toString(),
                                                                "");
                                                          },
                                                          child: Obx(
                                                            () => documentUploadController.isInspectionFrontUpload ==
                                                                    true
                                                                ? Container(
                                                                    width: 50,
                                                                    height: 30,
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                      color: ConstColor
                                                                          .accentColor,
                                                                    ),
                                                                    child: Icon(Icons
                                                                        .check))
                                                                : Container(
                                                                    width: 50,
                                                                    height: 30,
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                      color: ConstColor
                                                                          .accentColor,
                                                                    ),
                                                                    child: Text(AppLocalizations.of(Get
                                                                            .key
                                                                            .currentContext!)!
                                                                        .txt_front)),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),

                                const SizedBox(
                                  height: 10,
                                ),
                                DivTile(),
                                const SizedBox(
                                  height: 10,
                                ),

                                Container(
                                    child: Padding(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(
                                                      Get.key.currentContext!)!
                                                  .txt_vehicle_manifest,
                                              style: drawerTextStyle,
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Row(children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(Get.key
                                                            .currentContext!)!
                                                        .txt_valid_from,
                                                    style:
                                                        loginFormHeadingStyle,
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .bottomEnd,
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          // showMe(context);
                                                          documentUploadController
                                                                  .ManifestFrom
                                                                  .value =
                                                              await documentUploadController
                                                                  .selectDate(
                                                                      context,
                                                                      "from",
                                                                      "");

                                                          documentUploadController.DriverDocumentUpload(
                                                              AppLocalizations
                                                                      .of(Get
                                                                          .key
                                                                          .currentContext!)!
                                                                  .txt_vehicle_mani,
                                                              "Vehicle manifest",
                                                              "",
                                                              documentUploadController
                                                                      .ManifestFrontImage
                                                                  .toString(),
                                                              "",
                                                              documentUploadController
                                                                  .ManifestFrom
                                                                  .value
                                                                  .toString(),
                                                              "");
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 140,
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .only(
                                                                  top: 5,
                                                                  bottom: 5,
                                                                  start: 8,
                                                                  end: 5),
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .centerStart,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: ConstColor
                                                                .accentColor,
                                                          ),
                                                          child: Obx(
                                                            () => Text(
                                                              documentUploadController
                                                                  .ManifestFrom
                                                                  .value,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13),
                                                              // controller: dateAssign("from"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                          onTap: () async {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            // showMe(context);
                                                            documentUploadController
                                                                    .ManifestFrom
                                                                    .value =
                                                                await documentUploadController
                                                                    .selectDate(
                                                                        context,
                                                                        "from",
                                                                        "");
                                                            documentUploadController.DriverDocumentUpload(
                                                                AppLocalizations
                                                                        .of(Get
                                                                            .key
                                                                            .currentContext!)!
                                                                    .txt_vehicle_mani,
                                                                "Vehicle manifest",
                                                                "",
                                                                documentUploadController
                                                                        .ManifestFrontImage
                                                                    .toString(),
                                                                "",
                                                                documentUploadController
                                                                    .ManifestFrom
                                                                    .value
                                                                    .toString(),
                                                                "");
                                                          },
                                                          child: Container(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .centerEnd,
                                                            child: const Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(Get.key
                                                            .currentContext!)!
                                                        .txt_upload_image,
                                                    style:
                                                        loginFormHeadingStyle,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          documentUploadController
                                                                  .ManifestFrontImage =
                                                              await documentUploadController
                                                                  .cameraGallery(
                                                                      false);
                                                          if (documentUploadController
                                                                      .ManifestFrontImage ==
                                                                  null ||
                                                              documentUploadController
                                                                      .ManifestFrontImage ==
                                                                  "") {
                                                            documentUploadController
                                                                .isManifestFrontUpload
                                                                .value = false;
                                                          } else {
                                                            documentUploadController
                                                                .isManifestFrontUpload
                                                                .value = true;
                                                          }
                                                          documentUploadController.DriverDocumentUpload(
                                                              AppLocalizations
                                                                      .of(Get
                                                                          .key
                                                                          .currentContext!)!
                                                                  .txt_vehicle_mani,
                                                              "Vehicle manifest",
                                                              "",
                                                              documentUploadController
                                                                      .ManifestFrontImage
                                                                  .toString(),
                                                              "",
                                                              documentUploadController
                                                                      .ManifestFrom
                                                                  .toString(),
                                                              "");
                                                        },
                                                        child: Obx(
                                                          () => documentUploadController
                                                                      .isManifestFrontUpload ==
                                                                  true
                                                              ? Container(
                                                                  width: 50,
                                                                  height: 30,
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .center,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                    color: ConstColor
                                                                        .accentColor,
                                                                  ),
                                                                  child: Icon(
                                                                      Icons
                                                                          .check))
                                                              : Container(
                                                                  width: 50,
                                                                  height: 30,
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .center,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                    color: ConstColor
                                                                        .accentColor,
                                                                  ),
                                                                  child: Text(
                                                                    AppLocalizations.of(Get
                                                                            .key
                                                                            .currentContext!)!
                                                                        .txt_front,
                                                                  )),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ]),
                                          ]),
                                    ],
                                  ),
                                )),

                                const SizedBox(
                                  height: 10,
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                                DivTile(),
                                const SizedBox(
                                  height: 10,
                                ),
                                // DocsTile(
                                //   hintText: "Radio Tax Number",
                                //   leftText: AppConstents.vehicleRadio,
                                //   textController: documentUploadController.RadioTaxNumber,
                                // ),
                                // Container(
                                //     child: Padding(
                                //   padding:
                                //       const EdgeInsetsDirectional.symmetric(
                                //           horizontal: 12),
                                //   child: Column(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //           Text(
                                //             AppLocalizations.of(
                                //                     Get.key.currentContext!)!
                                //                 .txt_vehicle_radio_tax,
                                //             style: drawerTextStyle,
                                //           ),
                                //           const SizedBox(
                                //             height: 12,
                                //           ),
                                //           Row(
                                //             children: [
                                //               Column(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment
                                //                         .spaceBetween,
                                //                 crossAxisAlignment:
                                //                     CrossAxisAlignment.start,
                                //                 children: [
                                //                   Text(
                                //                     AppLocalizations.of(Get.key
                                //                             .currentContext!)!
                                //                         .txt_valid_from,
                                //                     style:
                                //                         loginFormHeadingStyle,
                                //                   ),
                                //                   const SizedBox(height: 12),
                                //                   Stack(
                                //                     alignment:
                                //                         AlignmentDirectional
                                //                             .bottomEnd,
                                //                     children: [
                                //                       InkWell(
                                //                         onTap: () async {
                                //                           // showMe(context);
                                //                           FocusScope.of(context)
                                //                               .unfocus();

                                //                           await documentUploadController
                                //                               .selectDate(
                                //                                   context,
                                //                                   "from",
                                //                                   "")
                                //                               .then((value) {
                                //                             print(
                                //                                 "value...  date..  " +
                                //                                     value);
                                //                             documentUploadController
                                //                                 .RadioTaxFrom
                                //                                 .value = value;

                                //                             documentUploadController.DriverDocumentUpload(
                                //                                 AppLocalizations
                                //                                         .of(Get
                                //                                             .key
                                //                                             .currentContext!)!
                                //                                     .txt_vehicle_radio,
                                //                                 "Vehicle radio tax",
                                //                                 "",
                                //                                 documentUploadController
                                //                                         .RadioTaxFrontImage
                                //                                     .toString(),
                                //                                 "",
                                //                                 documentUploadController
                                //                                         .RadioTaxFrom
                                //                                     .toString(),
                                //                                 "");
                                //                           });
                                //                         },
                                //                         child: Container(
                                //                           height: 30,
                                //                           width: 140,
                                //                           padding:
                                //                               const EdgeInsetsDirectional
                                //                                   .only(
                                //                                   top: 5,
                                //                                   bottom: 5,
                                //                                   start: 8,
                                //                                   end: 5),
                                //                           alignment:
                                //                               AlignmentDirectional
                                //                                   .centerStart,
                                //                           decoration:
                                //                               BoxDecoration(
                                //                             borderRadius:
                                //                                 BorderRadius
                                //                                     .circular(
                                //                                         6),
                                //                             color: ConstColor
                                //                                 .accentColor,
                                //                           ),
                                //                           child: Obx(
                                //                             () => Text(
                                //                               documentUploadController
                                //                                   .RadioTaxFrom
                                //                                   .value,
                                //                               style:
                                //                                   const TextStyle(
                                //                                       fontSize:
                                //                                           13),
                                //                               // controller: dateAssign("from"),
                                //                             ),
                                //                           ),
                                //                         ),
                                //                       ),
                                //                       InkWell(
                                //                           onTap: () async {
                                //                             // showMe(context);
                                //                             FocusScope.of(
                                //                                     context)
                                //                                 .unfocus();

                                //                             await documentUploadController
                                //                                 .selectDate(
                                //                                     context,
                                //                                     "from",
                                //                                     "")
                                //                                 .then((value) {
                                //                               documentUploadController
                                //                                   .RadioTaxFrom
                                //                                   .value = value;
                                //                               documentUploadController.DriverDocumentUpload(
                                //                                   AppLocalizations.of(Get
                                //                                           .key
                                //                                           .currentContext!)!
                                //                                       .txt_vehicle_radio,
                                //                                   "Vehicle radio tax",
                                //                                   "",
                                //                                   documentUploadController
                                //                                           .RadioTaxFrontImage
                                //                                       .toString(),
                                //                                   "",
                                //                                   documentUploadController
                                //                                       .RadioTaxFrom
                                //                                       .value
                                //                                       .toString(),
                                //                                   "");
                                //                             });
                                //                           },
                                //                           child: Container(
                                //                             alignment:
                                //                                 AlignmentDirectional
                                //                                     .centerEnd,
                                //                             child: const Icon(
                                //                               Icons
                                //                                   .arrow_drop_down,
                                //                             ),
                                //                           )),
                                //                     ],
                                //                   ),
                                //                 ],
                                //               ),
                                //               Spacer(),
                                //               Column(
                                //                 crossAxisAlignment:
                                //                     CrossAxisAlignment.end,
                                //                 children: [
                                //                   Text(
                                //                     AppLocalizations.of(Get.key
                                //                             .currentContext!)!
                                //                         .txt_upload_image,
                                //                     style:
                                //                         loginFormHeadingStyle,
                                //                   ),
                                //                   const SizedBox(height: 12),
                                //                   Row(
                                //                     children: [
                                //                       InkWell(
                                //                         onTap: () async {
                                //                           FocusScope.of(context)
                                //                               .unfocus();
                                //                           documentUploadController
                                //                                   .RadioTaxFrontImage =
                                //                               await documentUploadController
                                //                                   .cameraGallery(
                                //                                       false);
                                //                           if (documentUploadController
                                //                                       .RadioTaxFrontImage ==
                                //                                   null ||
                                //                               documentUploadController
                                //                                       .RadioTaxFrontImage ==
                                //                                   "") {
                                //                             documentUploadController
                                //                                 .isRadioTaxFrontUpload
                                //                                 .value = false;
                                //                           } else {
                                //                             documentUploadController
                                //                                 .isRadioTaxFrontUpload
                                //                                 .value = true;
                                //                           }
                                //                           documentUploadController.DriverDocumentUpload(
                                //                               AppLocalizations
                                //                                       .of(Get
                                //                                           .key
                                //                                           .currentContext!)!
                                //                                   .txt_vehicle_radio,
                                //                               "Vehicle radio tax",
                                //                               "",
                                //                               documentUploadController
                                //                                       .RadioTaxFrontImage
                                //                                   .toString(),
                                //                               "",
                                //                               documentUploadController
                                //                                   .RadioTaxFrom
                                //                                   .value
                                //                                   .toString(),
                                //                               "");
                                //                         },
                                //                         child: Obx(
                                //                           () => documentUploadController
                                //                                       .isRadioTaxFrontUpload ==
                                //                                   true
                                //                               ? Container(
                                //                                   width: 50,
                                //                                   height: 30,
                                //                                   alignment:
                                //                                       AlignmentDirectional
                                //                                           .center,
                                //                                   decoration:
                                //                                       BoxDecoration(
                                //                                     borderRadius:
                                //                                         BorderRadius
                                //                                             .circular(6),
                                //                                     color: ConstColor
                                //                                         .accentColor,
                                //                                   ),
                                //                                   child: Icon(
                                //                                       Icons
                                //                                           .check))
                                //                               : Container(
                                //                                   width: 50,
                                //                                   height: 30,
                                //                                   alignment:
                                //                                       AlignmentDirectional
                                //                                           .center,
                                //                                   decoration:
                                //                                       BoxDecoration(
                                //                                     borderRadius:
                                //                                         BorderRadius
                                //                                             .circular(6),
                                //                                     color: ConstColor
                                //                                         .accentColor,
                                //                                   ),
                                //                                   child: Text(AppLocalizations.of(Get
                                //                                           .key
                                //                                           .currentContext!)!
                                //                                       .txt_front)),
                                //                         ),
                                //                       ),
                                //                       const SizedBox(
                                //                         width: 5,
                                //                       ),
                                //                     ],
                                //                   )
                                //                 ],
                                //               ),
                                //             ],
                                //           )
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // )),

                                // const SizedBox(
                                //   height: 20,
                                // ),
                                // DivTile(),

                                // const SizedBox(
                                //   height: 10,
                                // ),

                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            child: Text(
                                              AppConstents()
                                                  .txtCriminalRecordCertificate,
                                              style: drawerTextStyle,
                                            )),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();

                                                (await documentUploadController
                                                    .cameraGallery(false)
                                                    .then((value) {
                                                  print("value. criminal./  " +
                                                      value.toString());
                                                  documentUploadController
                                                      .CirminalRecordImage
                                                      .value = value;
                                                }));
                                                print(
                                                    "CirminalRecordImage...${documentUploadController.CirminalRecordImage.value}");

                                                documentUploadController
                                                    .DriverDocumentUpload(
                                                        AppConstents()
                                                            .txtCriminalRecord,
                                                        "Criminal Record",
                                                        "",
                                                        documentUploadController
                                                            .CirminalRecordImage
                                                            .value
                                                            .toString(),
                                                        "",
                                                        "",
                                                        "");
                                              },
                                              child: Container(
                                                width: 70,
                                                height: 30,
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(top: 18),
                                                alignment:
                                                    AlignmentDirectional.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: ConstColor.accentColor,
                                                ),
                                                child: Text(AppLocalizations.of(
                                                        Get.key
                                                            .currentContext!)!
                                                    .txt_upload),
                                              ),
                                            ),
                                            Obx(() => Expanded(
                                                    child: Container(
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                          .only(
                                                          top: 18, start: 20),
                                                  child: Text(
                                                    documentUploadController
                                                        .CirminalRecordImage
                                                        .value,
                                                    textAlign: TextAlign.end,
                                                    // overflow: TextOverflow.fade,
                                                    style: tripDetailTextStyle,
                                                  ),
                                                )))
                                          ],
                                        )
                                      ],
                                    )),

                                const SizedBox(
                                  height: 8,
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                                DivTile(),

                                const SizedBox(
                                  height: 10,
                                ),

                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 12),
                                    child: Column(children: [
                                      Container(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: Text(
                                            AppConstents().txtSelectGender,
                                            style: drawerTextStyle,
                                          )),
                                      Obx(
                                        () => Container(
                                          height: 40, 
                                          transform: Matrix4.translationValues(
                                              -10.0, 0.0, 0.0),
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                  bottom: 10, top: 10),
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: RadioGroup<String>.builder(
                                            direction: Axis.horizontal,
                                            groupValue: documentUploadController
                                                .yourGender.value,
                                            horizontalAlignment:
                                                MainAxisAlignment.center,
                                            activeColor: ConstColor.accentColor,
                                            fillColor: ConstColor.accentColor,
                                            onChanged: (value) {
                                              if (kDebugMode) {
                                                print(
                                                    "your gender  ,,,   $value");
                                              } else {
                                                print(
                                                    "your gender  ,,,  11 $value");
                                              }
                                              documentUploadController
                                                  .yourGender
                                                  .value = value ?? '';
                                              documentUploadController
                                                  .updateGender();
                                              ////
                                            },
                                            items: documentUploadController
                                                .genderList,
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              color:
                                                  ConstColor.codeFieldTextColor,
                                            ),
                                            itemBuilder: (item) =>
                                                RadioButtonBuilder(
                                              item,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])),

                                const SizedBox(
                                  height: 5,
                                ),
                                DivTile(),
                                const SizedBox(
                                  height: 10,
                                ),

                                // Container(
                                //     child: Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //       Container(
                                //           margin:
                                //               const EdgeInsetsDirectional.only(
                                //                   bottom: 4, start: 12),
                                //           alignment:
                                //               AlignmentDirectional.centerStart,
                                //           child: Text(
                                //             AppConstents().genderPreferences,
                                //             style: drawerTextStyle,
                                //           )),
                                //       Container(
                                //           margin:
                                //               const EdgeInsetsDirectional.only(
                                //                   bottom: 8, start: 12),
                                //           alignment:
                                //               AlignmentDirectional.centerStart,
                                //           child: Text(
                                //             AppConstents()
                                //                 .genderPreferencesDetail,
                                //             style: notificationTextStyle,
                                //           )),
                                //       SingleChildScrollView(
                                //           scrollDirection: Axis.horizontal,
                                //           child: Row(
                                //             // direction: Axis.horizontal,
                                //             // crossAxisAlignment:
                                //             //     CrossAxisAlignment.start,
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.start,
                                //             children: [
                                //               Container(
                                //                 margin:
                                //                     const EdgeInsetsDirectional
                                //                         .only(start: 15),
                                //                 transform:
                                //                     Matrix4.translationValues(
                                //                         -15.0, 0.0, 0.0),
                                //                 child: Row(
                                //                   // mainAxisAlignment:
                                //                   //     MainAxisAlignment.start,
                                //                   children: [
                                //                     Obx(
                                //                       () => Container(
                                //                         transform: Matrix4
                                //                             .translationValues(
                                //                                 -0.0, 0.0, 0.0),
                                //                         child: Radio(
                                //                           value: 1,
                                //                           groupValue:
                                //                               documentUploadController
                                //                                   .genderMaleValue
                                //                                   .value,
                                //                           activeColor:
                                //                               ConstColor
                                //                                   .codeFieldColor,
                                //                           focusColor: ConstColor
                                //                               .codeFieldColor,
                                //                           hoverColor: ConstColor
                                //                               .codeFieldColor,
                                //                           fillColor:
                                //                               MaterialStateColor
                                //                                   .resolveWith(
                                //                                       (states) =>
                                //                                           ConstColor.codeFieldColor),
                                //                           onChanged: (value) {
                                //                             // print("value gen");
                                //                             documentUploadController
                                //                                     .genderTxt
                                //                                     .value =
                                //                                 AppConstents()
                                //                                     .txtMale;
                                //                             documentUploadController
                                //                                 .genderMaleValue
                                //                                 .value = 1;
                                //                             documentUploadController
                                //                                 .genderFemaleValue
                                //                                 .value = 2;
                                //                             documentUploadController
                                //                                 .genderNoValue
                                //                                 .value = 2;
                                //                             documentUploadController
                                //                                 .DriverDocumentUpload(
                                //                                     AppConstents()
                                //                                         .genderPreferences,
                                //                                     "Gender Preferences",
                                //                                     "0",
                                //                                     "",
                                //                                     "",
                                //                                     "",
                                //                                     "");
                                //                           },
                                //                         ),
                                //                       ),
                                //                     ),
                                //                     Container(
                                //                         transform: Matrix4
                                //                             .translationValues(
                                //                                 -6.0, 0.0, 0.0),
                                //                         child: Text(
                                //                           AppConstents()
                                //                               .txtMale,
                                //                           style:
                                //                               const TextStyle(
                                //                             fontSize: 14,
                                //                             color:  ConstColor.codeFieldColor,
                                //                           ),
                                //                         ))
                                //                   ],
                                //                 ),
                                //               ),
                                //               Container(
                                //                 child: Row(
                                //                   // mainAxisAlignment:
                                //                   //     MainAxisAlignment.start,
                                //                   children: [
                                //                     Obx(
                                //                       () => Container(
                                //                         transform: Matrix4
                                //                             .translationValues(
                                //                                 -8.0, 0.0, 0.0),
                                //                         child: Radio(
                                //                           value: 1,
                                //                           groupValue:
                                //                               documentUploadController
                                //                                   .genderFemaleValue
                                //                                   .value,
                                //                           activeColor:
                                //                               ConstColor
                                //                                   .codeFieldColor,
                                //                           focusColor: ConstColor
                                //                               .codeFieldColor,
                                //                           hoverColor: ConstColor
                                //                               .codeFieldColor,
                                //                           fillColor:
                                //                               MaterialStateColor
                                //                                   .resolveWith(
                                //                                       (states) =>
                                //                                           ConstColor.codeFieldColor),
                                //                           onChanged: (value) {
                                //                             // print("value gen");
                                //                             documentUploadController
                                //                                     .genderTxt
                                //                                     .value =
                                //                                 AppConstents()
                                //                                     .txtFemale;
                                //                             documentUploadController
                                //                                 .genderMaleValue
                                //                                 .value = 2;
                                //                             documentUploadController
                                //                                 .genderFemaleValue
                                //                                 .value = 1;
                                //                             documentUploadController
                                //                                 .genderNoValue
                                //                                 .value = 2;
                                //                             documentUploadController
                                //                                 .DriverDocumentUpload(
                                //                                     AppConstents()
                                //                                         .genderPreferences,
                                //                                     "Gender Preferences",
                                //                                     "1",
                                //                                     "",
                                //                                     "",
                                //                                     "",
                                //                                     "");
                                //                           },
                                //                         ),
                                //                       ),
                                //                     ),
                                //                     Container(
                                //                         transform: Matrix4
                                //                             .translationValues(
                                //                                 -12.0,
                                //                                 0.0,
                                //                                 0.0),
                                //                         child: Text(
                                //                           AppConstents()
                                //                               .txtFemale,
                                //                           style:
                                //                               const TextStyle(
                                //                             fontSize: 14,
                                //                             color:  ConstColor.codeFieldColor,
                                //                           ),
                                //                         )),
                                //                   ],
                                //                 ),
                                //               ),
                                //               Container(
                                //                 // flex: 1,
                                //                 // transform:
                                //                 //     Matrix4.translationValues(
                                //                 //        -10.0, 0.0, 0.0),
                                //                 child: Row(
                                //                   // mainAxisAlignment:
                                //                   //     MainAxisAlignment.start,
                                //                   children: [
                                //                     Obx(
                                //                       () => Container(
                                //                         transform: Matrix4
                                //                             .translationValues(
                                //                                 -10.0,
                                //                                 0.0,
                                //                                 0.0),
                                //                         child: Radio(
                                //                           value: 1,
                                //                           groupValue:
                                //                               documentUploadController
                                //                                   .genderNoValue
                                //                                   .value,
                                //                           activeColor:
                                //                               ConstColor
                                //                                   .codeFieldColor,
                                //                           focusColor: ConstColor
                                //                               .codeFieldColor,
                                //                           hoverColor: ConstColor
                                //                               .codeFieldColor,
                                //                           fillColor:
                                //                               MaterialStateColor
                                //                                   .resolveWith(
                                //                                       (states) =>
                                //                                            ConstColor.codeFieldColor),
                                //                           onChanged: (value) {
                                //                             // print("value gen");
                                //                             documentUploadController
                                //                                     .genderTxt
                                //                                     .value =
                                //                                 AppConstents()
                                //                                     .txtNoPref;
                                //                             documentUploadController
                                //                                 .genderMaleValue
                                //                                 .value = 2;
                                //                             documentUploadController
                                //                                 .genderFemaleValue
                                //                                 .value = 2;
                                //                             documentUploadController
                                //                                 .genderNoValue
                                //                                 .value = 1;
                                //                             documentUploadController
                                //                                 .DriverDocumentUpload(
                                //                                     AppConstents()
                                //                                         .genderPreferences,
                                //                                     "Gender Preferences",
                                //                                     "2",
                                //                                     "",
                                //                                     "",
                                //                                     "",
                                //                                     "");
                                //                           },
                                //                         ),
                                //                       ),
                                //                     ),
                                //                     Container(
                                //                         transform: Matrix4
                                //                             .translationValues(
                                //                                 -14.0,
                                //                                 0.0,
                                //                                 0.0),
                                //                         child: Text(
                                //                           AppConstents()
                                //                               .txtNoPref,
                                //                           softWrap: true,
                                //                           style:
                                //                               const TextStyle(
                                //                             fontSize: 14,
                                //                             color: ConstColor.codeFieldColor,
                                //                           ),
                                //                         ))
                                //                   ],
                                //                 ),
                                //               )
                                //             ],
                                //           ))
                                //     ])),

                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // DivTile(),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // Padding(
                                //     padding:
                                //         const EdgeInsetsDirectional.symmetric(
                                //             horizontal: 12),
                                //     child: Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //           Container(
                                //               alignment: AlignmentDirectional
                                //                   .centerStart,
                                //               child: Text(
                                //                 AppConstents()
                                //                     .txtRideTypeSelection,
                                //                 style: drawerTextStyle,
                                //               )),
                                //           Obx(
                                //             () => Container(
                                //               height: 40,
                                //               transform:
                                //                   Matrix4.translationValues(
                                //                       -10.0, 0.0, 0.0),
                                //               margin:
                                //                   const EdgeInsetsDirectional
                                //                       .only(
                                //                       bottom: 10, top: 10),
                                //               alignment:
                                //                   AlignmentDirectional.topStart,
                                //               child: RadioGroup<String>.builder(
                                //                 direction: Axis.horizontal,
                                //                 groupValue:
                                //                     documentUploadController
                                //                         .rideTypeTxt.value,
                                //                 horizontalAlignment:
                                //                     MainAxisAlignment.start,
                                //                 activeColor:
                                //                     ConstColor.accentColor,
                                //                 fillColor:
                                //                     ConstColor.accentColor,
                                //                 onChanged: (value) {
                                //                   documentUploadController
                                //                       .rideTypeTxt
                                //                       .value = value ?? '';
                                //                   documentUploadController
                                //                       .updateRideType();
                                //                 },
                                //                 items: documentUploadController
                                //                     .driverTypeList,
                                //                 textStyle: const TextStyle(
                                //                   fontSize: 14,
                                //                   color: ConstColor
                                //                       .codeFieldTextColor,
                                //                 ),
                                //                 itemBuilder: (item) =>
                                //                     RadioButtonBuilder(
                                //                   item,
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         ])),

                                // DivTile(),
                                const SizedBox(
                                  height: 10,
                                ),

                                Container(
                                    child: Padding(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppConstents().securityDeposit,
                                            style: drawerTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .only(
                                                              top: 8,
                                                              bottom: 8,
                                                              start: 20,
                                                              end: 20),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: ConstColor
                                                                .codeFieldColor),
                                                      ),
                                                      child: Text(
                                                        UserSession.getStringFromSession(
                                                                    UserSession
                                                                        .currencyPosition) ==
                                                                "0"
                                                            ? "${UserSession.getStringFromSession(UserSession.currencySymbol)} ${UserSession.getStringFromSession(UserSession.keySecurityAmt)}"
                                                            : "${UserSession.getStringFromSession(UserSession.keySecurityAmt)} ${UserSession.getStringFromSession(UserSession.currencySymbol)}",
                                                        style: drawerTextStyle,
                                                      ))),
                                              Spacer(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      if (documentUploadController
                                                              .depositCheck
                                                              .value ==
                                                          true) {
                                                        showFlutterToast(
                                                            message: AppConstents()
                                                                .checkedDepositOption);
                                                      } else if (documentUploadController
                                                              .onlinepaymentDone ==
                                                          true) {
                                                        showFlutterToast(
                                                            message: AppConstents()
                                                                .doneOnlinePayment);
                                                      } else {
                                                        Get.bottomSheet(
                                                            StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                          return Container(
                                                              decoration: const BoxDecoration(
                                                                  color: ConstColor
                                                                      .blackDialogColor,
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              50.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              50.0))),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const SizedBox(
                                                                      height:
                                                                          12),
                                                                  Container(
                                                                    height: 5,
                                                                    width: 100,
                                                                    color: ConstColor
                                                                        .codeFieldColor,
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          18),
                                                                  Container(
                                                                      child:
                                                                          Text(
                                                                    AppConstents()
                                                                        .choosePaymentMethod,
                                                                    style:
                                                                        appbarTextStyle,
                                                                  )),
                                                                  const SizedBox(
                                                                      height:
                                                                          18),
                                                                  DivTile(),
                                                                  Container(
                                                                    margin: const EdgeInsetsDirectional
                                                                        .only(
                                                                        start:
                                                                            20,
                                                                        end:
                                                                            20),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        // InkWell(
                                                                        //   onTap:
                                                                        //       () {
                                                                        //     Get.back();
                                                                        //     documentUploadController.checkoutApi();
                                                                        //   },
                                                                        //   child:
                                                                        //       //   Container(
                                                                        //       // //  margin:
                                                                        //       // //    EdgeInsetsDirectional.only(top: 7),
                                                                        //       // width:
                                                                        //       //     100,
                                                                        //       // height:
                                                                        //       //     100,
                                                                        //       // // decoration:
                                                                        //       // //     BoxDecoration(border: Border.all(color: ConstColor.accentColor), borderRadius: BorderRadius.circular(4)),
                                                                        //       // child:
                                                                        //       Container(
                                                                        //     //margin: EdgeInsetsDirectional.only(top: 4, bottom: 4),
                                                                        //     height:
                                                                        //         100,
                                                                        //     width:
                                                                        //         100,
                                                                        //     child:
                                                                        //         Image.asset(
                                                                        //       'assets/images/ic_paypal.png',
                                                                        //       //fit: BoxFit.contain,
                                                                        //       // height: 45,
                                                                        //       // width: 45,
                                                                        //     ),
                                                                        //     // ),
                                                                        //   ),
                                                                        // ),

                                                                        InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.back();
                                                                              Map map = {
                                                                                "security_deposit": "0",
                                                                                "payment_method": "Cash",
                                                                                "payment_mode": "Cash",
                                                                                "transection_id": "",
                                                                                "amount": "${UserSession.getStringFromSession(UserSession.keySecurityAmt)}"
                                                                              };
                                                                              documentUploadController.securityDeposit = true;

                                                                              documentUploadController.updateSecurityDeposit(map, "0");
                                                                            },
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/ic_cash.png',
                                                                              fit: BoxFit.contain,
                                                                              width: 100,
                                                                              height: 100,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          18),
                                                                ],
                                                              ));
                                                        }));
                                                      }
                                                    },
                                                    child: Container(
                                                        width: 80,
                                                        height: 30,
                                                        alignment:
                                                            AlignmentDirectional
                                                                .center,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          color: documentUploadController
                                                                      .depositCheck
                                                                      .value ==
                                                                  true
                                                              ? const Color
                                                                  .fromARGB(255,
                                                                  130, 127, 127)
                                                              : ConstColor
                                                                  .accentColor,
                                                        ),
                                                        child: Text(
                                                            AppConstents()
                                                                .payNowButton)),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Obx(
                                            () => Container(
                                              transform:
                                                  Matrix4.translationValues(
                                                      -14.0, 0.0, 0.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Checkbox(
                                                      value:
                                                          documentUploadController
                                                              .depositCheck
                                                              .value,
                                                      checkColor: ConstColor
                                                          .blackcodeTextButtonColor,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .all(ConstColor
                                                                  .codeFieldColor),
                                                      onChanged: (value) {
                                                        if (documentUploadController
                                                                .onlinepaymentDone ==
                                                            true) {
                                                          showFlutterToast(
                                                              message:
                                                                  AppConstents()
                                                                      .doneOnlinePayment);
                                                        } else {
                                                          documentUploadController
                                                              .depositCheck
                                                              .value = value!;
                                                          if (documentUploadController
                                                                  .depositCheck
                                                                  .value ==
                                                              false) {
                                                            documentUploadController
                                                                    .securityDeposit =
                                                                false;
                                                          } else {
                                                            documentUploadController
                                                                    .securityDeposit =
                                                                true;
                                                            Map map = {
                                                              "security_deposit":
                                                                  "0",
                                                              "payment_method":
                                                                  "",
                                                              "payment_mode":
                                                                  "",
                                                              "transection_id":
                                                                  "",
                                                              "amount":
                                                                  "${UserSession.getStringFromSession(UserSession.keySecurityAmt)}"
                                                            };

                                                            print("securityDeposit... " +
                                                                "${UserSession.getStringFromSession(UserSession.keySecurityAmt)}");

                                                            documentUploadController
                                                                .updateSecurityDeposit(
                                                                    map, "2");
                                                          }
                                                        }
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      AppConstents()
                                                          .doDepositeLater,
                                                      style: black14Normal500,
                                                    )),
                                                  ]),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )),

                                DivTile(),

                                Obx(
                                  () => Container(
                                      transform: Matrix4.translationValues(
                                          -3.0, 0.0, 0.0),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            checkColor: ConstColor
                                                .blackcodeTextButtonColor,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    ConstColor.codeFieldColor),
                                            value: documentUploadController
                                                .isAccept.value,
                                            onChanged: (bool? value) {
                                              documentUploadController
                                                  .isAccept.value = value!;
                                            },
                                          ),
                                          Expanded(
                                              child:
                                                  //     Text(
                                                  //   AppConstents().txtAcceptTerms,
                                                  //   style: smallNormalStyle,
                                                  //   maxLines: 2,
                                                  // )
                                                  RichText(
                                                      text: TextSpan(children: [
                                            TextSpan(
                                              text:
                                                  "${AppConstents().txtBySigning} ",
                                              style: formhintStyle,
                                            ),
                                            TextSpan(
                                              text: AppConstents()
                                                  .txtTermsOfService,
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  launchUrl(
                                                      Uri.parse(
                                                          documentUploadController
                                                              .termsUrl.value),
                                                      mode: LaunchMode
                                                          .externalApplication);
                                                },
                                            ),
                                            TextSpan(
                                              text:
                                                  " ${AppConstents().txtAnd} ",
                                              style: formhintStyle,
                                            ),
                                            TextSpan(
                                              text: AppConstents()
                                                  .txtPrivacyPolicy,
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  launchUrl(
                                                      Uri.parse(
                                                          documentUploadController
                                                              .privacyUrl
                                                              .value),
                                                      mode: LaunchMode
                                                          .externalApplication);
                                                },
                                            ),
                                          ])))
                                        ],
                                      )),
                                ),

                                const SizedBox(
                                  height: 40,
                                ),

                                Obx(
                                  () => documentUploadController
                                              .isLoading.value ==
                                          false
                                      ? CommonButton(
                                          width: 240,
                                          color: ConstColor.accentColor,
                                          // txtStyle: buttonBlackTitleStyle,
                                          onPressed: () {
                                            //FocusScope.of(context).unfocus();
                                            documentUploadController
                                                .updateRideType();
                                            documentUploadController
                                                .save(documentUploadController);
                                          },
                                          title: AppLocalizations.of(
                                                  Get.key.currentContext!)!
                                              .txt_done,
                                        )
                                      : CircularProgressIndicator(),
                                ),
                                const SizedBox(height: 25),
                              ]),
                            )
                          ],
                        ),
                      )))),
        ));
  }
}

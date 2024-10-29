import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:madr_driver/utils/user_session.dart';

import '../../../utils/app_constents.dart';
import '../../../utils/const_color.dart';
import '../../../utils/docs_tile.dart';
import '../../../utils/email_rule.dart';
import '../../../utils/style.dart';
import '../../controller/document_upload_controller.dart';
import '../custom_widget/commonbutton.dart';

class DocmentUploadScreen extends StatefulWidget {
  static String routeName = "DocmentUploadScreen";

  const DocmentUploadScreen({Key? key}) : super(key: key);

  @override
  State<DocmentUploadScreen> createState() => _DocmentUploadScreenState();
}

class _DocmentUploadScreenState extends State<DocmentUploadScreen> {
  bool obsecureTextShow = true;
  DocumentUploadController documentUploadController =
      Get.put(DocumentUploadController());
  List<String> PassengerList = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15"
  ];

  @override
  void initState() {
    super.initState();
    documentUploadController.paymentEmailController.value.text = "";
    documentUploadController.updateDocument();
    // documentUploadController.city();
    UserSession.isCurrentLoading = documentUploadController.isLoading;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    log("dec  upload dispose......  ");
    documentUploadController.disposeData();
    // documentUploadController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Obx(() {
      print("rebuild..... ");
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: authBgDecoration,
        child: Scaffold(
            backgroundColor: ConstColor.codeBackgroundColor,
            // resizeToAvoidBottomInset: false,
            body: ProgressHUD(
              inAsyncCall: documentUploadController.isDocumentLoading.value,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    // const BlueCurveLogoWidget(),
                    // const SizedBox(
                    //   height: 25,
                    // ),
                    Container(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.center,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          AppLocalizations.of(Get.key.currentContext!)!
                              .txt_upload_details,
                          style: loginHeadingStyle,
                        ),
                      ),
                    ),

                    //  DivTile(),
                    const SizedBox(
                      height: 50,
                    ),

                    //   Container(
                    //   margin:
                    //       const EdgeInsetsDirectional.symmetric(horizontal: 22),
                    //   padding:
                    //       const EdgeInsetsDirectional.symmetric(horizontal: 12),
                    //   child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           AppConstents().txtCity,
                    //           style: drawerTextStyle,
                    //         ),
                    //        Expanded(
                    //         child:
                    //         Container(
                    //           alignment: AlignmentDirectional.centerEnd,
                    //           child: DropdownButton2(
                    //             isExpanded: true,
                    //             hint: Row(
                    //               children: [
                    //                 Expanded(
                    //                   child: Container(
                    //                     alignment: Alignment.center,
                    //                     child: Text(
                    //                       documentUploadController
                    //                           .selectedCity.value,
                    //                       textAlign: TextAlign.center,
                    //                       style: const TextStyle(
                    //                         fontSize: 14,
                    //                         fontWeight: FontWeight.w400,
                    //                         color: Colors.black,
                    //                       ),
                    //                       overflow: TextOverflow.ellipsis,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             items: (documentUploadController.cityList).map(
                    //                 (item) => DropdownMenuItem<String>(
                    //                       value: item['name'],
                    //                       child: Text(
                    //                         item['name'],
                    //                         style: const TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.w400,
                    //                           color: Colors.black,
                    //                         ),
                    //                         overflow: TextOverflow.ellipsis,
                    //                       ),
                    //                     )).toList(),
                    //             // value: documentUploadController.PassengerNo.value,
                    //             onChanged: (value) {
                    //               //setState(() {
                    //               documentUploadController.selectedCity.value =
                    //                   value as String;

                    //             },
                    //             icon: const Icon(
                    //               Icons.arrow_drop_down,
                    //             ),
                    //             iconSize: 24,
                    //             iconEnabledColor: Colors.black,
                    //             iconDisabledColor: Colors.black,
                    //             buttonHeight: 30,
                    //             buttonWidth: 200,
                    //             buttonPadding: const EdgeInsetsDirectional.only(
                    //                 start: 14, end: 14),
                    //             buttonDecoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(14),
                    //               border: Border.all(
                    //                 color: ConstColor.hintgreyaccentColor,
                    //               ),
                    //               color: ConstColor.hintgreyaccentColor,
                    //             ),
                    //             buttonElevation: 2,
                    //             itemHeight: 40,
                    //             itemPadding:
                    //                 const EdgeInsetsDirectional.only(start: 44),
                    //             dropdownMaxHeight: 170,
                    //             dropdownWidth: 200,
                    //             dropdownPadding: null,
                    //             dropdownDecoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(14),
                    //               color: ConstColor.hintgreyaccentColor,
                    //             ),
                    //             dropdownElevation: 8,
                    //             scrollbarRadius: const Radius.circular(12),
                    //             scrollbarThickness: 6,
                    //             scrollbarAlwaysShow: true,
                    //             offset: const Offset(0, 0),
                    //           ),
                    //         )),
                    //       ]),
                    // ),

                    // const SizedBox(
                    //   height: 10,
                    // ),

                    //  Container(
                    //   margin:
                    //       const EdgeInsetsDirectional.symmetric(horizontal: 20),
                    //   child: DivTile(),
                    // ),

                    // const SizedBox(height: 10),

                    Container(
                        margin: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20),
                        child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 12),
                            child: Row(children: [
                              Expanded(
                                  child: Container(
                                margin:
                                    const EdgeInsetsDirectional.only(start: 5),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        AppLocalizations.of(
                                                Get.key.currentContext!)!
                                            .txt_maker,
                                        style: drawerTextStyle,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      style: drawerTextStyle,
                                      autofocus: false,
                                      controller: documentUploadController
                                          .CarMaker.value,
                                      maxLength: 32,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        fillColor: ConstColor.accentColor,
                                        filled: true,
                                        counterText: "",
                                        // border: InputBorder.none,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: ConstColor
                                                  .accentColor), //<-- SEE HERE
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: ConstColor
                                                  .codeFieldTextColor),
                                          //<-- SEE HERE
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsetsDirectional.only(
                                                top: 10,
                                                bottom: 10,
                                                start: 5,
                                                end: 5),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        floatingLabelAlignment:
                                            FloatingLabelAlignment.start,
                                        labelText: AppLocalizations.of(
                                                Get.key.currentContext!)!
                                            .txt_name,
                                        labelStyle: hintTextStyle,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  ConstColor.codeFieldTextColor,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (val) {
                                        print(
                                            "text on submit   ${documentUploadController.CarMaker.value.text}");
                                        var valid = AppValidation()
                                            .AlphaNumericName(
                                                documentUploadController
                                                    .CarMaker.value.text
                                                    .toString());
                                        if (documentUploadController
                                            .CarMaker.value.text
                                            .trim()
                                            .isEmpty) {
                                          showFlutterToast(
                                              message: AppLocalizations.of(
                                                      Get.key.currentContext!)!
                                                  .txt_maker_name);
                                        } else if (valid.isNotEmpty) {
                                          showFlutterToast(
                                              message: AppConstents()
                                                  .ValidMakerName);
                                        } else {
                                          Fluttertoast.cancel();
                                          documentUploadController.maker.value =
                                              documentUploadController
                                                  .CarMaker.value.text;
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      start: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                                Get.key.currentContext!)!
                                            .txt_model,
                                        style: drawerTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        style: drawerTextStyle,
                                        textAlign: TextAlign.start,
                                        autofocus: false,
                                        controller: documentUploadController
                                            .CarModel.value,
                                        maxLength: 32,
                                        decoration: InputDecoration(
                                          // border: InputBorder.none,
                                          fillColor: ConstColor.accentColor,
                                          filled: true,
                                          counterText: "",
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color: ConstColor
                                                    .accentColor), //<-- SEE HERE
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color: ConstColor
                                                    .codeFieldTextColor),
                                            //<-- SEE HERE
                                          ),
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsetsDirectional.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  start: 5,
                                                  end: 5),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          floatingLabelAlignment:
                                              FloatingLabelAlignment.start,
                                          labelText: AppLocalizations.of(
                                                  Get.key.currentContext!)!
                                              .txt_model,
                                          labelStyle: hintTextStyle,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ConstColor
                                                    .codeFieldTextColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          print(
                                              "text on submit   ${documentUploadController.CarModel.value.text}");
                                          documentUploadController.model.value =
                                              documentUploadController
                                                  .CarModel.value.text;
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsetsDirectional.only(
                                      start: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                                Get.key.currentContext!)!
                                            .txt_color,
                                        style: drawerTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        style: drawerTextStyle,
                                        textAlign: TextAlign.start,
                                        controller: documentUploadController
                                            .CarColor.value,
                                        maxLength: 32,

                                        // enableInteractiveSelection: false,
                                        decoration: InputDecoration(
                                          fillColor: ConstColor.accentColor,
                                          filled: true,
                                          // border: InputBorder.none,
                                          counterText: "",
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color: ConstColor
                                                    .accentColor), //<-- SEE HERE
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color: ConstColor
                                                    .codeFieldTextColor),
                                            //<-- SEE HERE
                                          ),
                                          isDense: true,

                                          contentPadding:
                                              const EdgeInsetsDirectional.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  start: 5,
                                                  end: 5),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          floatingLabelAlignment:
                                              FloatingLabelAlignment.start,
                                          labelText: AppLocalizations.of(
                                                  Get.key.currentContext!)!
                                              .txt_color,
                                          labelStyle: hintTextStyle,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color:
                                                    ConstColor.codeFieldColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          print(
                                              "text on submit   ${documentUploadController.CarColor.value.text}");
                                          // documentUploadController.color.value =
                                          //     documentUploadController
                                          //         .CarColor.value.text;

                                          var valid = AppValidation()
                                              .AlphaNumericName(
                                                  documentUploadController
                                                      .CarColor.value.text
                                                      .toString());
                                          if (documentUploadController
                                              .CarColor.value.text
                                              .trim()
                                              .isEmpty) {
                                            showFlutterToast(
                                                message: AppConstents()
                                                    .EnterColorName);
                                          } else if (valid.isNotEmpty) {
                                            showFlutterToast(
                                                message: AppConstents()
                                                    .ValidColorName);
                                          } else {
                                            Fluttertoast.cancel();
                                            documentUploadController
                                                    .color.value =
                                                documentUploadController
                                                    .CarColor.value.text;
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]))),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin:
                          const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      child: DivTile(),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin:
                          const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(Get.key.currentContext!)!
                                  .txt_passenger,
                              style: drawerTextStyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        documentUploadController
                                            .PassengerNo.value,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              items: PassengerList.map(
                                  (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )).toList(),
                              // value: documentUploadController.PassengerNo.value,
                              onChanged: (value) {
                                //setState(() {
                                documentUploadController.PassengerNo.value =
                                    value as String;
                                print(
                                    "text on submit   ${documentUploadController.CarMaker.value.text}");

                                documentUploadController.DriverDocumentUpload(
                                    AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_no_pass,
                                    "No. Of Passenger",
                                    documentUploadController.PassengerNo.value
                                        .toString()
                                        .toString(),
                                    "",
                                    "",
                                    "",
                                    "");
                                // });
                              },
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.black,
                              ),
                              buttonStyleData: ButtonStyleData(
                                height: 30,
                                width: 110,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: ConstColor.accentColor,
                                  ),
                                  color: ConstColor.accentColor,
                                ),
                                elevation: 2,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 170,
                                width: 110,
                                elevation: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: ConstColor.accentColor,
                                ),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all<double>(6),
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsetsDirectional.only(start: 40),
                              ),
                            ),
                          ]),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin:
                          const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      child: DivTile(),
                    ),

                    const SizedBox(height: 10),
                    Container(
                      margin:
                          const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      child: Column(children: [
                        Container(
                            child: Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                                Get.key.currentContext!)!
                                            .txt_vehicle_picture,
                                        style: drawerTextStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        child: Text(
                                          AppLocalizations.of(
                                                  Get.key.currentContext!)!
                                              .txt_max_10,
                                          style: formhintStyle,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await documentUploadController
                                              .cameraGallery(true)
                                              .then((value) {
                                            documentUploadController
                                                .VehicleFrontImage.clear();
                                            var returnVal = jsonDecode(value);
                                            print(
                                                " multiple .. upload.. $returnVal");
                                            if (returnVal != null) {
                                              for (int i = 0;
                                                  i < returnVal.length;
                                                  i++) {
                                                print(
                                                    "value.  path..  ${returnVal[i]['path']}");
                                                documentUploadController
                                                        .VehicleFrontImage
                                                    .add(
                                                        (returnVal[i]['path']));
                                                print(
                                                    "multi image picker..   ${documentUploadController.VehicleFrontImage}");
                                              }
                                              //

                                              print(
                                                  "text on submit   ${documentUploadController.CarMaker.value.text}");
                                              documentUploadController
                                                  .DriverDocumentUpload(
                                                      AppLocalizations.of(Get
                                                              .key
                                                              .currentContext!)!
                                                          .txt_vehicle_pic,
                                                      "Vehicle Picture",
                                                      "",
                                                      documentUploadController
                                                              .VehicleFrontImage
                                                          .toString(),
                                                      "",
                                                      "",
                                                      "");
                                            }
                                          });
                                        },
                                        child: Obx(() =>
                                            documentUploadController
                                                    .isVehicleFrontUpload.isTrue
                                                ? Container(
                                                    width: 100,
                                                    height: 30,
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: const Color(
                                                          0xFFC4C1C1),
                                                    ),
                                                    child: Icon(Icons.check))
                                                : Column(
                                                    children: [
                                                      Container(
                                                          width: 100,
                                                          height: 30,
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: ConstColor
                                                                .accentColor,
                                                          ),
                                                          child: Text(
                                                              AppLocalizations
                                                                      .of(Get
                                                                          .key
                                                                          .currentContext!)!
                                                                  .txt_upload)),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  )),
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
                        )),
                        const SizedBox(
                          height: 5,
                        ),
                        DivTile(),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                            child: Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                              Get.key.currentContext!)!
                                          .txt_driver_id_card,
                                      style: drawerTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      style: drawerTextStyle,
                                      textAlign: TextAlign.start,
                                      controller: documentUploadController
                                          .IdNumber.value,
                                      maxLength: 32,
                                      enableInteractiveSelection: false,
                                      decoration: InputDecoration(
                                        // border: InputBorder.none,
                                        fillColor: ConstColor.accentColor,
                                        filled: true,
                                        counterText: "",
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: ConstColor
                                                  .accentColor), //<-- SEE HERE
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: ConstColor.codeFieldColor),
                                          //<-- SEE HERE
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsetsDirectional.only(
                                                top: 10,
                                                bottom: 10,
                                                start: 5,
                                                end: 5),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        floatingLabelAlignment:
                                            FloatingLabelAlignment.start,
                                        labelText: AppLocalizations.of(
                                                Get.key.currentContext!)!
                                            .txt_id_number,
                                        labelStyle: hintTextStyle,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: ConstColor.codeFieldColor,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (val) {
                                        print(
                                            "text on submit   ${documentUploadController.IdNumber.value.text}");

                                        documentUploadController
                                                .idnumber.value =
                                            documentUploadController
                                                .IdNumber.value.text;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_upload_image,
                                    style: drawerTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();

                                          await documentUploadController
                                              .cameraGallery(false)
                                              .then((value) {
                                            print("return val ..  $value");
                                            if (value != null) {
                                              documentUploadController
                                                  .IdFrontImage = value;
                                              print(
                                                  "documentUploadController.IdFrontImage.. $value");
                                              if (value == "") {
                                                documentUploadController
                                                    .isIdFrontUpload
                                                    .value = false;
                                              } else {
                                                documentUploadController
                                                    .isIdFrontUpload
                                                    .value = true;
                                              }

                                              print(
                                                  "text on submit   ${documentUploadController.IdNumber.value.text}");
                                              documentUploadController
                                                  .DriverDocumentUpload(
                                                      AppLocalizations.of(Get
                                                              .key
                                                              .currentContext!)!
                                                          .txt_driver_id,
                                                      "Driver Identification card",
                                                      documentUploadController
                                                          .IdNumber.value.text
                                                          .toString(),
                                                      documentUploadController
                                                              .IdFrontImage
                                                          .toString(),
                                                      documentUploadController
                                                              .IdBackImage
                                                          .toString(),
                                                      "",
                                                      "");
                                            }
                                          });
                                        },
                                        child: Obx(
                                          () => documentUploadController
                                                  .isIdFrontUpload.isTrue
                                              ? Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color:
                                                        ConstColor.accentColor,
                                                  ),
                                                  child: Icon(Icons.check))
                                              : Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color:
                                                        ConstColor.accentColor,
                                                  ),
                                                  child: Text(
                                                      AppLocalizations.of(Get
                                                              .key
                                                              .currentContext!)!
                                                          .txt_front)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();

                                          await documentUploadController
                                              .cameraGallery(false)
                                              .then((value) {
                                            documentUploadController
                                                .IdBackImage = value;

                                            if (documentUploadController
                                                        .IdBackImage ==
                                                    null ||
                                                documentUploadController
                                                        .IdBackImage ==
                                                    "") {
                                              documentUploadController
                                                  .isIdBackUpload.value = false;
                                            } else {
                                              documentUploadController
                                                  .isIdBackUpload.value = true;
                                            }

                                            print(
                                                "text on submit   ${documentUploadController.isIdBackUpload.value}");
                                            documentUploadController
                                                .DriverDocumentUpload(
                                                    AppLocalizations.of(Get.key
                                                            .currentContext!)!
                                                        .txt_driver_id,
                                                    "Driver Identification card",
                                                    documentUploadController
                                                        .IdNumber.value.text
                                                        .toString(),
                                                    documentUploadController
                                                            .IdFrontImage
                                                        .toString(),
                                                    documentUploadController
                                                        .IdBackImage.toString(),
                                                    "",
                                                    "");
                                          });
                                        },
                                        child: Obx(
                                          () => documentUploadController
                                                  .isIdBackUpload.value
                                              ? Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color:
                                                        ConstColor.accentColor,
                                                  ),
                                                  child: Icon(Icons.check))
                                              : Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color:
                                                        ConstColor.accentColor,
                                                  ),
                                                  child: Text(
                                                      AppLocalizations.of(Get
                                                              .key
                                                              .currentContext!)!
                                                          .txt_back)),
                                        ),
                                      )
                                    ],
                                  )
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
                          height: 12,
                        ),
                        Container(
                            child: Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                              Get.key.currentContext!)!
                                          .txt_driver_driving_license,
                                      style: drawerTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      style: drawerTextStyle,
                                      textAlign: TextAlign.start,
                                      enableInteractiveSelection: false,
                                      controller: documentUploadController
                                          .LicenseNumber.value,
                                      maxLength: 32,
                                      decoration: InputDecoration(
                                        // border: InputBorder.none,
                                        fillColor: ConstColor.accentColor,
                                        counterText: "", filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: ConstColor
                                                  .accentColor), //<-- SEE HERE
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: ConstColor.codeFieldColor),
                                          //<-- SEE HERE
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsetsDirectional.only(
                                                top: 10,
                                                bottom: 10,
                                                start: 5,
                                                end: 5),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        floatingLabelAlignment:
                                            FloatingLabelAlignment.start,
                                        labelText: AppLocalizations.of(
                                                Get.key.currentContext!)!
                                            .txt_license_number,
                                        labelStyle: hintTextStyle,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: ConstColor.codeFieldColor,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (val) {
                                        print(
                                            "text on submit   ${documentUploadController.CarMaker.value.text}");

                                        documentUploadController
                                                .licensenumber.value =
                                            documentUploadController
                                                .LicenseNumber.value.text;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_upload_image,
                                    style: drawerTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                          documentUploadController
                                                  .LicenseFrontImage =
                                              await documentUploadController
                                                  .cameraGallery(false)
                                                  .then((value) {
                                            documentUploadController
                                                .LicenseFrontImage = value;

                                            if (documentUploadController
                                                        .LicenseFrontImage ==
                                                    null ||
                                                documentUploadController
                                                        .LicenseFrontImage ==
                                                    "") {
                                              documentUploadController
                                                  .isLicenseFrontUpload
                                                  .value = false;
                                            } else {
                                              documentUploadController
                                                  .isLicenseFrontUpload
                                                  .value = true;
                                            }

                                            //
                                            print(
                                                "text on submit   ${documentUploadController.CarMaker.value.text}");
                                            documentUploadController
                                                .DriverDocumentUpload(
                                                    AppLocalizations
                                                            .of(Get.key
                                                                .currentContext!)!
                                                        .txt_driver_driving,
                                                    "Driver driving license",
                                                    documentUploadController
                                                        .LicenseNumber
                                                        .value
                                                        .text
                                                        .toString(),
                                                    documentUploadController
                                                            .LicenseFrontImage
                                                        .toString(),
                                                    documentUploadController
                                                            .LicenseBackImage
                                                        .toString(),
                                                    "",
                                                    "");
                                          });
                                        },
                                        child: Obx(
                                          () => documentUploadController
                                                      .isLicenseFrontUpload ==
                                                  true
                                              ? Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: ConstColor
                                                        .hintgreyaccentColor,
                                                  ),
                                                  child: Icon(Icons.check))
                                              : Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color:
                                                        ConstColor.accentColor,
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(Get.key
                                                            .currentContext!)!
                                                        .txt_front,
                                                  )),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();

                                          await documentUploadController
                                              .cameraGallery(false)
                                              .then((value) {
                                            documentUploadController
                                                .LicenseBackImage = value;

                                            if (documentUploadController
                                                        .LicenseBackImage ==
                                                    null ||
                                                documentUploadController
                                                        .LicenseBackImage ==
                                                    "") {
                                              documentUploadController
                                                  .isLicenseBackUpload
                                                  .value = false;
                                            } else {
                                              documentUploadController
                                                  .isLicenseBackUpload
                                                  .value = true;
                                            }
                                            //
                                            print(
                                                "text on submit   ${documentUploadController.CarMaker.value.text}");
                                            documentUploadController
                                                .DriverDocumentUpload(
                                                    AppLocalizations
                                                            .of(Get.key
                                                                .currentContext!)!
                                                        .txt_driver_driving,
                                                    "Driver driving license",
                                                    documentUploadController
                                                        .LicenseNumber
                                                        .value
                                                        .text
                                                        .toString(),
                                                    documentUploadController
                                                            .LicenseFrontImage
                                                        .toString(),
                                                    documentUploadController
                                                            .LicenseBackImage
                                                        .toString(),
                                                    "",
                                                    "");
                                          });
                                        },
                                        child: Obx(
                                          () => documentUploadController
                                                      .isLicenseBackUpload ==
                                                  true
                                              ? Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: ConstColor
                                                        .hintgreyaccentColor,
                                                  ),
                                                  child: Icon(Icons.check))
                                              : Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color:
                                                        ConstColor.accentColor,
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(Get.key
                                                            .currentContext!)!
                                                        .txt_back,
                                                  )),
                                        ),
                                      )
                                    ],
                                  )
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
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                              Get.key.currentContext!)!
                                          .txt_vehicle_registration,
                                      style: drawerTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      style: drawerTextStyle,
                                      textAlign: TextAlign.start,
                                      enableInteractiveSelection: false,
                                      controller: documentUploadController
                                          .RegistrationNumber.value,
                                      maxLength: 32,
                                      decoration: InputDecoration(
                                        // border: InputBorder.none,
                                        fillColor: ConstColor.accentColor,
                                        counterText: "",
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: ConstColor
                                                  .accentColor), //<-- SEE HERE
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: ConstColor.codeFieldColor),
                                          //<-- SEE HERE
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsetsDirectional.only(
                                                top: 10,
                                                bottom: 10,
                                                start: 5,
                                                end: 5),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        floatingLabelAlignment:
                                            FloatingLabelAlignment.start,
                                        labelText: AppLocalizations.of(
                                                Get.key.currentContext!)!
                                            .txt_registration_number,
                                        labelStyle: hintTextStyle,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: ConstColor.codeFieldColor,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (val) {
                                        print(
                                            "text on submit   ${documentUploadController.CarMaker.value.text}");

                                        documentUploadController
                                                .regnumber.value =
                                            documentUploadController
                                                .RegistrationNumber.value.text;
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_upload_image,
                                    style: drawerTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();

                                          await documentUploadController
                                              .cameraGallery(false)
                                              .then((value) {
                                            documentUploadController
                                                .RegistrationFrontImage = value;
                                            print(
                                                "documentUploadController.RegistrationFrontImage..   ${documentUploadController.RegistrationFrontImage}");

                                            if (documentUploadController
                                                        .RegistrationFrontImage ==
                                                    null ||
                                                documentUploadController
                                                        .RegistrationFrontImage ==
                                                    "") {
                                              documentUploadController
                                                  .isRegistrationFrontUpload
                                                  .value = false;
                                            } else {
                                              documentUploadController
                                                  .isRegistrationFrontUpload
                                                  .value = true;
                                            }

                                            //

                                            print(
                                                "text on submit   ${documentUploadController.CarMaker.value.text}");
                                            documentUploadController
                                                .DriverDocumentUpload(
                                                    AppLocalizations.of(
                                                            Get.key
                                                                .currentContext!)!
                                                        .txt_vehicle_reg,
                                                    "Vehicle registration",
                                                    documentUploadController
                                                        .RegistrationNumber
                                                        .value
                                                        .text
                                                        .toString(),
                                                    documentUploadController
                                                            .RegistrationFrontImage
                                                        .toString(),
                                                    documentUploadController
                                                            .RegistrationBackImage
                                                        .toString(),
                                                    "",
                                                    "");
                                          });
                                        },
                                        child: Obx(
                                          () => documentUploadController
                                                      .isRegistrationFrontUpload ==
                                                  true
                                              ? Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: ConstColor
                                                        .hintgreyaccentColor,
                                                  ),
                                                  child: Icon(Icons.check))
                                              : Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color:
                                                        ConstColor.accentColor,
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(Get.key
                                                            .currentContext!)!
                                                        .txt_front,
                                                  )),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();

                                          await documentUploadController
                                              .cameraGallery(false)
                                              .then((value) {
                                            documentUploadController
                                                .RegistrationBackImage = value;

                                            if (documentUploadController
                                                        .RegistrationBackImage ==
                                                    null ||
                                                documentUploadController
                                                        .RegistrationBackImage ==
                                                    "") {
                                              documentUploadController
                                                  .isRegistrationBackUpload
                                                  .value = false;
                                            } else {
                                              documentUploadController
                                                  .isRegistrationBackUpload
                                                  .value = true;
                                            }

                                            //
                                            print(
                                                "text on submit   ${documentUploadController.CarMaker.value.text}");
                                            documentUploadController
                                                .DriverDocumentUpload(
                                                    AppLocalizations.of(
                                                            Get.key
                                                                .currentContext!)!
                                                        .txt_vehicle_reg,
                                                    "Vehicle registration",
                                                    documentUploadController
                                                        .RegistrationNumber
                                                        .value
                                                        .text
                                                        .toString(),
                                                    documentUploadController
                                                            .RegistrationFrontImage
                                                        .toString(),
                                                    documentUploadController
                                                            .RegistrationBackImage
                                                        .toString(),
                                                    "",
                                                    "");
                                          });
                                        },
                                        child: Obx(
                                          () => documentUploadController
                                                      .isRegistrationBackUpload ==
                                                  true
                                              ? Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: ConstColor
                                                        .hintgreyaccentColor,
                                                  ),
                                                  child: Icon(Icons.check))
                                              : Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color:
                                                        ConstColor.accentColor,
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(Get.key
                                                            .currentContext!)!
                                                        .txt_back,
                                                  )),
                                        ),
                                      )
                                    ],
                                  )
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
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                              Get.key.currentContext!)!
                                          .txt_vehicle_ownership,
                                      style: drawerTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                        style: drawerTextStyle,
                                        textAlign: TextAlign.start,
                                        enableInteractiveSelection: false,
                                        controller: documentUploadController
                                            .OwnershipNumber.value,
                                        maxLength: 32,
                                        decoration: InputDecoration(
                                          // border: InputBorder.none,
                                          fillColor: ConstColor.accentColor,
                                          filled: true,
                                          counterText: "",
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color: ConstColor
                                                    .accentColor), //<-- SEE HERE
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color: ConstColor.accentColor),
                                            //<-- SEE HERE
                                          ),
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsetsDirectional.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  start: 5,
                                                  end: 5),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          floatingLabelAlignment:
                                              FloatingLabelAlignment.start,
                                          labelText: AppConstents().OwnerName,
                                          labelStyle: hintTextStyle,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color:
                                                    ConstColor.codeFieldColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          print(
                                              "text on submit   ${documentUploadController.OwnershipNumber.value.text}");

                                          var valid = AppValidation()
                                              .AlphaNumericName(
                                                  documentUploadController
                                                      .OwnershipNumber
                                                      .value
                                                      .text
                                                      .toString());
                                          if (documentUploadController
                                              .OwnershipNumber.value.text
                                              .trim()
                                              .isEmpty) {
                                            showFlutterToast(
                                                message: AppConstents()
                                                    .EnterOwnerName);
                                          } else if (valid.isNotEmpty) {
                                            showFlutterToast(
                                                message: AppConstents()
                                                    .ValidOwnerName);
                                          } else {
                                            Fluttertoast.cancel();
                                            documentUploadController
                                                    .ownernumber.value =
                                                documentUploadController
                                                    .OwnershipNumber.value.text;
                                          }
                                        }),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_upload_image,
                                    style: drawerTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();

                                          await documentUploadController
                                              .cameraGallery(false)
                                              .then((value) {
                                            documentUploadController
                                                .OwnershipFrontImage = value;

                                            if (documentUploadController
                                                        .OwnershipFrontImage ==
                                                    null ||
                                                documentUploadController
                                                        .OwnershipFrontImage ==
                                                    "") {
                                              documentUploadController
                                                  .isOwnershipFrontUpload
                                                  .value = false;
                                            } else {
                                              documentUploadController
                                                  .isOwnershipFrontUpload
                                                  .value = true;
                                            }

                                            documentUploadController
                                                .DriverDocumentUpload(
                                                    AppLocalizations.of(
                                                            Get.key
                                                                .currentContext!)!
                                                        .txt_vehicle_owner,
                                                    "Vehicle ownership",
                                                    documentUploadController
                                                        .OwnershipNumber
                                                        .value
                                                        .text
                                                        .toString(),
                                                    documentUploadController
                                                            .OwnershipFrontImage
                                                        .toString(),
                                                    documentUploadController
                                                            .OwnershipBackImage
                                                        .toString(),
                                                    "",
                                                    "");
                                          });
                                        },
                                        child: Obx(
                                          () => documentUploadController
                                                      .isOwnershipFrontUpload ==
                                                  true
                                              ? Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: ConstColor
                                                        .hintgreyaccentColor,
                                                  ),
                                                  child: Icon(Icons.check))
                                              : Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color:
                                                        ConstColor.accentColor,
                                                  ),
                                                  child: Text(
                                                      AppLocalizations.of(Get
                                                              .key
                                                              .currentContext!)!
                                                          .txt_front)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await documentUploadController
                                              .cameraGallery(false)
                                              .then((value) {
                                            print("insurance..  ${value}");
                                            documentUploadController
                                                .OwnershipBackImage = value;
                                            print(
                                                "insurance..  ${documentUploadController.InsuranceFrontImage}");
                                            if (documentUploadController
                                                        .OwnershipBackImage ==
                                                    null ||
                                                documentUploadController
                                                        .OwnershipBackImage ==
                                                    "") {
                                              documentUploadController
                                                  .isOwnershipBackUpload
                                                  .value = false;
                                            } else {
                                              documentUploadController
                                                  .isOwnershipBackUpload
                                                  .value = true;
                                            }

                                            documentUploadController
                                                .DriverDocumentUpload(
                                                    AppLocalizations.of(
                                                            Get.key
                                                                .currentContext!)!
                                                        .txt_vehicle_owner,
                                                    "Vehicle ownership",
                                                    documentUploadController
                                                        .OwnershipNumber
                                                        .value
                                                        .text
                                                        .toString(),
                                                    documentUploadController
                                                            .OwnershipFrontImage
                                                        .toString(),
                                                    documentUploadController
                                                            .OwnershipBackImage
                                                        .toString(),
                                                    "",
                                                    "");
                                          });
                                        },
                                        child: Obx(
                                          () => documentUploadController
                                                      .isOwnershipBackUpload ==
                                                  true
                                              ? Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: ConstColor
                                                        .hintgreyaccentColor,
                                                  ),
                                                  child: Icon(Icons.check))
                                              : Container(
                                                  width: 50,
                                                  height: 30,
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color:
                                                        ConstColor.accentColor,
                                                  ),
                                                  child: Text(
                                                      AppLocalizations.of(Get
                                                              .key
                                                              .currentContext!)!
                                                          .txt_back)),
                                        ),
                                      )
                                    ],
                                  )
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
                          height: 12,
                        ),
                        Container(
                            child: Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(
                                                  Get.key.currentContext!)!
                                              .txt_vehicle_insurance,
                                          style: drawerTextStyle,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                            style: drawerTextStyle,
                                            textAlign: TextAlign.start,
                                            enableInteractiveSelection: false,
                                            controller: documentUploadController
                                                .InsuranceNumber.value,
                                            maxLength: 32,
                                            decoration: InputDecoration(
                                              // border: InputBorder.none,
                                              fillColor: ConstColor.accentColor,
                                              filled: true,
                                              counterText: "",
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                    width: 1,
                                                    color: ConstColor
                                                        .accentColor), //<-- SEE HERE
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                    width: 1,
                                                    color: ConstColor
                                                        .codeFieldColor),
                                                //<-- SEE HERE
                                              ),
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsetsDirectional
                                                      .only(
                                                      top: 10,
                                                      bottom: 10,
                                                      start: 5,
                                                      end: 5),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              floatingLabelAlignment:
                                                  FloatingLabelAlignment.start,
                                              labelText: AppLocalizations.of(
                                                      Get.key.currentContext!)!
                                                  .txt_insurance_number,
                                              labelStyle: hintTextStyle,
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: ConstColor
                                                        .codeFieldColor,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onChanged: (val) {
                                              print("text on submit   " +
                                                  documentUploadController
                                                      .InsuranceNumber
                                                      .value
                                                      .text
                                                      .toString());

                                              documentUploadController
                                                      .insurancenumber.value =
                                                  documentUploadController
                                                      .InsuranceNumber
                                                      .value
                                                      .text;
                                            }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                                Get.key.currentContext!)!
                                            .txt_upload_image,
                                        style: drawerTextStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              // FocusScope.of(context).unfocus();

                                              await documentUploadController
                                                  .cameraGallery(false)
                                                  .then((value) {
                                                documentUploadController
                                                        .InsuranceFrontImage =
                                                    value;
                                                print(
                                                    "insurance..  ${documentUploadController.InsuranceFrontImage}");
                                                if (documentUploadController
                                                            .InsuranceFrontImage ==
                                                        null ||
                                                    documentUploadController
                                                            .InsuranceFrontImage ==
                                                        "") {
                                                  documentUploadController
                                                      .isInsuranceFrontUpload
                                                      .value = false;
                                                } else {
                                                  documentUploadController
                                                      .isInsuranceFrontUpload
                                                      .value = true;
                                                }

                                                documentUploadController
                                                    .DriverDocumentUpload(
                                                        AppLocalizations.of(Get
                                                                .key
                                                                .currentContext!)!
                                                            .txt_vehicle_insur,
                                                        "Vehicle Insurance",
                                                        documentUploadController
                                                            .InsuranceNumber
                                                            .value
                                                            .text
                                                            .toString(),
                                                        documentUploadController
                                                                .InsuranceFrontImage
                                                            .toString(),
                                                        "",
                                                        "",
                                                        "");
                                              });
                                            },
                                            child: Obx(
                                              () => (documentUploadController
                                                          .isInsuranceFrontUpload
                                                          .value ==
                                                      true)
                                                  ? Container(
                                                      width: 50,
                                                      height: 30,
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: ConstColor
                                                            .hintgreyaccentColor,
                                                      ),
                                                      child: const Icon(
                                                          Icons.check))
                                                  : Container(
                                                      width: 50,
                                                      height: 30,
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      decoration: BoxDecoration(
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
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                              Get.key.currentContext!)!
                                          .txt_valid_until,
                                      style: loginFormHeadingStyleB,
                                    ),
                                    Spacer(),
                                    Stack(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            // showMe(context);
                                            documentUploadController
                                                    .InsuranceUntil.value =
                                                await documentUploadController
                                                    .selectDate(context,
                                                        "until", "insurance");

                                            documentUploadController
                                                .DriverDocumentUpload(
                                                    AppLocalizations.of(
                                                            Get.key
                                                                .currentContext!)!
                                                        .txt_vehicle_insur,
                                                    "Vehicle Insurance",
                                                    documentUploadController
                                                        .InsuranceNumber
                                                        .value
                                                        .text
                                                        .toString(),
                                                    documentUploadController
                                                            .InsuranceFrontImage
                                                        .toString(),
                                                    "",
                                                    "",
                                                    documentUploadController
                                                            .InsuranceUntil
                                                        .toString());
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 140,
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                                top: 5,
                                                bottom: 5,
                                                start: 8,
                                                end: 5),
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: ConstColor.accentColor,
                                            ),
                                            child: Obx(
                                              () => Text(
                                                documentUploadController
                                                    .InsuranceUntil.value,
                                                // focusNode: AlwaysDisabledFocusNode(),
                                                // decoration:
                                                //     const InputDecoration(enabledBorder: InputBorder.none),
                                                style: const TextStyle(
                                                    fontSize: 13),
                                                // controller: dateAssign("from"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              FocusScope.of(context).unfocus();
                                              // showMe(context);
                                              documentUploadController
                                                      .InsuranceUntil.value =
                                                  await documentUploadController
                                                      .selectDate(context,
                                                          "until", "insurance");

                                              documentUploadController
                                                  .DriverDocumentUpload(
                                                      AppLocalizations.of(Get.key
                                                              .currentContext!)!
                                                          .txt_vehicle_insur,
                                                      "Vehicle Insurance",
                                                      documentUploadController
                                                          .InsuranceNumber
                                                          .value
                                                          .text
                                                          .toString(),
                                                      documentUploadController
                                                              .InsuranceFrontImage
                                                          .toString(),
                                                      "",
                                                      "",
                                                      documentUploadController
                                                              .InsuranceUntil
                                                          .toString());
                                            },
                                            child: Container(
                                              alignment: AlignmentDirectional
                                                  .centerEnd,
                                              child: Icon(
                                                Icons.arrow_drop_down,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ]),
                            ],
                          ),
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        DivTile(),
                        const SizedBox(
                          height: 25,
                        ),
                        CommonButton(
                          width: 240,
                          color: ConstColor.accentColor,
                          // txtStyle: buttonBlackTitleStyle,
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            Get.toNamed("DocumentUploadScreen2");
                          },
                          title: AppLocalizations.of(Get.key.currentContext!)!
                              .txt_next,
                        ),
                        const SizedBox(height: 25),
                      ]),
                    ),
                  ],
                ),
              ),
            )),
      );
    }));
  }
}

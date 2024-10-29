import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';

import '../../../utils/app_constents.dart';
import '../../../utils/const_color.dart';
import '../../../utils/style.dart';
import '../../../utils/toast.dart';
import '../../../utils/user_session.dart';
import '../../controller/document_upload_controller.dart';
import '../custom_widget/commonbutton.dart';

class TakeDocumnetScreen extends StatefulWidget {
  static String routeName = "TakeDocumnetScreen";

  const TakeDocumnetScreen({Key? key}) : super(key: key);

  @override
  State<TakeDocumnetScreen> createState() => _TakeDocumnetScreenState();
}

class _TakeDocumnetScreenState extends State<TakeDocumnetScreen> {
  var id, typee, value, frontImg, backImg, from, until, name;
  List<String> multiFrontImg = [];

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

  DocumentUploadController documentUploadController =
      Get.put(DocumentUploadController());

  genderValue(String gender) {
    print("gender...  " + gender.toString());
    if (gender == "0") {
      return AppConstents().txtMale;
    } else if (gender == "1") {
      return AppConstents().txtFemale;
    } else if (gender == "2") {
      return AppConstents().txtNoPref;
    } else {
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    id = Get.arguments['documentId'];
    typee = Get.arguments['type'];
    name = Get.arguments['name'];
    value = Get.arguments['value'];
    frontImg = Get.arguments['front_img'];
    backImg = Get.arguments['back_img'];
    from = Get.arguments['from'];
    until = Get.arguments['until'];
    documentUploadController.bitmapBack.value = '';
    documentUploadController.bitmapFront.value = '';
    documentUploadController.genderTxt.value =
        genderValue(Get.arguments['value']);
    UserSession.isCurrentLoading = documentUploadController.isLoading;
    // documentUploadController.CarMaker.text = value;
    // documentUploadController.CarModel.text = value;
    // documentUploadController.CarColor.text = value;
    // documentUploadController.PassengerNo.value = value;

    print(
        "${"type and value..   " + typee + "   " + value + "  " + frontImg + " " + backImg}");
  }

  void dispose() {
    super.dispose();
    Get.delete<DocumentUploadController>();
    // documentUploadController.disposeSomeData();
  }

  bool obsecureTextShow = true;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ProgressHUD(
        inAsyncCall: documentUploadController.isLoading.value,
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

            // decoration: authBgDecoration,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: ConstColor.accentColor,
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Image.asset(
                      AppConstents.arrowBack,
                      color: ConstColor.blackColor,
                      height: 20,
                      width: 20,
                    )),
              ),
              backgroundColor: ConstColor.accentColor,
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Column(children: [
                  // const BlueCurveLogoWidget(),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.center,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        dynamicData(typee.toString()),
                        textAlign: TextAlign.center,
                        style: black14Bold600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  UIAccordingToType(),

                  const SizedBox(
                    height: 60,
                  ),
                  (typee == "Security Deposit")
                      ? Container()
                      // :  documentUploadController.isLoading == true
                      //         ? Center(child: CircularProgressIndicator())
                      : CommonButton(
                          width: 180,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (typee == "Car Maker") {
                              if (documentUploadController
                                      .CarMaker.value.text ==
                                  "".trim()) {
                                showFlutterToast(
                                    message: AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_maker_name);
                              } else {
                                documentUploadController.DriverDocumentEdit(
                                    id,
                                    name,
                                    typee,
                                    documentUploadController
                                        .CarMaker.value.text,
                                    "",
                                    "",
                                    "",
                                    "");
                              }
                            } else if (typee == "Car Model") {
                              if (documentUploadController
                                      .CarModel.value.text ==
                                  "") {
                                showFlutterToast(
                                    message: AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_model_name);
                              } else {
                                documentUploadController.DriverDocumentEdit(
                                    id,
                                    name,
                                    typee,
                                    documentUploadController
                                        .CarModel.value.text,
                                    "",
                                    "",
                                    "",
                                    "");
                              }
                            } else if (typee == "Car Color") {
                              if (documentUploadController
                                      .CarColor.value.text ==
                                  "") {
                                showFlutterToast(
                                    message: AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_color_name);
                              } else {
                                documentUploadController.DriverDocumentEdit(
                                    id,
                                    name,
                                    typee,
                                    documentUploadController
                                        .CarColor.value.text,
                                    "",
                                    "",
                                    "",
                                    "");
                              }
                            } else if (typee == "No. Of Passenger") {
                              if (documentUploadController.PassengerNo.value ==
                                      "" ||
                                  documentUploadController.PassengerNo.value ==
                                      AppLocalizations.of(
                                              Get.key.currentContext!)!
                                          .txt_select) {
                                showFlutterToast(
                                    message: AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_select_passenger);
                              } else {
                                documentUploadController.DriverDocumentEdit(
                                    id,
                                    name,
                                    typee,
                                    documentUploadController.PassengerNo.value,
                                    "",
                                    "",
                                    "",
                                    "");
                              }
                            } else if (typee == "Vehicle Picture") {
                              if ((multiFrontImg.length <= 0)) {
                                showFlutterToast(
                                    message: AppConstents().txtSelectMinOne);
                              } else {
                                documentUploadController.DriverDocumentEdit(id,
                                    name, typee, "", multiFrontImg, "", "", "");
                              }
                            } else if (typee == "Gender Preferences") {
                              documentUploadController.DriverDocumentEdit(
                                  id,
                                  name,
                                  typee,
                                  genderType(
                                      documentUploadController.genderTxt.value),
                                  "",
                                  "",
                                  "",
                                  "");
                            } else if (typee == "Criminal Record") {
                              documentUploadController.DriverDocumentEdit(
                                  id,
                                  AppConstents().txtCriminalRecord,
                                  "Criminal Record",
                                  "",
                                  documentUploadController.CirminalRecordImage
                                      .toString(),
                                  "",
                                  "",
                                  "");
                            } else {
                              if ((documentUploadController.bitmapFront.value ==
                                      "") &&
                                  (documentUploadController.bitmapBack.value ==
                                      "")) {
                                showFlutterToast(
                                    message: AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .val_upload_doc);
                              } else {
                                documentUploadController.DriverDocumentEdit(
                                    id,
                                    name,
                                    typee,
                                    value,
                                    frontImg,
                                    backImg,
                                    from,
                                    until);
                              }
                            }

                            //  if ((typee == "Driver Identification card") ||
                            //     (typee == "Driver driving license") ||
                            //     (typee == "Vehicle registration") ||
                            //     (typee == "Vehicle ownership") ||
                            //     (typee == "Vehicle Insurance") ||
                            //     (typee == "Vehicle Inspection") ||
                            //     (typee == "Vehicle manifest") ||
                            //     (typee == "Vehicle radio tax")) {
                          },
                          title: AppConstents().txtUpdate,
                        ),

                  const SizedBox(height: 25),
                ]),
              ),
            ))));
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

  dynamicData(String typee) {
    if (typee == "Car Maker") {
      return "${AppConstents().txtEnterDetails} ${AppLocalizations.of(Get.key.currentContext!)!.txt_car_maker}";
    } else if (typee == "Car Model") {
      return "${AppConstents().txtEnterDetails} ${AppLocalizations.of(Get.key.currentContext!)!.txt_car_model}";
    } else if (typee == "Car Color") {
      return "${AppConstents().txtEnterDetails} ${AppLocalizations.of(Get.key.currentContext!)!.txt_car_color}";
    } else if (typee == "No. Of Passenger") {
      return "${AppLocalizations.of(Get.key.currentContext!)!.txt_select} ${AppLocalizations.of(Get.key.currentContext!)!.txt_no_pass}";
    } else if (typee == "Vehicle Picture") {
      return "${AppConstents().txtUploadPhoto} ${AppConstents().txtVehicle}";
    } else if (typee == "Driver Identification card") {
      return "${AppConstents().txtUploadPhoto} ${AppLocalizations.of(Get.key.currentContext!)!.txt_driver_id_card}";
    } else if (typee == "Driver driving license") {
      return "${AppConstents().txtUploadPhoto} ${AppLocalizations.of(Get.key.currentContext!)!.txt_driver_driving_license}";
    } else if (typee == "Vehicle registration") {
      return "${AppConstents().txtUploadPhoto} ${AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_reg} ${AppConstents().txtDetails}";
    } else if (typee == "Vehicle ownership") {
      return "${AppConstents().txtUploadPhoto} ${AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_owner} ${AppConstents().txtDetails}";
    } else if (typee == "Vehicle Insurance") {
      return "${AppConstents().txtUploadPhoto} ${AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_insur}";
    } else if (typee == "Vehicle Inspection") {
      return "${AppConstents().txtUploadPhoto} ${AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_inspec} ${AppConstents().txtDetails}";
    } else if (typee == "Vehicle manifest") {
      return "${AppConstents().txtUploadPhoto} ${AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_mani}";
    } else if (typee == "Vehicle radio tax") {
      return "${AppConstents().txtUploadPhoto} ${AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_radio} ${AppConstents().txtDetails}";
    } else if (typee == "Security Deposit") {
      return AppConstents().completeSecurityDeposit;
    } else if (typee == "Gender Preferences") {
      return "${AppConstents().txtUpdateDetails} ${AppConstents().genderPreferences} \n ${AppConstents().genderPreferencesDetail}";
    } else if (typee == "Criminal Record") {
      return "${AppConstents().txtUpdateYour} ${AppConstents().txtCriminalRecord} ${AppConstents().txtDocument}";
    }
  }

  UIAccordingToType() {
    if (typee == "Car Maker") {
      return Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(start: 38, end: 35, bottom: 6),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                AppLocalizations.of(Get.key.currentContext!)!.txt_car_maker,
                style:
                    TextStyle(color: ConstColor.codeFieldColor, fontSize: 14),
              ),
            ),
            Container(
              height: 45,
              alignment: AlignmentDirectional.centerStart,
              margin: EdgeInsetsDirectional.only(start: 35, end: 35),
              padding: EdgeInsetsDirectional.only(start: 15, end: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: ConstColor.codeFieldColor, width: 1.0)),
              child: TextFormField(
                style: black14Normal500,
                textAlign: TextAlign.start,
                controller: documentUploadController.CarMaker.value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(Get.key.currentContext!)!
                      .txt_car_maker,
                  hintStyle: hintTextStyle,
                ),
              ),
            )
          ],
        ),
      );
    } else if (typee == "Car Model") {
      return Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(start: 38, end: 35, bottom: 6),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                AppLocalizations.of(Get.key.currentContext!)!.txt_car_model,
                style:
                    TextStyle(color: ConstColor.codeFieldColor, fontSize: 14),
              ),
            ),
            Container(
              height: 45,
              alignment: AlignmentDirectional.centerStart,
              margin: EdgeInsetsDirectional.only(start: 35, end: 35),
              padding: EdgeInsetsDirectional.only(start: 15, end: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: ConstColor.codeFieldColor, width: 1.0)),
              child: TextFormField(
                style: black14Normal500,
                textAlign: TextAlign.start,
                controller: documentUploadController.CarModel.value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(Get.key.currentContext!)!
                      .txt_car_model,
                  hintStyle: hintTextStyle,
                ),
              ),
            )
          ],
        ),
      );
    } else if (typee == "Car Color") {
      return Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsetsDirectional.only(
                  start: 38, end: 35, bottom: 6),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                AppLocalizations.of(Get.key.currentContext!)!.txt_car_color,
                style:
                    const TextStyle(color: ConstColor.blackColor, fontSize: 14),
              ),
            ),
            Container(
              height: 45,
              alignment: AlignmentDirectional.centerStart,
              margin: EdgeInsetsDirectional.only(start: 35, end: 35),
              padding: EdgeInsetsDirectional.only(start: 15, end: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: ConstColor.codeFieldColor, width: 1.0)),
              child: TextFormField(
                style: black14Normal500,
                textAlign: TextAlign.start,
                controller: documentUploadController.CarColor.value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(Get.key.currentContext!)!
                      .txt_car_color,
                  hintStyle: hintTextStyle,
                ),
              ),
            )
          ],
        ),
      );
    } else if (typee == "No. Of Passenger") {
      return Container(
          alignment: AlignmentDirectional.centerStart,
          // margin: EdgeInsetsDirectional.only(start: 40, end: 35, bottom: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsetsDirectional.only(start: 40, end: 35, bottom: 6),
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  AppLocalizations.of(Get.key.currentContext!)!.txt_no_pass,
                  style: black14Bold600,
                ),
              ),
              Container(
                  margin: EdgeInsetsDirectional.only(start: 38),
                  child: DropdownButton2(
                    isExpanded: false,
                    hint: Row(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            documentUploadController.PassengerNo.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ConstColor.primaryBlackColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: PassengerList.map((item) => DropdownMenuItem<String>(
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
                      setState(() {
                        documentUploadController.PassengerNo.value =
                            value as String;
                      });
                    },
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.black,
                    ),
                    buttonStyleData: ButtonStyleData(
                      height: 40,
                      width: 200,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: ConstColor.primaryBlackColor,
                        ),
                        color: ConstColor.accentColor,
                      ),
                      elevation: 2,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 170,
                      width: 200,
                      elevation: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: ConstColor.accentColor,
                      ),
                      offset: const Offset(0, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: WidgetStateProperty.all<double>(2),
                        thumbVisibility: WidgetStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 35,
                      padding: EdgeInsetsDirectional.only(start: 40),
                    ),
                  ))
            ],
          ));
    } else if (typee == "Vehicle Picture") {
      return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 35),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(bottom: 6),
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_pic,
                  style:
                      TextStyle(color: ConstColor.codeFieldColor, fontSize: 14),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 65,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: ConstColor.codeFieldColor, width: 1.0),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.transparent),
                // child:
                //     // Stack(children: [
                //     // Container(),
                //     Container(
                //   height: 50,
                //   decoration: BoxDecoration(
                //       border: Border.all(
                //           color: ConstColor.accentColor, width: 1.0),
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.transparent),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          documentUploadController.isLoading.value = true;
                          await documentUploadController
                              .cameraGallery(true)
                              .then((value) {
                            print("multiple.. value..  " + value.toString());
                            // value = [value];
                            if (value == null) {
                              multiFrontImg = [];
                              documentUploadController.isLoading.value = false;
                            } else {
                              var returnVal = jsonDecode(value);
                              print(" multiple .. upload.. " +
                                  returnVal.toString());
                              // if (value.length > 10 || value.length < 1) {
                              //   documentUploadController
                              //       .isVehicleFrontUpload.value = false;
                              // } else {
                              //   documentUploadController
                              //       .isVehicleFrontUpload.value = true;
                              // }

                              if (returnVal != null) {
                                for (int i = 0; i < returnVal.length; i++) {
                                  log("value.  path..  " +
                                      returnVal[i].toString());
                                  multiFrontImg.add(returnVal[i]['path']);
                                  log("multi image picker..frontImg   " +
                                      multiFrontImg.toString());
                                }
                                documentUploadController.isLoading.value =
                                    false;
                              }
                            }
                          });
                        },
                        child: Container(
                          height: 45,
                          margin: EdgeInsetsDirectional.only(start: 10),
                          decoration: BoxDecoration(
                              // border: Border.all(
                              //     color: ConstColor.accentColor, width: 1.0),
                              borderRadius: BorderRadius.circular(8),
                              color: ConstColor.pendingYellow.withOpacity(0.6)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Container(
                                    child: Image.asset(
                                  AppConstents.uploadIcon,
                                  height: 35,
                                  width: 35,
                                  color: ConstColor.codeFieldColor,
                                )),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  child: Text(
                                    AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_upload,
                                    style: TextStyle(
                                        color: ConstColor.codeFieldColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                              ]),
                        ),
                      ),
                      Obx(() => Expanded(
                            child: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              margin: EdgeInsetsDirectional.only(end: 10),
                              child: Text(
                                textAlign: TextAlign.end,
                                documentUploadController
                                            .isVehicleFrontUpload.value ==
                                        true
                                    ? AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_uploaded
                                    : AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_select_max,
                                // softWrap: true,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: ConstColor.codeFieldColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    ]),
                // )
                //]),
              )
            ],
          ));
    } else if (typee == "Driver Identification card") {
      return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "front")
                          .then((value) {
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + frontImg.toString());
                          frontImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            color: ConstColor.pendingYellow.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: (documentUploadController.bitmapFront.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.FrontFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: ConstColor.codeFieldColor,
                                            )),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapFront.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapFront.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_front,
                    style: black16Bold600,
                  )
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "back")
                          .then((value) {
                        print("value back..   " + value.toString());
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());

                          backImg = returnVal;
                          print("back Img..  " + backImg.toString());
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapBack.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.BackFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                                Icons.picture_as_pdf,
                                                color:
                                                    ConstColor.codeFieldColor)),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapBack.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapBack.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_back,
                    style: black16Bold600,
                  )
                ],
              )
            ],
          ));
    } else if (typee == "Driver driving license") {
      return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "front")
                          .then((value) {
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + frontImg.toString());
                          frontImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapFront.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.FrontFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: ConstColor.codeFieldColor,
                                            )),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapFront.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapFront.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_front,
                    style: black16Bold600,
                  )
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "back")
                          .then((value) {
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + backImg.toString());
                          backImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapBack.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.BackFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                                Icons.picture_as_pdf,
                                                color:
                                                    ConstColor.codeFieldColor)),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapBack.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapBack.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_back,
                    style: black16Bold600,
                  )
                ],
              )
            ],
          ));
    } else if (typee == "Vehicle registration") {
      return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "front")
                          .then((value) {
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + frontImg.toString());
                          frontImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapFront.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.FrontFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: ConstColor.codeFieldColor,
                                            )),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapFront.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapFront.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_front,
                    style: black16Bold600,
                  )
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "back")
                          .then((value) {
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + backImg.toString());
                          backImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapBack.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.BackFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: ConstColor.codeFieldColor,
                                            )),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapBack.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapBack.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_back,
                    style: black16Bold600,
                  )
                ],
              )
            ],
          ));
    } else if (typee == "Vehicle ownership") {
      return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "front")
                          .then((value) {
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + frontImg.toString());
                          frontImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapFront.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.FrontFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: ConstColor.codeFieldColor,
                                            )),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapFront.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapFront.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_front,
                    style: black16Bold600,
                  )
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "back")
                          .then((value) {
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + backImg.toString());
                          backImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapBack.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.BackFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: ConstColor.codeFieldColor,
                                            )),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapBack.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapBack.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_back,
                    style: black16Bold600,
                  )
                ],
              )
            ],
          ));
    } else if (typee == "Vehicle Insurance") {
      return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "front")
                          .then((value) {
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + frontImg.toString());
                          frontImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapFront.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.FrontFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: ConstColor.codeFieldColor,
                                            )),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapFront.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapFront.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_upload,
                    style: black16Bold600,
                  )
                ],
              ),
              // const SizedBox(
              //   width: 5,
              // ),
              // Column(
              //   children: [
              //     InkWell(
              //       onTap: () async {
              //         backImg =
              //             await documentUploadController.EditPickFile("back");
              //       },
              //       child: Obx(
              //         () => Container(
              //             height: 100,
              //             width: 150,
              //             decoration: BoxDecoration(
              //                 color: ConstColor.accentColor.withOpacity(0.2),
              //                 borderRadius: BorderRadius.circular(15)),
              //             child: (documentUploadController.bitmapBack.value ==
              //                         null ||
              //                     documentUploadController.bitmapBack.value ==
              //                         "")
              //                 ? Center(
              //                     child: Image.asset(
              //                     AppConstents.uploadIcon,
              //                     height: 50,
              //                     width: 50,
              //                   ))
              //                 : documentUploadController.BackFileType.value ==
              //                         "pdf"
              //                     ? Container(
              //                         child: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.center,
              //                         children: [
              //                           Container(
              //                               width: 50,
              //                               height: 50,
              //                               child: const Icon(
              //                                 Icons.picture_as_pdf,
              //                                 color: Colors.white,
              //                               )),
              //                           Expanded(
              //                               child: Container(
              //                                   margin:
              //                                       const EdgeInsetsDirectional
              //                                               .only(
              //                                           start: 10,
              //                                           end: 10,
              //                                           bottom: 10),
              //                                   child: Text(
              //                                       documentUploadController
              //                                           .bitmapBack.value,
              //                                       softWrap: true,
              //                                       style:
              //                                           notificationTextStyle)))
              //                         ],
              //                       ))
              //                     : ClipRect(
              //                         child: Image.file(File(
              //                             documentUploadController
              //                                 .bitmapBack.value)),
              //                       )),
              //       ),
              //     ),
              //     const SizedBox(
              //       height: 10,
              //     ),
              //     Text(
              //       AppLocalizations.of(Get.key.currentContext!)!.txt_back,
              //       style: buttonTitleStyle,
              //     )
              //   ],
              // )
            ],
          ));
    } else if (typee == "Vehicle Inspection") {
      return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "front")
                          .then((value) {
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + frontImg.toString());
                          frontImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapFront.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.FrontFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: ConstColor.codeFieldColor,
                                            )),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapFront.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapFront.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_upload,
                    style: black16Bold600,
                  )
                ],
              ),
              // const SizedBox(
              //   width: 5,
              // ),
              // Column(
              //   children: [
              //     InkWell(
              //       onTap: () async {
              //         backImg =
              //             await documentUploadController.EditPickFile("back");
              //       },
              //       child: Obx(
              //         () => Container(
              //             height: 100,
              //             width: 150,
              //             decoration: BoxDecoration(
              //                 color: ConstColor.accentColor.withOpacity(0.2),
              //                 borderRadius: BorderRadius.circular(15)),
              //             child: (documentUploadController.bitmapBack.value ==
              //                         null ||
              //                     documentUploadController.bitmapBack.value ==
              //                         "")
              //                 ? Center(
              //                     child: Image.asset(
              //                     AppConstents.uploadIcon,
              //                     height: 50,
              //                     width: 50,
              //                   ))
              //                 : documentUploadController.BackFileType.value ==
              //                         "pdf"
              //                     ? Container(
              //                         child: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.center,
              //                         children: [
              //                           Container(
              //                               width: 50,
              //                               height: 50,
              //                               child: const Icon(
              //                                 Icons.picture_as_pdf,
              //                                 color: Colors.white,
              //                               )),
              //                           Expanded(
              //                               child: Container(
              //                                   margin:
              //                                       const EdgeInsetsDirectional
              //                                               .only(
              //                                           start: 10,
              //                                           end: 10,
              //                                           bottom: 10),
              //                                   child: Text(
              //                                       documentUploadController
              //                                           .bitmapBack.value,
              //                                       softWrap: true,
              //                                       style:
              //                                           notificationTextStyle)))
              //                         ],
              //                       ))
              //                     : ClipRect(
              //                         child: Image.file(File(
              //                             documentUploadController
              //                                 .bitmapBack.value)),
              //                       )),
              //       ),
              //     ),
              //     const SizedBox(
              //       height: 10,
              //     ),
              //     Text(
              //       AppLocalizations.of(Get.key.currentContext!)!.txt_back,
              //       style: buttonTitleStyle,
              //     )
              //   ],
              // )
            ],
          ));
    } else if (typee == "Vehicle manifest") {
      return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "front")
                          .then((value) {
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + frontImg.toString());
                          frontImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapFront.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.FrontFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: ConstColor.codeFieldColor,
                                            )),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapFront.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapFront.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_upload,
                    style: black16Bold600,
                  )
                ],
              ),
              // const SizedBox(
              //   width: 5,
              // ),
              // Column(
              //   children: [
              //     InkWell(
              //       onTap: () async {
              //         backImg =
              //             await documentUploadController.EditPickFile("back");
              //       },
              //       child: Obx(
              //         () => Container(
              //             height: 100,
              //             width: 150,
              //             decoration: BoxDecoration(
              //                 color: ConstColor.accentColor.withOpacity(0.2),
              //                 borderRadius: BorderRadius.circular(15)),
              //             child: (documentUploadController.bitmapBack.value ==
              //                         null ||
              //                     documentUploadController.bitmapBack.value ==
              //                         "")
              //                 ? Center(
              //                     child: Image.asset(
              //                     AppConstents.uploadIcon,
              //                     height: 50,
              //                     width: 50,
              //                   ))
              //                 : documentUploadController.BackFileType.value ==
              //                         "pdf"
              //                     ? Container(
              //                         child: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.center,
              //                         children: [
              //                           Container(
              //                               width: 50,
              //                               height: 50,
              //                               child: const Icon(
              //                                 Icons.picture_as_pdf,
              //                                 color: Colors.white,
              //                               )),
              //                           Expanded(
              //                               child: Container(
              //                                   margin:
              //                                       const EdgeInsetsDirectional
              //                                               .only(
              //                                           start: 10,
              //                                           end: 10,
              //                                           bottom: 10),
              //                                   child: Text(
              //                                       documentUploadController
              //                                           .bitmapBack.value,
              //                                       softWrap: true,
              //                                       style:
              //                                           notificationTextStyle)))
              //                         ],
              //                       ))
              //                     : ClipRect(
              //                         child: Image.file(File(
              //                             documentUploadController
              //                                 .bitmapBack.value)),
              //                       )),
              //       ),
              //     ),
              //     const SizedBox(
              //       height: 10,
              //     ),
              //     Text(
              //       AppLocalizations.of(Get.key.currentContext!)!.txt_back,
              //       style: buttonTitleStyle,
              //     )
              //   ],
              // )
            ],
          ));
    } else if (typee == "Vehicle radio tax") {
      return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await documentUploadController
                          .cameraGallery(false, isEdit: true, imgType: "front")
                          .then((value) {
                        print("value...radio   " + value.toString());
                        if (value != null) {
                          var returnVal = jsonDecode(value);
                          print(
                              " multiple .. upload.. " + returnVal.toString());
                          print("back Img..  " + frontImg.toString());
                          frontImg = returnVal;
                        }
                      });
                    },
                    child: Obx(
                      () => Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                              color: ConstColor.pendingYellow.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15)),
                          child: (documentUploadController.bitmapFront.value ==
                                  "")
                              ? Center(
                                  child: Image.asset(
                                  AppConstents.uploadIcon,
                                  color: ConstColor.codeFieldColor,
                                  height: 50,
                                  width: 50,
                                ))
                              : documentUploadController.FrontFileType.value ==
                                      "pdf"
                                  ? Container(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: ConstColor.codeFieldColor,
                                            )),
                                        Expanded(
                                            child: Container(
                                                margin:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        start: 10,
                                                        end: 10,
                                                        bottom: 10),
                                                child: Text(
                                                    documentUploadController
                                                        .bitmapFront.value,
                                                    softWrap: true,
                                                    style: black14Normal400)))
                                      ],
                                    ))
                                  : ClipRect(
                                      child: Image.file(File(
                                          documentUploadController
                                              .bitmapFront.value)),
                                    )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_upload,
                    style: black16Bold600,
                  )
                ],
              ),
              // const SizedBox(
              //   width: 5,
              // ),
              // Column(
              //   children: [
              //     InkWell(
              //       onTap: () async {
              //         backImg =
              //             await documentUploadController.EditPickFile("back");
              //       },
              //       child: Obx(
              //         () => Container(
              //             height: 100,
              //             width: 150,
              //             decoration: BoxDecoration(
              //                 color: ConstColor.accentColor.withOpacity(0.2),
              //                 borderRadius: BorderRadius.circular(15)),
              //             child: (documentUploadController.bitmapBack.value ==
              //                         null ||
              //                     documentUploadController.bitmapBack.value ==
              //                         "")
              //                 ? Center(
              //                     child: Image.asset(
              //                     AppConstents.uploadIcon,
              //                     height: 50,
              //                     width: 50,
              //                   ))
              //                 : documentUploadController.BackFileType.value ==
              //                         "pdf"
              //                     ? Container(
              //                         child: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.center,
              //                         children: [
              //                           Container(
              //                               width: 50,
              //                               height: 50,
              //                               child: const Icon(
              //                                 Icons.picture_as_pdf,
              //                                 color: Colors.white,
              //                               )),
              //                           Expanded(
              //                               child: Container(
              //                                   margin:
              //                                       const EdgeInsetsDirectional
              //                                               .only(
              //                                           start: 10,
              //                                           end: 10,
              //                                           bottom: 10),
              //                                   child: Text(
              //                                       documentUploadController
              //                                           .bitmapBack.value,
              //                                       softWrap: true,
              //                                       style:
              //                                           notificationTextStyle)))
              //                         ],
              //                       ))
              //                     : ClipRect(
              //                         child: Image.file(File(
              //                             documentUploadController
              //                                 .bitmapBack.value)),
              //                       )),
              //       ),
              //     ),
              //     const SizedBox(
              //       height: 10,
              //     ),
              //     Text(
              //       AppLocalizations.of(Get.key.currentContext!)!.txt_back,
              //       style: buttonTitleStyle,
              //     )
              //   ],
              // )
            ],
          ));
    } else if (typee == "Security Deposit") {
      return Container(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsetsDirectional.only(start: 20, end: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // InkWell(
                //   onTap: () {
                //     // documentUploadController.isLoading.value = true;
                //     // documentUploadController.getMpesaDetail();
                //     // Get.back();
                //     documentUploadController.checkoutApi();
                //   },
                //   child: Container(
                //     margin: EdgeInsetsDirectional.only(top: 7),
                //     width: 95,
                //     height: 57,
                //     decoration: BoxDecoration(
                //         border: Border.all(
                //           color: ConstColor.codeBackgroundColor,
                //         ),
                //         borderRadius: BorderRadius.circular(4)),
                //     child: Container(
                //       // margin: EdgeInsetsDirectional.only(top: 4, bottom: 4),
                //       height: 45,
                //       width: 45,
                //       child: Image.asset(
                //         'assets/images/ic_paypal.png',
                //         fit: BoxFit.fill,
                //         // height: 45,
                //         // width: 45,
                //       ),
                //     ),
                //   ),
                // ),

                InkWell(
                    onTap: () {
                      // Get.back();
                      Map map = {
                        "security_deposit": "0",
                        "payment_method": "Cash",
                        "payment_mode": "Cash",
                        "transection_id": "",
                        "amount": UserSession.getStringFromSession(
                            UserSession.keySecurityAmt)
                      };
                      documentUploadController.securityDeposit = true;
                      documentUploadController.isLoading.value = true;
                      documentUploadController.updateSecurityDeposit(map, "0");
                    },
                    child: Container(
                        margin: EdgeInsetsDirectional.only(top: 7),
                        width: 95,
                        height: 57,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ConstColor.codeFieldColor,
                            ),
                            borderRadius: BorderRadius.circular(4)),
                        child: Container(
                            // margin:
                            //   EdgeInsetsDirectional.only(top: 4, bottom: 4),
                            height: 45,
                            width: 45,
                            child: Image.asset(
                              'assets/images/ic_cash.png',
                              fit: BoxFit.fill,
                              width: 100,
                              height: 140,
                            )))),
              ],
            ),
          ),
        ],
      ));
    } else if (typee == "Gender Preferences") {
      return Obx(
        () => Container(
          // height: 40,
          margin: const EdgeInsetsDirectional.only(
              bottom: 10, top: 2, start: 20, end: 20),
          alignment: AlignmentDirectional.topStart,
          child: RadioGroup<String>.builder(
            direction: Axis.vertical,
            groupValue: documentUploadController.genderTxt.value,
            horizontalAlignment: MainAxisAlignment.spaceBetween,
            activeColor: ConstColor.codeFieldColor,
            fillColor: ConstColor.codeFieldColor,
            onChanged: (value) {
              if (kDebugMode) {
                print("gender preference ,,,   $value");
              } else {
                print("gender preference ,,,  11 $value");
              }
              documentUploadController.genderTxt.value = value ?? '';
            },
            items: documentUploadController.genderPreference,
            textStyle: const TextStyle(
              fontSize: 14,
              color: ConstColor.codeFieldColor,
            ),
            itemBuilder: (item) => RadioButtonBuilder(
              item,
            ),
          ),
        ),
      );
    } else if (typee == "Criminal Record") {
      return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 35),
          child: Column(children: [
            Container(
              margin: const EdgeInsetsDirectional.only(bottom: 6),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                AppConstents().txtCriminalRecord,
                style: black14Bold600,
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 52,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: ConstColor.codeFieldColor, width: 1.0),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.transparent),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        documentUploadController.CirminalRecordImage.value =
                            (await documentUploadController.pickFile())!;
                        print(
                            "CirminalRecordImage...${documentUploadController.CirminalRecordImage.value}");
                      },
                      child: Container(
                        width: 70,
                        height: 30,
                        margin: const EdgeInsetsDirectional.only(start: 14),
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: ConstColor.pendingYellow.withOpacity(0.6),
                        ),
                        child: Text(
                            AppLocalizations.of(Get.key.currentContext!)!
                                .txt_upload),
                      ),
                    ),
                    Obx(() => Expanded(
                            child: Container(
                          margin: const EdgeInsetsDirectional.only(
                              start: 10, end: 10),
                          child: Text(
                            documentUploadController.CirminalRecordImage.value,
                            textAlign: TextAlign.end,
                            // overflow: TextOverflow.fade,
                            style: black14Normal400,
                          ),
                        )))
                  ],
                ))
          ]));
    }
  }
}

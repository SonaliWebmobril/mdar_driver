import 'package:flutter/material.dart';
import 'package:madr_driver/utils/StringExtension.dart';
import 'package:madr_driver/utils/toast.dart';
import '../../../utils/const_color.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/style.dart';
import 'package:get/get.dart';

import '../../../utils/user_session.dart';
import '../../controller/document_upload_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewDocumentScreen extends StatefulWidget {
  static String routeName = "AddNewDocumentScreen";
  const AddNewDocumentScreen({Key? key}) : super(key: key);

  @override
  State<AddNewDocumentScreen> createState() => _AddNewDocumentScreenState();
}

class _AddNewDocumentScreenState extends State<AddNewDocumentScreen> {
  DocumentUploadController documentUploadController =
      Get.put(DocumentUploadController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserSession.isCurrentLoading = documentUploadController.isLoading;
      documentUploadController.DriverDocumentList();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    documentUploadController.disposeData();
  }

  bool obsecureTextShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstColor.accentColor,
        resizeToAvoidBottomInset: false,
        appBar: ReusableWidgets.getAppBar(
            // AppLocalizations.of(Get.key.currentContext!)!.txt_upload_details
            AppConstents().updateDetails),
        body: SafeArea(
            child: Obx(() => ProgressHUD(
                color: ConstColor.accentColor,
                inAsyncCall: documentUploadController.documentListLoader.value,
                child: Container(
                  margin: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsetsDirectional.symmetric(
                              horizontal: 15),
                          child: Column(
                            children: [
                              Obx(
                                () => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: documentUploadController
                                      .documentListModel.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var data = documentUploadController
                                        .documentListModel[index];
                                    print("data index..   ${data.toJson()}");
                                    if (data.type == "Security Deposit" &&
                                        data.value == "1") {
                                      return Container();
                                    } else {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .symmetric(horizontal: 4),
                                            child: Container(
                                              // decoration: const BoxDecoration(
                                              //   color: ConstColor.textColor,
                                              //   borderRadius: BorderRadius.all(
                                              //     Radius.circular(32),
                                              //   ),
                                              //),
                                              child: ListTile(
                                                onTap: () {
                                                  Get.toNamed(
                                                      "TakeDocumnetScreen",
                                                      arguments: {
                                                        'documentId':
                                                            data.sId.toString(),
                                                        'type': data.type
                                                            .toString(),
                                                        'name': data.name
                                                            .toString(),
                                                        'value': data.value
                                                            .toString(),
                                                        'front_img': data
                                                            .frontImg
                                                            .toString(),
                                                        'back_img': data.backImg
                                                            .toString(),
                                                        'from': data.from
                                                            .toString(),
                                                        'until': data.until
                                                            .toString(),
                                                      });
                                                },
                                                title: Text(
                                                  dynamicData(
                                                      data.type.toString(),
                                                      data.value.toString()),
                                                  // data.name.toString(),
                                                  style: black14Normal500,
                                                ),
                                                trailing: Image.asset(
                                                    AppConstents.arrowFarword,
                                                    color: ConstColor
                                                        .codeFieldColor,
                                                    height: 16,
                                                    width: 16),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .symmetric(horizontal: 18),
                                            // padding: const EdgeInsets.all(8.0),
                                            child: commonDivider(),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )))));
  }

  dynamicData(String typee, String val) {
    print("typee.  ..  $typee");
    if (typee == "Car Maker") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_car_maker)
          .toTitleCase();
    } else if (typee == "Car Model") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_car_model)
          .toTitleCase();
    } else if (typee == "Car Color") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_car_color)
          .toTitleCase();
    } else if (typee == "No. Of Passenger") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_no_pass)
          .toTitleCase();
    } else if (typee == "Vehicle Picture") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_pic)
          .toTitleCase();
    } else if (typee == "Driver Identification card") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_driver_id_card)
          .toTitleCase();
    } else if (typee == "Driver driving license") {
      return (AppLocalizations.of(Get.key.currentContext!)!
              .txt_driver_driving_license)
          .toTitleCase();
    } else if (typee == "Vehicle registration") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_reg)
          .toTitleCase();
    } else if (typee == "Vehicle ownership") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_owner)
          .toTitleCase();
    } else if (typee == "Vehicle Insurance") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_insur)
          .toTitleCase();
    } else if (typee == "Vehicle Inspection") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_inspec)
          .toTitleCase();
    } else if (typee == "Vehicle manifest") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_mani)
          .toTitleCase();
    } else if (typee == "Vehicle radio tax") {
      return (AppLocalizations.of(Get.key.currentContext!)!.txt_vehicle_radio)
          .toTitleCase();
    } else if (typee == "Security Deposit" && val != "1") {
      return (AppConstents().securityDeposit).toTitleCase();
    } else if (typee == "Gender Preferences") {
      return (AppConstents().genderPreferences).toTitleCase();
    } else if (typee == "Criminal Record") {
      return (AppConstents().txtCriminalRecord).toTitleCase();
    } else {
      return "";
    }
  }
}

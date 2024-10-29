import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/utils/StringExtension.dart';
import 'package:madr_driver/design/controller/document_upload_controller.dart';
import 'package:madr_driver/utils/toast.dart';

import '../../../utils/const_color.dart';
import '../../../utils/app_constents.dart';
import 'package:madr_driver/design/auth_design/auth_model/document_list_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/user_session.dart';

class UploadedDocInfoScreen extends StatefulWidget {
  static String routeName = "UploadedDocInfoScreen";
  const UploadedDocInfoScreen({super.key});

  @override
  State<UploadedDocInfoScreen> createState() => _UploadedDocInfoScreenState();
}

class _UploadedDocInfoScreenState extends State<UploadedDocInfoScreen> {
  DocumentUploadController documentUploadController =
      Get.put(DocumentUploadController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      documentUploadController.DriverDocumentList();
      UserSession.isCurrentLoading = documentUploadController.isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstColor.accentColor,
        appBar: ReusableWidgets.getAppBar(
            AppLocalizations.of(Get.key.currentContext!)!
                .txt_uploaded_documents_info),
        body: SafeArea(
            child: Obx(() => ProgressHUD(
                color: ConstColor.accentColor,
                inAsyncCall: documentUploadController.documentListLoader.value,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Obx(
                        () => ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              documentUploadController.documentListModel.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var data = documentUploadController
                                .documentListModel[index];
                            print(
                                "data index..   ${documentUploadController.documentListModel.length}");

                            print("data index..   ${data.value}");
                            print(
                                "... ..   ${data.type == "Security Deposit" && data.value == "1"}");
                            return Container(
                                margin: const EdgeInsetsDirectional.only(
                                    start: 15, end: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonUploadedWidge(
                                        onpressed: () {},
                                        title:
                                            dynamicData(data.type.toString()),
                                        subTitle: verifyData(data)),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 18),
                                      // padding: const EdgeInsets.all(8.0),
                                      child: commonDivider(),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ));
                          },
                        ),
                      )
                    ],
                  ),
                )))));
  }

  dynamicData(String typee) {
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
    } else if (typee == "Security Deposit") {
      return (AppConstents().securityDeposit).toTitleCase();
    } else if (typee == "Gender Preferences") {
      return (AppConstents().genderPreferences).toTitleCase();
    } else if (typee == "Criminal Record") {
      return (AppConstents().txtCriminalRecord).toTitleCase();
    } else {
      return "";
    }
  }

  verifyData(DriverDocuments data) {
    if (data.type == "Security Deposit") {
      if (data.value == "1") {
        return AppLocalizations.of(Get.key.currentContext!)!.txt_approved;
      } else {
        return AppLocalizations.of(Get.key.currentContext!)!.txt_pending;
      }
    } else if (data.type == "Gender Preferences") {
      return genderValue(data.value.toString());
    } else if (data.type == "Criminal Record") {
      if (data.verifyStatus == 0) {
        return AppLocalizations.of(Get.key.currentContext!)!.txt_pending;
      } else if (data.verifyStatus == 1) {
        return AppLocalizations.of(Get.key.currentContext!)!.txt_approved;
      } else if (data.verifyStatus == 2) {
        return AppConstents().txtReject;
      }
    } else {
      if (data.verifyStatus == 0) {
        return AppLocalizations.of(Get.key.currentContext!)!.txt_pending;
      } else {
        return AppLocalizations.of(Get.key.currentContext!)!.txt_approved;
      }
    }
  }

  genderValue(String gender) {
    print("gender...  $gender");
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
}

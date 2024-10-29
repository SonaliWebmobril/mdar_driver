import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madr_driver/design/settings/controller/SupportController.dart';

import '../../../utils/const_color.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/style.dart';
import '../../../utils/toast.dart';
import '../../../utils/user_session.dart';
import '../../auth_design/custom_widget/commonbutton.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SupportScreen extends StatefulWidget {
  static String routeName = "SupportScreen";
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  SupportController supportController = Get.put(SupportController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserSession.isCurrentLoading = supportController.isLoading;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<SupportController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ProgressHUD(
          inAsyncCall: supportController.isLoading.value,
          child: Scaffold(
              backgroundColor: ConstColor.accentColor,
              appBar: ReusableWidgets.getAppBar(
                  AppLocalizations.of(Get.key.currentContext!)!.txt_support),
              body: SafeArea(
                  child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      Center(
                        child: Text(
                          AppLocalizations.of(Get.key.currentContext!)!
                              .txt_concern_queries,
                          style: black14Normal500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ConstColor.accentColor,
                              border: Border.all(
                                  color: ConstColor.blackColor, width: 0.5)),
                          margin: const EdgeInsetsDirectional.symmetric(
                              horizontal: 30),
                          child: TextField(
                            controller: supportController.etSupport.value,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 20, vertical: 10),
                              border: InputBorder.none,
                              counterText:
                                  "${supportController.etSupportLength.value}/250",
                            ),
                            maxLines: 7,
                            maxLength: 250,
                            cursorColor: ConstColor.blackcodeTextButtonColor,
                            onChanged: (val) {
                              supportController.etSupportLength.value =
                                  supportController.etSupport.value.text.length;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsetsDirectional.symmetric(
                            horizontal: 30),
                        child: Row(
                          children: [
                            Obx(
                              () => Text(
                                supportController.fileName.value == ""
                                    ? AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_upload_pic_doc
                                    : supportController.fileName.value,
                                style: black10Normal500,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                openCamerGallertPopUp();
                              },
                              child: Container(
                                alignment: AlignmentDirectional.center,
                                decoration: BoxDecoration(
                                    color: ConstColor.codeLogoYellow,
                                    // gradient: const LinearGradient(
                                    //   begin: AlignmentDirectional.topEnd,
                                    //   end: AlignmentDirectional.bottomStart,
                                    //   colors: [
                                    //     ConstColor.codeFieldColor,
                                    //     ConstColor.codeFieldColor,
                                    //   ],
                                    // ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: ConstColor.codeFieldColor,
                                        width: 0.5)),
                                height: 30,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                          child: Image.asset(
                                        AppConstents.uploadIcon,
                                        height: 25,
                                        width: 25,
                                        color: ConstColor.codeFieldTextColor,
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        child: Text(
                                          AppLocalizations.of(
                                                  Get.key.currentContext!)!
                                              .txt_upload,
                                          style: const TextStyle(
                                              color:
                                                  ConstColor.codeFieldTextColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ]),

                                // Padding(
                                //   padding:
                                //       const EdgeInsetsDirectional.symmetric(
                                //           horizontal: 26),
                                //   child: Text(
                                //     AppLocalizations.of(
                                //             Get.key.currentContext!)!
                                //         .txt_upload,
                                //     style: uploadButtonTitleStyle,
                                //   ),
                                // )
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsetsDirectional.symmetric(
                            horizontal: 30),
                        height: 1,
                        color: ConstColor.codeFieldColor,
                      ),
                      const SizedBox(height: 80),
                      CommonButton(
                          width: 180,
                          onPressed: () {
                            supportController.isLoading.value = true;
                            doValidate();
                          },
                          title: AppLocalizations.of(Get.key.currentContext!)!
                              .txt_submit)
                    ],
                  ),
                ),
              ))),
        ));
  }

  openCamerGallertPopUp() {
    showCupertinoModalPopup<void>(
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
              supportController.getFtyeImage(ImageSource.camera);
            },
            child: Text(
              AppLocalizations.of(Get.key.currentContext!)!.txt_camera,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              supportController.getFtyeImage(ImageSource.gallery);
            },
            child: Text(
              AppLocalizations.of(Get.key.currentContext!)!.txt_gallery,
            ),
          ),
        ],
      ),
    );
  }

  doValidate() async {
    String errorMessage = supportController.doValidate();

    if (errorMessage.toString().isNotEmpty) {
      showFlutterToast(message: errorMessage);
      supportController.isLoading.value = false;
    } else {
      Helper.verifyInternet().then((intenet) async {
        // ignore: unnecessary_null_comparison
        if (intenet != null && intenet) {
          await supportController.requestSendQueries().then((value) {
            print(" support...  ");
          });
        } else {
          Helper.createSnackBar(context);
        }
      });
    }
  }
}

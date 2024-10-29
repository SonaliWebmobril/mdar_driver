// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/const_color.dart';
import '../../../utils/toast.dart';
import '../../auth_design/custom_widget/commonbutton.dart';
import '../../auth_design/custom_widget/formfield_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BankInformatoinScreen extends StatefulWidget {
  static String routeName = "BankInformatoinScreen";
  const BankInformatoinScreen({Key? key}) : super(key: key);

  @override
  State<BankInformatoinScreen> createState() => _BankInformatoinScreenState();
}

class _BankInformatoinScreenState extends State<BankInformatoinScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.blackcodeTextButtonColor,
      appBar: ReusableWidgets.getAppBar(
          AppLocalizations.of(Get.key.currentContext!)!.txt_bank_info),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const SizedBox(height: 20),
            EditProfileAllInputDesing(
              controller: nameController,
              keyBoardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              hintText:
                  AppLocalizations.of(Get.key.currentContext!)!.txt_holder_name,
              maxlength: 25,
            ),
            const SizedBox(height: 15),
            EditProfileAllInputDesing(
              controller: accountNumberController,
              keyBoardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              hintText: AppLocalizations.of(Get.key.currentContext!)!
                  .txt_account_number,
              maxlength: 17,
            ),
            const SizedBox(height: 15),
            EditProfileAllInputDesing(
              controller: ifscController,
              keyBoardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              hintText:
                  AppLocalizations.of(Get.key.currentContext!)!.txt_ifsc_code,
              maxlength: 40,
            ),
            const SizedBox(height: 15),
            EditProfileAllInputDesing(
              controller: bankNameController,
              keyBoardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              hintText:
                  AppLocalizations.of(Get.key.currentContext!)!.txt_bank_name,
              maxlength: 17,
            ),
            const SizedBox(height: 80),
            CommonButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Get.back();
              },
              title: AppLocalizations.of(Get.key.currentContext!)!.txt_done,
            ),
          ],
        ),
      )),
    );
  }
}

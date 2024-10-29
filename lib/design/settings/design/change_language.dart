import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:madr_driver/utils/StringExtension.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/style.dart';
import 'package:madr_driver/design/settings/controller/languageController.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/const_color.dart';
import '../../../utils/user_session.dart';

class ChangeLanguage extends StatefulWidget {
  static String routeName = "ChangeLanguage";
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<ChangeLanguage> {
  LanguageController languageController = Get.put(LanguageController());

  @override
  void initState() {
    log("in setting init..   ${UserSession.getLngIndex(UserSession.keyLocalIndex)}");
    UserSession.isCurrentLoading = languageController.isLoading;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstColor.accentColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(Get.key.currentContext!)!
                .txt_change_lng
                .toTitleCase(),
            style: buttonBlackTitleStyle,
          ),
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
        body: SafeArea(child: Obx(() {
          return Stack(
            children: [
              Container(
                // color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: ConstColor.accentColor,
                      border: Border.all(color: ConstColor.accentColor),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0))),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  selected: index ==
                                      (UserSession.getLngIndex(
                                          UserSession.keyLocalIndex)),
                                  onTap: () {
                                    print(
                                        "languageController.isLoading.value..  " +
                                            languageController.isLoading.value
                                                .toString());
                                    if (languageController.isLoading.value ==
                                        false) {
                                      languageController.isLoading.value = true;
                                      languageController
                                          .getUpdateLanguageApi(index);
                                    }
                                  },
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: index ==
                                                ((UserSession.getLngIndex(
                                                    UserSession.keyLocalIndex)))
                                            ? const LinearGradient(
                                                begin:
                                                    AlignmentDirectional.topEnd,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  ConstColor.blackColor,
                                                  ConstColor.blackColor,
                                                ],
                                              )
                                            : const LinearGradient(colors: [
                                                Colors.transparent,
                                                Colors.transparent,
                                              ])),
                                    child: Icon(
                                      Icons.check,
                                      size: 24,
                                      color: index ==
                                              (UserSession.getLngIndex(
                                                  UserSession.keyLocalIndex))
                                          ? ConstColor.accentColor
                                          : Colors.transparent,
                                    ),
                                  ),
                                  leading: Image.asset(
                                    AppConstents().languageList[index]['icon'],
                                    width: 24,
                                    height: 24,
                                  ),
                                  title: Text(
                                    AppConstents().languageList[index]['name'],
                                    style: black16Bold600,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  color: ConstColor.codeFieldColor,
                                );
                              },
                              itemCount: AppConstents().languageList.length),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              languageController.isLoading.value == true
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      color: Color.fromARGB(20, 167, 166, 166),
                      child: const CircularProgressIndicator(
                        color: ConstColor.codeFieldColor,
                      ))
                  : Container()
            ],
          );
        })));
  }
}

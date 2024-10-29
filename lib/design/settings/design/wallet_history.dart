import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/design/settings/model/wallet_model.dart';
import 'package:get/get.dart';
import 'package:madr_driver/utils/user_session.dart';
import '../../../utils/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../controller/wallet_controller.dart';
import 'my_trip/wallet_item_view.dart';

class WalletHistory extends StatefulWidget {
  static String routeName = "WalletHistory";
  const WalletHistory({super.key});

  @override
  State<WalletHistory> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletHistory> {
  var walletController = Get.put(WalletController());
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    walletController.page.value = 1;
    walletController.getHistoryList();
    UserSession.isCurrentLoading = walletController.isLoading;
    // scrollController = ScrollController();
    // scrollController.addListener(() {
    //   if (walletController.isHistoryLoading.value == false) {
    //     if (scrollController.position.maxScrollExtent ==
    //         scrollController.offset) {
    //       print("scheduleRideScrollController.....  ");
    //       walletController.page = walletController.page + 1;
    //       walletController.getList();
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.accentColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppConstents().Wallet,
          style: buttonBlackTitleStyle,
        ),
        elevation: 0,
        backgroundColor: ConstColor.accentColor,
        leading: IconButton(
            onPressed: () {
              log("message");
              log(Get.currentRoute);
              // Get.back();
              Get.back(canPop: true);
            },
            icon: Image.asset(
              AppConstents.arrowBack,
              color: ConstColor.blackColor,
              height: 20,
              width: 20,
            )),
      ),
      // body:
      body: Container(child: tripWidget()),
    );
  }

  Widget tripWidget() {
    return
        // Obx(() =>
        // SingleChildScrollView(
        //     controller: scrollController,
        //     child:
        FutureBuilder<List<Data>>(
            future: walletController.fecthTripList(),
            builder: (context, AsyncSnapshot<List<Data>> snapshot) {
              log(" trip list ...  ${snapshot.data}");
              return Obx(() => walletController.isHistoryLoading.value == true
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: ConstColor.codeBackgroundColor,
                    ))
                  : snapshot.data != null && snapshot.data!.isNotEmpty
                      ? WalletItemView(snapshot.data!)
                      : walletController.page == 1
                          ? Center(
                              child: Text(
                                  AppLocalizations.of(Get.key.currentContext!)!
                                      .txt_no_data_found,
                                  style: black14Bold600),
                            )
                          : Container());
            });
  }
}

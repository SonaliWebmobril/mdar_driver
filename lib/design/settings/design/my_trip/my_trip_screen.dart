import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:madr_driver/utils/StringExtension.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/design/settings/design/my_trip/trip_item_view.dart';
import 'package:get/get.dart';
import 'package:madr_driver/utils/user_session.dart';
import '../../../../utils/style.dart';
import '../../controller/my_trip_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/my_trip_response_model.dart';

class MyTripScreen extends StatefulWidget {
  static String routeName = "MyTripScreen";

  const MyTripScreen({super.key});

  @override
  State<MyTripScreen> createState() => _MyTripScreenState();
}

class _MyTripScreenState extends State<MyTripScreen> {
  var myTripeControllerInstance = Get.put(MyTripController());

  @override
  void initState() {
    super.initState();
    myTripeControllerInstance.page.value = 1;
    myTripeControllerInstance.tripType.value = 0;
    myTripeControllerInstance.tripList.clear();
    myTripeControllerInstance.isLoading.value = true;
    myTripeControllerInstance.getTripList();
    UserSession.isCurrentLoading = myTripeControllerInstance.isLoading;
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<MyTripController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstColor.accentColor,
        appBar: AppBar(
          elevation: 0,
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
          centerTitle: true,
          title: Text(
            AppConstents().txtMyRides.toTitleCase(),
            style: buttonBlackTitleStyle,
          ),
          backgroundColor: ConstColor.accentColor,
        ),
        // body:
        body: Column(
          children: [
            Expanded(
              child: tripWidget(),
            ),
            const SizedBox(height: 10),
          ],
        ));
  }

  Widget tripWidget() {
    return FutureBuilder<List<BookingList>>(
      future: myTripeControllerInstance.fecthTripList(),
      builder: (context, AsyncSnapshot<List<BookingList>> snapshot) {
        log(" trip list ...  ${snapshot.data}");
        return Obx(
          () => myTripeControllerInstance.isLoading.value == true
              ? const Center(
                  child: CircularProgressIndicator(
                      color: ConstColor.codeFieldColor))
              : snapshot.data != null && snapshot.data!.isNotEmpty
                  ? TripItemView(snapshot.data!)
                  : Center(
                      child: Text(
                        AppLocalizations.of(Get.key.currentContext!)!
                            .txt_no_data_found,
                        style:
                            const TextStyle(color: ConstColor.codeFieldColor),
                      ),
                    ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:madr_driver/utils/user_session.dart';

import '../../../../utils/const_color.dart';
import '../../../../utils/app_constents.dart';
import '../../../../utils/style.dart';
import '../../../../utils/time_rule.dart';
import '../../controller/wallet_controller.dart';
import '../../model/my_trip_response_model.dart';
import '../../model/wallet_model.dart';

class WalletItemView extends StatefulWidget {
  List<Data> data = [];

  WalletItemView(this.data, {super.key});

  @override
  State<WalletItemView> createState() => WalletItemState(data);
}

class WalletItemState extends State<WalletItemView> {
  List<Data> data;
  var walletController = Get.put(WalletController());

  late ScrollController scrollController;

  WalletItemState(this.data);

  @override
  void initState() {
    super.initState();
    UserSession.isCurrentLoading = walletController.isLoading;
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (walletController.isHistoryLoading.value == false) {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          print("scheduleRideScrollController.....  ");
          walletController.page = walletController.page + 1;
          walletController.getHistoryList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        child: SingleChildScrollView(
            controller: scrollController,
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {},
                      child: Container(
                          // padding: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsetsDirectional.only(
                              start: 20, top: 12, bottom: 12, end: 20),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Container(
                                        // padding: EdgeInsetsDirectional.only(
                                        //     start: 10, top: 12, bottom: 12,),
                                        child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            padding: const EdgeInsetsDirectional
                                                .only(start: 10, end: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(Get
                                                          .key.currentContext!)!
                                                      .txt_total_amt,
                                                  style: black14Normal500,
                                                ),
                                                Container(
                                                  width: 8,
                                                  height: 2,
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 20),
                                                  color: Colors.white,
                                                ),
                                              ],
                                            )),
                                        Container(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 5, end: 10),
                                          child: Text(
                                            UserSession.getStringFromSession(
                                                        UserSession
                                                            .currencyPosition) ==
                                                    "0"
                                                ? "${UserSession.getStringFromSession(UserSession.currencySymbol)} ${data[index].amount}"
                                                : "${data[index].amount} ${UserSession.getStringFromSession(UserSession.currencySymbol)}",
                                            style: black14Normal500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            padding: const EdgeInsetsDirectional
                                                .only(start: 10, end: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppConstents().RequestMode,
                                                  style: formHeadingStyle,
                                                ),
                                                Container(
                                                  width: 8,
                                                  height: 2,
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 15),
                                                  color: Colors.white,
                                                ),
                                              ],
                                            )),
                                        Container(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 5, end: 10),
                                          child: Text(
                                            "${AppLocalizations.of(Get.key.currentContext!)!.txt_by} ${data[index].requestType}",
                                            style: black14Normal500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            padding: const EdgeInsetsDirectional
                                                .only(start: 10, end: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppConstents().RequestDate,
                                                  style: black14Normal500,
                                                ),
                                                Container(
                                                  width: 8,
                                                  height: 2,
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 22),
                                                  color: Colors.white,
                                                ),
                                              ],
                                            )),
                                        Container(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 5, end: 10),
                                          child: Text(
                                            TimeRues().margedDateTime(
                                                data[index]
                                                    .createdAt
                                                    .toString()),
                                            style: black14Normal500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(start: 10, end: 5),
                                              child: Text(
                                                AppConstents().RequestStatus,
                                                style: black14Normal500,
                                              ),
                                            ),
                                            Container(
                                              width: 8,
                                              height: 2,
                                              margin:
                                                  const EdgeInsetsDirectional
                                                      .only(start: 5),
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        manageStatus(index),
                                      ],
                                    ),
                                  ],
                                ))),
                              ])));
                },
                separatorBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 2,
                    color: ConstColor.blackColor,
                  );
                },
                itemCount: data.length)));
  }

  String dateTime(BookingList data) {
    final dateUS = DateTime.parse(data.scheduledDate.toString()).toLocal();
    var date = DateFormat.yMMMMd().format(dateUS);
    print("date time...   $date");
    return "$date ${data.scheduledTime}";
  }

  manageStatus(int index) {
    if (data[index].status == "1") {
      return Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
        //width: MediaQuery.of(context).size.width,
        child: Text(
          AppLocalizations.of(Get.key.currentContext!)!.txt_complete,
          style: successTextStyle,
        ),
      );
    } else if (data[index].status == "0") {
      return Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
        // width: MediaQuery.of(context).size.width,
        child: Text(
          AppConstents().RequestPending,
          style: PendingTextStyle,
        ),
      );
    } else if (data[index].status == "-1") {
      return Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
        // width: MediaQuery.of(context).size.width * 0.25,
        child: Text(
          AppConstents().RequestDecline,
          style: declineTextStyle,
        ),
      );
    }
  }
}

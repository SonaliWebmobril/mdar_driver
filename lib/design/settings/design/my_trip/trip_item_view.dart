import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:madr_driver/utils/user_session.dart';

import '../../../../utils/const_color.dart';
import '../../../../utils/app_constents.dart';
import '../../../../utils/style.dart';
import '../../../../utils/time_rule.dart';
import '../../../../utils/toast.dart';
import '../../controller/my_trip_controller.dart';
import '../../model/my_trip_response_model.dart';

class TripItemView extends StatefulWidget {
  List<BookingList> data = [];

  TripItemView(this.data, {super.key});

  @override
  State<TripItemView> createState() => TripItemState(data);
}

class TripItemState extends State<TripItemView> {
  List<BookingList> data;
  MyTripController myTripeControllerInstance = Get.put(MyTripController());

  late ScrollController scrollController;

  TripItemState(this.data);

  @override
  void initState() {
    super.initState();
    UserSession.isCurrentLoading = myTripeControllerInstance.isLoading;
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (myTripeControllerInstance.isLoading.value == false) {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          myTripeControllerInstance.page = myTripeControllerInstance.page + 1;
          myTripeControllerInstance.getTripList();
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
                  debugPrint("DAHKBD ${data[index].dropAddress}");
                  return InkWell(
                    onTap: () {
                      Helper.verifyInternet().then((intenet) {
                        // ignore: unnecessary_null_comparison
                        if (intenet != null && intenet) {
                          Get.toNamed("MyTripDetailsScreen",
                              arguments: data[index].sId);
                        } else {
                          Helper.createSnackBar(context);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsetsDirectional.only(
                          start: 10, top: 12, bottom: 12, end: 4),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 20),
                                        child: Text(
                                          myTripeControllerInstance
                                                      .tripType.value ==
                                                  0
                                              ? TimeRues().margedDateTime(
                                                  data[index]
                                                      .createdAt
                                                      .toString())
                                              : data[index].scheduledDate ==
                                                      null
                                                  ? ""
                                                  : dateTime(data[index]),
                                          style: black12Normal500,
                                        ),
                                      ),
                                      Text(
                                        data[index].currencyPosition == "0"
                                            ? "${AppLocalizations.of(Get.key.currentContext!)!.txt_price} ${data[index].currencySymbol} ${double.parse(data[index].totalPrice ?? "0").toStringAsFixed(2)}"
                                            : "${AppLocalizations.of(Get.key.currentContext!)!.txt_price} ${double.parse(data[index].totalPrice ?? "0").toStringAsFixed(2)} ${data[index].currencySymbol}",
                                        style: black14Bold600,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (data[index].rideType == "2" ||
                                                data[index].rideType == "3")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 23, bottom: 5),
                                                child: Text(
                                                    AppConstents()
                                                        .txtRentalRide,
                                                    style: black14Normal500),
                                              ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  AppConstents
                                                      .pickupLocationIcon,
                                                  height: 14,
                                                  width: 14,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      data[index]
                                                          .pickupAddress
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: black14Normal500),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            if (data[index].dropAddress !=
                                                    null &&
                                                data[index].dropAddress != "")
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      AppConstents
                                                          .dropoffLocationIcon,
                                                      height: 14,
                                                      width: 14,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          data[index]
                                                              .dropAddress
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style:
                                                              black14Normal500),
                                                    ),
                                                  ]),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              data[index].paymentMode == ""
                                                  ? const SizedBox.shrink()
                                                  : Text(
                                                      "${AppLocalizations.of(Get.key.currentContext!)!.txt_by} ${data[index].paymentMode}",
                                                      style: black12Normal500,
                                                    ),
                                              data[index].paymentMode == ""
                                                  ? const SizedBox.shrink()
                                                  : const SizedBox(height: 10),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                // mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  data[index].paymentMode == ""
                                                      ? Container(height: 10)
                                                      : SizedBox(
                                                          height: 25,
                                                          child: RatingBar
                                                              .builder(
                                                                  ignoreGestures:
                                                                      true,
                                                                  initialRating: double
                                                                      .parse(data[
                                                                              index]
                                                                          .rating
                                                                          .toString()),
                                                                  minRating: 1,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  allowHalfRating:
                                                                      true,
                                                                  itemCount: 5,
                                                                  itemSize: 16,
                                                                  unratedColor:
                                                                      Colors
                                                                          .white,
                                                                  itemPadding:
                                                                      const EdgeInsetsDirectional
                                                                          .symmetric(
                                                                          horizontal:
                                                                              0.5),
                                                                  itemBuilder:
                                                                      (context,
                                                                              _) =>
                                                                          const Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                Colors.amber,
                                                                          ),
                                                                  onRatingUpdate:
                                                                      (value) {}),
                                                        ),
                                                  manageStatus(index),
                                                ],
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(() => myTripeControllerInstance
                                                  .tripType.value ==
                                              0
                                          ? Container()
                                          : data[index].isCancelSelected == true
                                              ? data[index].rideStatus == 1
                                                  ? myTripeControllerInstance
                                                              .isStartLoading
                                                              .value ==
                                                          true
                                                      ? Container(
                                                          width: 140,
                                                          alignment:
                                                              Alignment.center,
                                                          margin: const EdgeInsetsDirectional.only(
                                                              end: 10,
                                                              top: 12,
                                                              bottom: 5),
                                                          padding:
                                                              const EdgeInsetsDirectional.only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  start: 4,
                                                                  end: 4),
                                                          child:
                                                              const CircularProgressIndicator(
                                                            color: Colors.white,
                                                          ))
                                                      : InkWell(
                                                          onTap: () {
                                                            myTripeControllerInstance
                                                                .isStartLoading
                                                                .value = true;
                                                            myTripeControllerInstance
                                                                .actionOnCurrentBooking(
                                                                    data[index]
                                                                        .sId
                                                                        .toString(),
                                                                    "1");
                                                          },
                                                          child: Container(
                                                              width: 140,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(16),
                                                                  color: Colors.white),
                                                              margin: const EdgeInsetsDirectional.only(end: 10, top: 12, bottom: 5),
                                                              padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10, start: 4, end: 4),
                                                              alignment: Alignment.center,
                                                              child: Text(AppLocalizations.of(Get.key.currentContext!)!.txt_start_ride, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ConstColor.greyButtonTextColor))))
                                                  : Container()
                                              : Container()),
                                      Obx(
                                        () => myTripeControllerInstance
                                                    .tripType.value ==
                                                0
                                            ? Container()
                                            : data[index].isCancelSelected ==
                                                    true
                                                ? myTripeControllerInstance
                                                            .isCancelLoading
                                                            .value ==
                                                        true
                                                    ? Container(
                                                        width: 140,
                                                        alignment: Alignment
                                                            .center,
                                                        margin:
                                                            const EdgeInsetsDirectional
                                                                .only(
                                                                end: 10,
                                                                top: 12,
                                                                bottom: 5),
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .only(
                                                                top: 10,
                                                                bottom: 10,
                                                                start: 4,
                                                                end: 4),
                                                        child:
                                                            const CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ))
                                                    : InkWell(
                                                        onTap: () {
                                                          myTripeControllerInstance
                                                              .isCancelLoading
                                                              .value = true;
                                                          myTripeControllerInstance
                                                              .cancelRide(
                                                                  data[index]
                                                                      .sId
                                                                      .toString(),
                                                                  index);
                                                        },
                                                        child: Container(
                                                          width: 140,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              color:
                                                                  Colors.white),
                                                          margin:
                                                              const EdgeInsetsDirectional
                                                                  .only(
                                                                  start: 10,
                                                                  top: 12,
                                                                  bottom: 5),
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  start: 4,
                                                                  end: 4),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            AppConstents()
                                                                .CancelRide,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: ConstColor
                                                                    .greyButtonTextColor),
                                                          ),
                                                        ),
                                                      )
                                                : Container(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            myTripeControllerInstance.tripType.value == 0
                                ? Container(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 8, top: 8, bottom: 8, end: 4),
                                  )
                                : (data[index].status == 6 ||
                                        data[index].status == -2)
                                    ? InkWell(
                                        onTap: () {
                                          if (data[index].isCancelSelected ==
                                              true) {
                                            data[index].isCancelSelected =
                                                (false);
                                          } else {
                                            data[index].isCancelSelected =
                                                (true);
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                            margin: const EdgeInsetsDirectional
                                                .only(start: 6, top: 10),
                                            child: const Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                            )),
                                      )
                                    : Container(
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                start: 24, top: 10),
                                      ),
                          ]),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 1,
                    color: ConstColor.codeFieldColor,
                  );
                },
                itemCount: data.length)));
  }

  String dateTime(BookingList data) {
    final dateUS = DateTime.parse(data.scheduledDate.toString()).toLocal();
    var date = DateFormat('MMMM dd, yyyy HH:mm').format(dateUS);
    return date;
  }

  manageStatus(int index) {
    if (data[index].status == 4) {
      return Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            color: ConstColor.rideCompleted,
            borderRadius: BorderRadius.circular(15)),
        height: 27,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Text(
          AppLocalizations.of(Get.key.currentContext!)!.txt_complete,
          style: tripDetailTextStyle,
        ),
      );
    } else if (data[index].status == 6) {
      return Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            color: ConstColor.rideCompleted,
            borderRadius: BorderRadius.circular(15)),
        height: 27,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Text(
          AppConstents().Accepted,
          style: tripDetailTextStyle,
        ),
      );
    } else if (data[index].status == 3) {
      return Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            color: ConstColor.rideCompleted,
            borderRadius: BorderRadius.circular(15)),
        height: 27,
        width: MediaQuery.of(context).size.width * 0.30,
        child: Text(
          AppConstents().PaymentPending,
          textAlign: TextAlign.center,
          style: tripDetailTextStyle,
        ),
      );
    } else if (data[index].status == -2) {
      return Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(15)),
        height: 27,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Text(
          AppConstents().RidePending,
          style: tripDetailTextStyle,
        ),
      );
    } else if (data[index].status == -1) {
      return Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(15)),
        height: 27,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Text(
          AppLocalizations.of(Get.key.currentContext!)!.txt_cancelled,
          style: tripDetailTextStyle,
        ),
      );
    } else if (data[index].status == 1 || data[index].status == 2) {
      return Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(15)),
        height: 27,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Text(
          AppConstents().txtInProgress,
          style: tripDetailTextStyle,
        ),
      );
    } else {
      return Text(
        "",
        style: tripDetailTextStyle,
      );
    }
  }

  payMode(int index) {
    if (data[index].paymentMode == "Cash") {
      return AppLocalizations.of(Get.key.currentContext!)!.txt_cash;
    } else if (data[index].paymentMode == "Online") {
      return AppLocalizations.of(Get.key.currentContext!)!.txt_online;
    } else if (data[index].paymentMode == "Mpesa") {
      return AppConstents().txtMpesa;
    }
  }
}

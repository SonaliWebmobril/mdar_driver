import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:madr_driver/utils/user_session.dart';
import '../../../../utils/const_color.dart';
import '../../../../utils/app_constents.dart';
import '../../../../utils/style.dart';
import '../../../../utils/time_rule.dart';
import '../../../auth_design/custom_widget/commonbutton.dart';
import '../../../dashboard/design/map_widget/PointLatLng.dart';
import '../../../dashboard/design/map_widget/PolylinePoints.dart';
import '../../../dashboard/design/map_widget/PolylineResult.dart';
import '../../controller/my_trip_details_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTripDetailsScreen extends StatefulWidget {
  static String routeName = "MyTripDetailsScreen";

  const MyTripDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MyTripDetailsScreen> createState() => _MyTripDetailsScreenState();
}

class _MyTripDetailsScreenState extends State<MyTripDetailsScreen> {
  var controllerManager = Get.put(MyTripDetailsController());

  Set<Marker> markers = <Marker>{};
  Set<Polyline> polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;
  GoogleMapController? googleMapController;
  Completer<GoogleMapController> mapController = Completer();
  var id = "";
  BitmapDescriptor? pickupMarkerIcon;
  BitmapDescriptor? dropOffMarkerIcon;

  @override
  void initState() {
    controllerManager.isloading.value = true;
    id = Get.arguments;
    Get.log(id.toString());

    controllerManager.getDetailsRequest(id).then((value) {
      if (value != null) {
        if (controllerManager.tripDetail.value!.dropLocation != null) {
          polylinePoints = PolylinePoints();
          setPolylines();
        }
      }
    });

    UserSession.isCurrentLoading = controllerManager.isloading;
    super.initState();
  }

  void setPickupDropoffMarkerIcons() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(15, 15)),
            AppConstents.pickupLocationIcon)
        .then((onValue) {
      pickupMarkerIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(15, 15)),
            AppConstents.dropoffLocationIcon)
        .then((onValue) {
      dropOffMarkerIcon = onValue;
    });
    setState(() {});
  }

  setPolylines() async {
    setPickupDropoffMarkerIcons();

    var data = PointLatLng(
        controllerManager.tripDetail.value!.pickupLocation!.coordinates![1],
        controllerManager.tripDetail.value!.pickupLocation!.coordinates![0]);

    var data1 = PointLatLng(
        controllerManager.tripDetail.value!.dropLocation!.coordinates![1],
        controllerManager.tripDetail.value!.dropLocation!.coordinates![0]);

    try {
      PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
          AppConstents.googleApiKey, data, data1, data1);

      if (result.status == 'OK') {
        for (var point in result.points) {
          print("result. points");
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        polylines.add(Polyline(
            visible: true,
            width: 2,
            polylineId: const PolylineId('polyLine'),
            color: ConstColor.bluecodeTextButtonColor,
            points: polylineCoordinates));
      }
      Future.delayed(Duration(seconds: 1), () {
        controllerManager.isloading.value = false;
      });
      print("mounted..  polyline..  " +
          mounted.toString() +
          "   " +
          Get.currentRoute.toString());
      if (mounted == true) {
        setState(() {});
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }

  Widget googleMapWidgetSetLines() {
    Marker? dropMarker;
    try {
      dropMarker = Marker(
        markerId: const MarkerId('drop location'),
        position: LatLng(
          controllerManager.tripDetail.value!.dropLocation!.coordinates![1],
          controllerManager.tripDetail.value!.dropLocation!.coordinates![0],
        ),
        icon: dropOffMarkerIcon != null
            ? dropOffMarkerIcon!
            : BitmapDescriptor.defaultMarker,
      );
    } catch (_) {}
    return Expanded(
        child: (Get.currentRoute == "MyTripDetailsScreen")
            ? GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                // compassEnabled: true,
                tiltGesturesEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      controllerManager
                          .tripDetail.value!.pickupLocation!.coordinates![1],
                      controllerManager
                          .tripDetail.value!.pickupLocation!.coordinates![0]),
                  zoom: 14,
                ),
                polylines: polylines,

                markers: {
                  Marker(
                    markerId: const MarkerId('pickup location'),
                    position: LatLng(
                        controllerManager
                            .tripDetail.value!.pickupLocation!.coordinates![1],
                        controllerManager
                            .tripDetail.value!.pickupLocation!.coordinates![0]),
                    icon: pickupMarkerIcon != null
                        ? pickupMarkerIcon!
                        : BitmapDescriptor.defaultMarkerWithHue(80),
                  ),
                  if (dropMarker != null) dropMarker
                },
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                },
              )
            : Container());
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose mounted  " + Get.currentRoute.toString());
    // _disposeController();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await mapController.future;
    controller.dispose();
    polylines.clear();
    Get.delete<MyTripDetailsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProgressHUD(
          inAsyncCall: controllerManager.isloading.value,
          // child: SingleChildScrollView(
          child: WillPopScope(
            onWillPop: () async {
              if (controllerManager.isloading.value == true) {
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
                backgroundColor: ConstColor.accentColor,
                appBar: ReusableWidgets.getAppBar(AppConstents().txtRideDetail),
                body: controllerManager.tripDetail.value != null
                    ? Column(
                        children: [
                          googleMapWidgetSetLines(),
                          Container(
                            // alignment: Alignment.bottomCenter,
                            decoration: const BoxDecoration(
                              color: ConstColor.accentColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0)),
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 20),
                                  Align(
                                      alignment: AlignmentDirectional.center,
                                      child: Text(
                                          controllerManager.tripDetail.value!
                                                      .currencyPosition ==
                                                  "0"
                                              ? "${(controllerManager.tripDetail.value!.currencySymbol)} ${(double.parse(controllerManager.tripDetail.value!.totalPrice.toString()).toStringAsFixed(2).toString())}"
                                              : "${(double.parse(controllerManager.tripDetail.value!.totalPrice.toString()).toStringAsFixed(2).toString())} ${(controllerManager.tripDetail.value!.currencySymbol)}",
                                          style: black46Normal500)),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: AlignmentDirectional.center,
                                    child: Text(
                                      AppLocalizations.of(
                                              Get.key.currentContext!)!
                                          .txt_total_amt,
                                      style: black18Normal500,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    margin:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 20),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "${AppLocalizations.of(Get.key.currentContext!)!.txt_date} - ${controllerManager.tripDetail.value != null ? TimeRues().convetDateTime(controllerManager.tripDetail.value!.updatedAt.toString()) : ''}",
                                              style: black12Normal500,
                                            ),
                                            //const Spacer(),
                                            // Text(
                                            //   "#fhrubn347938y",
                                            //   style: tripDetailTextStyle,
                                            // ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Align(
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          child: SizedBox(
                                            height: 27,
                                            child: manageStatus(
                                                controllerManager
                                                    .tripDetail.value!.status!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                      margin:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 20),
                                      child: pickupDropoffRow(
                                          AppConstents.pickupLocationIcon,
                                          controllerManager.tripDetail.value !=
                                                  null
                                              ? controllerManager.tripDetail
                                                  .value!.pickupAddress
                                                  .toString()
                                              : "",
                                          2,
                                          black10Normal500)),
                                  const SizedBox(height: 6),
                                  if (controllerManager
                                              .tripDetail.value!.dropAddress !=
                                          null &&
                                      controllerManager
                                              .tripDetail.value!.dropAddress !=
                                          "")
                                    Container(
                                        margin: const EdgeInsetsDirectional
                                            .symmetric(horizontal: 20),
                                        child: pickupDropoffRow(
                                            AppConstents.dropoffLocationIcon,
                                            controllerManager
                                                        .tripDetail.value !=
                                                    null
                                                ? controllerManager.tripDetail
                                                    .value!.dropAddress
                                                    .toString()
                                                : "",
                                            2,
                                            black10Normal500)),
                                  const SizedBox(height: 12),
                                  const SizedBox(height: 10),
                                  controllerManager.tripDetail.value!.rating !=
                                          "0"
                                      ? Container(
                                          margin: const EdgeInsetsDirectional
                                              .symmetric(horizontal: 15),
                                          height: 2,
                                          color: ConstColor.blackColor,
                                        )
                                      : const SizedBox(),
                                  controllerManager.tripDetail.value!.rating !=
                                          "0"
                                      ? Container(
                                          margin: const EdgeInsetsDirectional
                                              .symmetric(
                                              horizontal: 25, vertical: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  child: Text(
                                                AppConstents().txtRating,
                                                style: black14Normal400,
                                              )),
                                              Container(
                                                alignment: AlignmentDirectional
                                                    .centerStart,
                                                child: RatingBar.builder(
                                                  itemSize: 18,
                                                  ignoreGestures: true,
                                                  initialRating: double.parse(
                                                      controllerManager
                                                          .tripDetail
                                                          .value!
                                                          .rating
                                                          .toString()),
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  unratedColor: Colors.white,
                                                  itemBuilder: (context, _) =>
                                                      const Icon(
                                                    Icons.star,
                                                    size: 10,
                                                    color: ConstColor
                                                        .ratingStarColor,
                                                  ),
                                                  onRatingUpdate:
                                                      (double value) {},
                                                ),
                                              )
                                            ],
                                          ))
                                      : const SizedBox.shrink(),
                                  controllerManager.tripDetail.value!
                                          .discription!.isNotEmpty
                                      ? Container(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          margin: const EdgeInsetsDirectional
                                              .symmetric(
                                              horizontal: 25, vertical: 15),
                                          child: Text(
                                            controllerManager
                                                .tripDetail.value!.discription
                                                .toString(),
                                            style: black12Normal500,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  // const SizedBox(height: 15),
                                  // controllerManager.tripDetail.value!.rating !=
                                  //         "0"
                                  //     ? Container(
                                  //         margin: const EdgeInsetsDirectional
                                  //             .symmetric(horizontal: 15),
                                  //         height: 2,
                                  //         color: ConstColor.diividerColor,
                                  //       )
                                  //     : const SizedBox.shrink(),
                                  const SizedBox(height: 5),
                                ]),
                          )
                        ],
                      )
                    : Container()),
          )),
    );
  }

  manageStatus(int status) {
    if (status == 4) {
      return Text(
        AppLocalizations.of(Get.key.currentContext!)!.txt_complete,
        style: successTextStyle,
      );
    } else if (status == 6) {
      return Text(
        AppConstents().Accepted,
        style: successTextStyle,
      );
    } else if (status == 3) {
      return Text(
        AppConstents().PaymentPending,
        style: successTextStyle,
      );
    } else if (status == -2) {
      return Text(
        AppConstents().RidePending,
        style: declineTextStyle,
      );
    } else if (status == -1) {
      return Text(
        AppLocalizations.of(Get.key.currentContext!)!.txt_cancelled,
        style: declineTextStyle,
      );
    } else if (status == 1 || status == 2) {
      return Text(
        AppConstents().txtInProgress,
        style: successTextStyle,
      );
    } else {
      return Text(
        "",
        style: tripDetailTextStyle,
      );
    }
  }
}

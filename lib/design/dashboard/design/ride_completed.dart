import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:madr_driver/services/api_sevices.dart';
import 'package:madr_driver/utils/toast.dart';
import '../../../utils/const_color.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/style.dart';
import '../../../utils/user_session.dart';
import '../../auth_design/custom_widget/commonbutton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RideCompletedScreen extends StatefulWidget {
  static String routeName = "RideCompletedScreen";
  const RideCompletedScreen({Key? key}) : super(key: key);

  @override
  State<RideCompletedScreen> createState() => _RideCompletedScreenState();
}

class _RideCompletedScreenState extends State<RideCompletedScreen> {
  // var appMapController = Get.find<AppMapController>();
  BitmapDescriptor? icons;
  late var rideCompleteData;
  double ratingCont = 0.5;
  TextEditingController discriptionController = TextEditingController();
  FocusNode focusNode = FocusNode();
  NetworkServices networkServices = NetworkServices();
  var isLoading = true;
  RxBool rated = false.obs;

  @override
  void initState() {
    super.initState();
    rideCompleteData = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMyDialog();
    });
  }

  Future<void> _showMyDialog() async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      isDismissible: false, // user must tap button to close the dialog
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
                child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: ConstColor.accentColor),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        child: Text(
                          AppConstents().txtRating,
                          style: white18Bold700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RatingBar.builder(
                        initialRating: 0.5,
                        minRating: 0.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        unratedColor: ConstColor.codeFieldColor,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 3.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            ratingCont = rating;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ConstColor.accentColor,
                          border: Border.all(
                            color: ConstColor.codeFieldTextColor,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        child: TextField(
                          controller: discriptionController,
                          style: white16Bold700,
                          textAlign: TextAlign.start,
                          cursorColor: ConstColor.codeFieldTextColor,
                          cursorHeight: 18,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: focusNode.hasFocus == true
                                ? ""
                                : AppConstents().txtWriteReview,
                            hintStyle: white16Bold700,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            border: InputBorder.none,
                            counterText: "",
                          ),
                          maxLines: 4,
                          maxLength: 250,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CommonButton(
                          width: 200,
                          onPressed: () {
                            doRating();
                          },
                          color: ConstColor.codeTextButtonColor,
                          txtStyle: fieldText15Normal400,
                          title: AppLocalizations.of(Get.key.currentContext!)!
                              .txt_submit),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      alignment: AlignmentDirectional.topEnd,
                      transform: Matrix4.translationValues(-2.0, -10.0, 0.0),
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.black,
                      ),
                    ))
              ],
            )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.accentColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 65,
        centerTitle: true,
        title: Text(
          AppConstents().RideCompleted.toUpperCase(),
          style: black16Bold600,
        ),
        actions: [
          Obx(() => rated.value == true
              ? Container()
              : InkWell(
                  onTap: () {
                    _showMyDialog();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: ConstColor.codeFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsetsDirectional.all(8),
                      margin: EdgeInsetsDirectional.all(16),
                      child: Text(
                        AppConstents().txtRateUser,
                        style: fieldText15Normal400,
                      ))))
        ],
        elevation: 0,
        backgroundColor: ConstColor.accentColor,
        leading: IconButton(
            onPressed: () {
              handleNavigation();
            },
            icon: Image.asset(
              AppConstents.arrowBack,
              color: ConstColor.codeFieldTextColor,
              height: 20,
              width: 20,
            )),
      ),
      body: SafeArea(
        child: rideCompleteData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Image.asset(
                      AppConstents.completeIcon,
                      height: 88,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 25),
                    Text(AppConstents().yourRideCompleted.toUpperCase(),
                        style: completedRidestyle),
                    const SizedBox(height: 15),
                    Container(
                      margin:
                          const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      height: 2,
                      color: ConstColor.codeFieldColor,
                    ),
                    const SizedBox(height: 15),
                    ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: rideCompleteData['profile_pic'].toString() != '0'
                            ? Image.network(
                                AppConstents.baseUrl +
                                    rideCompleteData['profile_pic'],
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/userErrImg.png",
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                      ),
                      title: Text(
                        "${rideCompleteData['name']}",
                        style: black16Bold600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 20,
                      ),
                      height: 2,
                      color: ConstColor.codeFieldColor,
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.symmetric(
                          horizontal: 25, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(Get.key.currentContext!)!
                                .txt_payment_by,
                            style: black16Bold600,
                          ),
                          Text(
                            "${rideCompleteData['payment_mode']}",
                            style: black16Bold600,
                          ),
                        ],
                      ),
                    ),
                    rideCompleteData['payment_mode'] == "Online"
                        ? Container(
                            margin: const EdgeInsetsDirectional.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(Get.key.currentContext!)!
                                      .txt_transaction_id,
                                  style: black16Bold600,
                                ),
                                Text(
                                  "${rideCompleteData['transaction_id']}",
                                  style: black16Bold600,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 5),
                    Container(
                      margin: const EdgeInsetsDirectional.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(Get.key.currentContext!)!
                                .txt_type_of_service,
                            style: black16Bold600,
                          ),
                          Text(
                            "${rideCompleteData['taxi_type']}",
                            style: black16Bold600,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsetsDirectional.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(Get.key.currentContext!)!
                                .txt_total_km,
                            style: black16Bold600,
                          ),
                          Text(
                            double.parse(rideCompleteData['km'])
                                .toStringAsFixed(2),
                            style: black16Bold600,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsetsDirectional.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(Get.key.currentContext!)!
                                .txt_total_price,
                            style: black16Bold600,
                          ),
                          Text(
                            UserSession.getStringFromSession(
                                        UserSession.currencyPosition) ==
                                    "0"
                                ? "${UserSession.getStringFromSession(UserSession.currencySymbol)} ${double.parse(rideCompleteData['total_price']).toStringAsFixed(2)}"
                                : " ${double.parse(rideCompleteData['total_price']).toStringAsFixed(2)} ${UserSession.getStringFromSession(UserSession.currencySymbol)}",
                            style: black16Bold600,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsetsDirectional.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(Get.key.currentContext!)!
                                .txt_duration,
                            style: black16Bold600,
                          ),
                          Text(
                            "${rideCompleteData['time']}",
                            style: black16Bold600,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Container(
                        alignment: AlignmentDirectional.center,
                        padding: EdgeInsetsDirectional.only(top: 5, bottom: 5),
                        child: CommonButton(
                          width: 200,
                          onPressed: () {
                            handleNavigation();
                          },
                          title: AppLocalizations.of(Get.key.currentContext!)!
                              .txt_done,
                        ))
                  ],
                ),
              ),
      ),
    );
  }

  void handleNavigation() async {
    // await appMapController.onRejectLead();
    Get.offAllNamed("HomeScreen");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> doRating() async {
    try {
      print("rideCompleteData  .  " + rideCompleteData.toString());
      var response = await networkServices.rateUser({
        "rating": ratingCont,
        "discription": discriptionController.text,
        "booking_id": rideCompleteData['_id']
      });
      // Map<String, dynamic> jsonData = json.decode(response);

      print("jsonData.   " + response.toString());
      if (response['ResponseCode'] == 200) {
        if (rated.value == false) {
          showFlutterToast(message: response['ResponseMessage'].toString());
          rated.value = true;
          Get.back();
        } else {
          showFlutterToast(message: response['ResponseMessage'].toString());
        }
      }
    } catch (e) {
      // showFlutterToast(message: e.toString());
      print("termsConditionApi..   $e");
    }
  }
}

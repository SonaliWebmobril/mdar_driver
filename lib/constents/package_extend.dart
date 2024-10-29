import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/design/dashboard/controller/accept_ride_controller.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/style.dart';

import '../utils/app_constents.dart';

class PackageExtend extends StatefulWidget {
  final bool isKm;

  const PackageExtend({super.key, required this.isKm});

  @override
  State<PackageExtend> createState() => _PackageExtendState();
}

class _PackageExtendState extends State<PackageExtend> {
  var acceptController = Get.find<AcceptRideController>();
  late Timer timer;
  ValueNotifier<int> inSeconds = ValueNotifier(0);

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      inSeconds.value = inSeconds.value + 1;
      if (mounted && inSeconds.value == 60) {
        acceptController.completedBooking();
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ConstColor.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        padding:
            const EdgeInsetsDirectional.symmetric(vertical: 40, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConstents().txtPackageComplete,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: ConstColor.textColor,
              ),
            ),
            const SizedBox(height: 22),
            InkWell(
              onTap: () {
                acceptController.completedBooking();
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
              child: Container(
                height: 50,
                alignment: AlignmentDirectional.center,
                padding: const EdgeInsetsDirectional.only(
                    start: 10, end: 10, top: 10, bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: AlignmentDirectional.topEnd,
                    end: AlignmentDirectional.bottomStart,
                    colors: [
                      ConstColor.blueSecondaryColor,
                      ConstColor.bluecodeTextButtonColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppConstents().txtCompleteRide,
                  style: buttonTitleStyle,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<int>(
                valueListenable: inSeconds,
                builder: (context, snapShot, child) {
                  return Container(
                    alignment: AlignmentDirectional.center,
                    padding: const EdgeInsetsDirectional.only(
                        start: 10, end: 10, top: 10, bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ConstColor.appBgFirstColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppConstents().txtWaitForResp,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: ConstColor.bluecodeTextButtonColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "(${AppConstents().txtRideCompleteIn} 00:${!(60 - snapShot).isNegative ? (60 - snapShot) >= 10 ? (60 - snapShot) : "0${(60 - snapShot)}" : "00"})",
                          style: const TextStyle(
                            color: ConstColor.bluecodeTextButtonColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

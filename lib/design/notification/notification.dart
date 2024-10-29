import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/utils/const_color.dart';
import '../../utils/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = "NotificationScreen";
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstColor.blackcodeTextButtonColor,
        appBar: ReusableWidgets.getAppBar(
            AppLocalizations.of(Get.key.currentContext!)!.txt_notification),
        // CoomonAppbar(onPressed: () {}, title: "Notifications"),
        // ignore: prefer_const_constructors
        body: SafeArea(
            child: Center(
          child: Text(
              AppLocalizations.of(Get.key.currentContext!)!.txt_no_data_found,
              style: TextStyle(color: ConstColor.accentColor)),
        )
            // ListView.separated(
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       leading: ClipRRect(
            //         borderRadius: BorderRadius.circular(40),
            //         child: Image.asset(
            //           "assets/images/userimageN.png",
            //           height: 40,
            //           width: 50,
            //         ),
            //       ),
            //       title: Text(
            //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.",
            //         style: notificationTextStyle,
            //       ),
            //       subtitle: Padding(
            //         padding: const EdgeInsetsDirectional.only(top: 5),
            //         child: Text(
            //           "9:20 AM",
            //           style: notificationTextStyle,
            //         ),
            //       ),
            //     );
            //   },
            //   itemCount: 10,
            //   separatorBuilder: (context, index) {
            //     return const Padding(
            //       padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
            //       child: Divider(
            //         height: 10,
            //         thickness: 1.5,
            //         color: ConstColor.diividerColor,
            //       ),
            //     );
            //   },
            // ),
            ));
  }
}

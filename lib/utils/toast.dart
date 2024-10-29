// ignore_for_file: prefer_typing_uninitialized_variables, unused_field
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:madr_driver/services/api_sevices.dart';
import 'package:madr_driver/utils/StringExtension.dart';
import 'package:madr_driver/socket_connection/socket_connection.dart';
import 'package:madr_driver/utils/user_session.dart';
import 'const_color.dart';
import 'app_constents.dart';
import 'style.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showFlutterToast(
    {required String message, Color? backgroundColor, textColor}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: backgroundColor,
    textColor: textColor,
  );
}

class Helper {
  static Future<bool> verifyInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print("connectivityResult.. " + connectivityResult.toString());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      return true;
    }
    return false;
  }

  static createSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: ConstColor.codeBackgroundColor,
      content: Row(
        children: [
          const Icon(
            Icons.wifi_off_outlined,
            color: ConstColor.codeFieldColor,
          ),
          Text(AppLocalizations.of(Get.key.currentContext!)!.txt_check_internet,
              style: const TextStyle(
                  color: ConstColor.codeFieldTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    ));
  }
}

class ReusableWidgets {
  static getAppBar(String title) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title.toTitleCase(),
        style: buttonBlackTitleStyle,
      ),
      elevation: 0,
      backgroundColor: ConstColor.accentColor,
      leading: IconButton(
          onPressed: () {
            Get.back(canPop: true);
          },
          icon: Image.asset(
            AppConstents.arrowBack,
            color: ConstColor.blackColor,
            height: 20,
            width: 20,
          )),
    );
  }
}

Widget commonDivider() {
  return Container(
    height: 1,
    width: double.maxFinite,
    color: ConstColor.codeFieldColor,
  );
}

class ResponseData {
  int? code;
  String? json;

  ResponseData({required this.code, required this.json, body});
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  final animationType;

  SlideRightRoute({required this.page, required this.animationType})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              animationType == "ScaleTransition"
                  ? ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                      child: child,
                    )
                  : animationType == "SlideTransition"
                      ? SlideTransition(
                          position: Tween<Offset>(
                            end: Offset.zero,
                            begin: const Offset(1.0, 0.0),
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.linear,
                            ),
                          ),
                          child: child,
                        )
                      : animationType == "RotationTransition"
                          ? RotationTransition(
                              turns: Tween<double>(
                                begin: 0.0,
                                end: 1.0,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.linear,
                                ),
                              ),
                              child: child,
                            )
                          : animationType == "FadeTransition"
                              ? FadeTransition(
                                  opacity: animation,
                                  child: child,
                                )
                              : Align(
                                  child: SizeTransition(
                                    sizeFactor: animation,
                                    child: child,
                                  ),
                                ),
          transitionDuration: const Duration(milliseconds: 400),
        );
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget widget;
  SlideLeftRoute({required this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });
}

class ComoonAletButton extends StatefulWidget {
  final String title;
  final int height;

  final int width;
  final Function() onPressed;
  const ComoonAletButton(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.height,
      required this.width});

  @override
  State<ComoonAletButton> createState() => _ComoonAletButtonState();
}

class _ComoonAletButtonState extends State<ComoonAletButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: AlignmentDirectional.topEnd,
              end: AlignmentDirectional.bottomStart,
              colors: [
                ConstColor.codeBackgroundColor,
                ConstColor.codeBackgroundColor,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          height: double.parse(widget.height.toString()),
          width: double.parse(widget.width.toString()),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
            child: Text(
              widget.title,
              style: uploadButtonTitleStyle,
            ),
          )),
    );
  }
}

class AlertDialogDelete extends StatefulWidget {
  AlertDialogDelete({super.key});

  @override
  State<AlertDialogDelete> createState() => _AlertDialogDeleteState();
}

class _AlertDialogDeleteState extends State<AlertDialogDelete> {
  NetworkServices networkServices = NetworkServices();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstColor.accentColor,
      // backgroundColor: const Color.fromARGB(255, 66, 65, 65),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        AppConstents().txtDelete,
        style: const TextStyle(
            color: ConstColor.codeFieldTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppConstents().txtAreYouSureToDelete,
              style: const TextStyle(
                  color: ConstColor.codeFieldTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ComoonAletButton(
                title: AppLocalizations.of(Get.key.currentContext!)!.txt_no,
                onPressed: () {
                  Get.back();
                },
                height: 30,
                width: 80,
              ),
              ComoonAletButton(
                title: AppLocalizations.of(Get.key.currentContext!)!.txt_yes,
                onPressed: () async {
                  print("delete yes..  ");
                  try {
                    var response = await networkServices.deleteApi();
                    if (response['ResponseCode'] == 200) {
                      await UserSession.clearSession();
                      SocketConnection.socket?.disconnect();
                      SocketConnection.socket?.dispose();
                      Get.offNamedUntil("LoginScreen", (route) => false);
                    } else {
                      showFlutterToast(
                          message: response['ResponseMessage'].toString());
                    }
                  } catch (e) {
                    // showFlutterToast(message: e.toString());
                    print("termsConditionApi..   $e");
                  }
                },
                height: 30,
                width: 80,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AlertDialogLogut extends StatefulWidget {
  const AlertDialogLogut({super.key});

  @override
  State<AlertDialogLogut> createState() => _AlertDialogLogutState();
}

class _AlertDialogLogutState extends State<AlertDialogLogut> {
  NetworkServices networkServices = NetworkServices();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstColor.accentColor,
      // backgroundColor: const Color.fromARGB(255, 66, 65, 65),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        AppLocalizations.of(Get.key.currentContext!)!.txt_logout,
        style: const TextStyle(
            color: ConstColor.codeFieldTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppConstents().txtAreYouSureToLogout,
              style: const TextStyle(
                  color: ConstColor.codeFieldTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ComoonAletButton(
                title: AppLocalizations.of(Get.key.currentContext!)!.txt_no,
                onPressed: () {
                  Get.back();
                },
                height: 30,
                width: 80,
              ),
              ComoonAletButton(
                title: AppLocalizations.of(Get.key.currentContext!)!.txt_yes,
                onPressed: () async {
                  print("logout yes..  ");
                  try {
                    var response = await networkServices.logoutApi();
                    if (response['ResponseCode'] == 200) {
                      await UserSession.clearSession();
                      SocketConnection.socket?.disconnect();
                      SocketConnection.socket?.dispose();
                      Get.offNamedUntil("LoginScreen", (route) => false);
                    } else {
                      showFlutterToast(
                          message: response['ResponseMessage'].toString());
                    }
                  } catch (e) {
                    // showFlutterToast(message: e.toString());
                    print("termsConditionApi..   $e");
                  }

                  // await UserSession.clearSession();
                  // SocketConnection.socket?.disconnect();
                  // SocketConnection.socket?.dispose();
                  // Get.offNamedUntil("LoginScreen", (route) => false);
                },
                height: 30,
                width: 80,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class PopupMenuCommon extends StatefulWidget {
  PopupMenuCommon({super.key});

  @override
  State<PopupMenuCommon> createState() => _PopupMenuCommonState();
}

class _PopupMenuCommonState extends State<PopupMenuCommon> {
  String _selectedMenu = '';
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        onSelected: (Menu item) {
          setState(() {
            _selectedMenu = item.name;
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              PopupMenuItem<Menu>(
                value: Menu.edit,
                child: Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_edit),
              ),
              PopupMenuItem<Menu>(
                value: Menu.delete,
                child: Text(
                    AppLocalizations.of(Get.key.currentContext!)!.txt_delete),
              ),
            ]);
  }
}

enum Menu { edit, delete }

//

class CommonUploadedWidge extends StatefulWidget {
  final String title;
  final String subTitle;
  final Function() onpressed;
  const CommonUploadedWidge(
      {required this.onpressed,
      required this.subTitle,
      required this.title,
      super.key});

  @override
  State<CommonUploadedWidge> createState() => _CommonUploadedWidgeState();
}

class _CommonUploadedWidgeState extends State<CommonUploadedWidge> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: black16Bold600,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.subTitle,
            style: manageColor(),
          ),
        ],
      ),
    );
  }

  manageColor() {
    if (widget.subTitle ==
        AppLocalizations.of(Get.key.currentContext!)!.txt_approved) {
      return successTextStyle;
    } else if (widget.subTitle ==
        AppLocalizations.of(Get.key.currentContext!)!.txt_pending) {
      return pendingTextStyle;
    } else {
      return successTextStyle;
    }
  }
}

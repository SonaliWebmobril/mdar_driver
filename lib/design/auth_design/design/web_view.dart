import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/design/controller/document_upload_controller.dart';
import 'package:madr_driver/utils/toast.dart';
import 'package:madr_driver/utils/user_session.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  static String routeName = "WebViewScreen";
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => WebViewState();
}

class WebViewState extends State<WebViewScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var controller = Get.find<DocumentUploadController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.green,
        body: WebView(
      initialUrl: Get.arguments['checkoutLink'],
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      onProgress: (int progress) {
        print('WebView is loading (progress : $progress%)');
      },
      javascriptChannels: <JavascriptChannel>{
        _toasterJavascriptChannel(),
      },
      navigationDelegate: (NavigationRequest request) {
        // if (request.url.contains("http://52.22.241.165:10008/")) {
        //   print('blocking navigation to $request}');
        //   return NavigationDecision.prevent;
        // } else {
        if (request.url.startsWith(Get.arguments['checkoutLink'])) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
        //}
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
        Future.delayed(Duration(seconds: 1), () {
          if (url.contains("http://52.22.241.165:10008/")) {
            print('Page started to $url');
            showFlutterToast(message: "Payment Done");

            var transId = url.replaceAll("http://52.22.241.165:10008/?id=", "");
            print("transId ..   " + transId.toString());
            print("current booking id..  " +
                Get.arguments['bookingId'].toString());
            controller.onlinepaymentDone = true;
            controller.securityDeposit = true;
            Map map = {
              "security_deposit": "1",
              "payment_method": "OpenPay",
              "payment_mode": "Online",
              "transection_id": transId,
              "amount":
                  UserSession.getStringFromSession(UserSession.keySecurityAmt)
            };
            controller.updateSecurityDeposit(map, "1");

            Get.back();
          }
        });
      },
      gestureNavigationEnabled: true,
      backgroundColor: const Color(0x00000000),
      onWebResourceError: (error) {
        print("webview error..  " + error.description);
      },
    ));
  }

  JavascriptChannel _toasterJavascriptChannel() {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          ScaffoldMessenger.of(Get.key.currentContext!).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

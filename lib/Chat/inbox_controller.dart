// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../socket_connection/socket_connection.dart';
import '../utils/user_session.dart';
import 'inbox_model.dart';
import '../services/api_sevices.dart';

class InboxController extends GetxController {
  NetworkServices networkServices = NetworkServices();
  RxList<ResponseBody> chatList = <ResponseBody>[].obs;
  RxString imagePath = "".obs;
  final ScrollController scrollController = ScrollController();
  var isLoading = false.obs;

  Future<List<ResponseBody>> getChatHistory() async {
    isLoading.value = true;
    chatList.clear();
    try {
      var response = await networkServices
          .getChatHistoryList(Get.arguments['booking_id'].toString());
      log("updateUserProfileImgReq response .. $response");
      log("updateUserProfileImgReq responseCode .. ${response['ResponseCode']}");
      if (response['ResponseCode'] == 200) {
        chatList.addAll(response['ResponseBody']
            .map<ResponseBody>((json) => ResponseBody.fromJson(json))
            .toList());
        isLoading.value = false;
      } else {
        log("updateUserProfileImgReq else");
        isLoading.value = false;
      }
    } catch (e) {
      log(e.toString());
      isLoading.value = false;
    }
    return chatList;
  }

  receiveMsg(data) async {
    print("recieved_message ..  ");
    print("recieved_message ..   $data");
    var localData = await json.decode(data);
    log("recieved_message ..localData  $localData");
    // inboxController.chatList.add(json
    //     .decode(data)
    //   );

    if (localData['content_type'].toString() == "text") {
      ResponseBody responseData = ResponseBody(
          senderId: localData['sender_id'].toString(),
          content: localData['content'].toString(),
          contentType: 'text',
          createdAt: localData['created_at'].toString());
      chatList.add(responseData);
    } else if (localData['content_type'] == "media") {
      ResponseBody responseData = ResponseBody(
          senderId: localData['sender_id'].toString(),
          content: localData['content'].toString(),
          contentType: 'media',
          createdAt: localData['created_at'].toString());
      chatList.add(responseData);
    }

    final position = scrollController.position.maxScrollExtent +
        scrollController.position.viewportDimension;
    scrollController.animateTo(position,
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  Future updateMedia() async {
    try {
      var response = await networkServices.updateChatmedia(imagePath.value);
      log("updateMedia response .. $response");
      log("updateMedia responseCode .. ${response['ResponseCode']}");
      if (response['ResponseCode'] == 200) {
        // socket condition change....
        // if (SocketConnection.socketId == "") {
        //   log("socket..    null " + SocketConnection.socketId.toString());
        //   SocketConnection.connectToServer();
        // }
        SocketConnection.sendMessage("send_message", {
          'booking_id': Get.arguments['booking_id'],
          'content': response['ResponseBody']['mediaUrl'],
          'content_type': 'media',
        });
        // SocketConnection.socket!.emit("send_message", {
        //   'booking_id': Get.arguments['booking_id'],
        //   'content': response['ResponseBody']['mediaUrl'],
        //   'content_type': 'media',
        // });

        log("DateTime.now().toLocal().toString()) . ..  ${DateTime.now()}");
        log("DateTime.now().toLocal().toString()) ..  ${localToUtcConvert(DateTime.now())}");

        ResponseBody responseData = ResponseBody(
            senderId:
                '${UserSession.getStringFromSession(UserSession.keyUserId)}',
            content: response['ResponseBody']['mediaUrl'],
            contentType: 'media',
            createdAt: localToUtcConvert(DateTime.now()));

        chatList.add(responseData);
        final position = scrollController.position.maxScrollExtent +
            scrollController.position.viewportDimension;
        scrollController.animateTo(position,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      } else {
        log("updateMedia else");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  String localToUtcConvert(DateTime localDateTime) {
    var dateTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(localDateTime.toString());

    log("dateTime dateTime 111   $dateTime");

    var local = dateTime.toUtc();

    var dateTimeUtc = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(local);

    log("dateTime dateTime  22  $dateTimeUtc");

    //var localDate = "${local.hour}:${local.minute}";
    // print("dateTime dateTime    " + localDate);

    return dateTimeUtc;
  }
}

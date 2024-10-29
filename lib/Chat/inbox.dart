// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../utils/toast.dart';
import '../utils/const_color.dart';
import '../utils/app_constents.dart';
import '../socket_connection/socket_connection.dart';
import '../design/settings/controller/profile_controller.dart';
import '../design/settings/design/edit_profile_screen.dart';
import '../utils/user_session.dart';
import 'inbox_controller.dart';
import 'inbox_model.dart';

class InboxScreen extends StatelessWidget {
  static String routeName = 'InboxScreen';

  const InboxScreen({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstColor.accentColor,
        appBar: ReusableWidgets.getAppBar(
            Get.arguments['other_user_name'] ?? "User"),
        body: const InboxScreenBody());
  }
}

class InboxScreenBody extends StatefulWidget {
  const InboxScreenBody({Key? key}) : super(key: key);

  @override
  State<InboxScreenBody> createState() => _InboxScreenBodyState();
}

class _InboxScreenBodyState extends State<InboxScreenBody> {
  TextEditingController msgController = TextEditingController();
  String chatId = "no";
  String imageUrl = "";
  String userImage = "";
  String otherUserImage = "";
  var inboxController = Get.put(InboxController());
  var profileController = Get.find<ProfileController>();

  @override
  void initState() {
    Get.log("-=-=-=-=>>>> ${Get.arguments}");
    inboxController.getChatHistory();
    UserSession.isCurrentLoading = inboxController.isLoading;
    // socket!.on("recieved_message", (data) async {
    //   log("recieved_message ..  ");
    //   log("recieved_message ..  " + data);
    //   var localData = await json.decode(data);
    //   log("recieved_message ..localData  " + localData.toString());
    //   // inboxController.chatList.add(json
    //   //     .decode(data)
    //   //   );

    //   if (localData['content_type'].toString() == "text") {
    //     ResponseBody responseData = ResponseBody(
    //         senderId: localData['sender_id'].toString(),
    //         content: localData['content'].toString(),
    //         contentType: 'text',
    //         createdAt: localData['created_at'].toString());
    //     inboxController.chatList.add(responseData);
    //   } else if (localData['content_type'] == "media") {
    //     ResponseBody responseData = ResponseBody(
    //         senderId: localData['sender_id'].toString(),
    //         content: localData['content'].toString(),
    //         contentType: 'media',
    //         createdAt: localData['created_at'].toString());
    //     inboxController.chatList.add(responseData);
    //   }

    //   final position =
    //       inboxController.scrollController.position.maxScrollExtent +
    //           inboxController.scrollController.position.viewportDimension;
    //   inboxController.scrollController.animateTo(position,
    //       duration: Duration(milliseconds: 100), curve: Curves.linear);
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  // late Widget _returnWidget;
  // Widget _returnChatWidget() {
  //   //  if (data is QueryDocumentSnapshot) {
  //   //     // Get.log("-=-=-data['idFrom'] ${data['idFrom']}");
  //   //     _returnWidget = data['idFrom'] == widget.otherUserId
  //   //         ? peerUserListTile(context, data['content'], data['type'])
  //   //         : mineListTile(context, data['content'],
  //   //             returnTimeStamp(data['timestamp']), data['type']);
  //   //   } else if (data is String) {
  //   //     _returnWidget = stringListTile(data);
  //   //   }
  //   _returnWidget =
  //       peerUserListTile(context, "Hi, Lorem Ipsum ha sido el texto  ", "text");
  //   mineListTile(context, "Hello, ha sido el texto ",
  //       returnTimeStamp(1662113929), "text");
  //   return _returnWidget;
  // }

  Widget stringListTile(String data) {
    Widget returnWidget;

    returnWidget = Padding(
      padding: const EdgeInsetsDirectional.all(2.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: Colors.grey[300]),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 6),
            child: Text(
              data,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ),
        ),
      ),
    );

    return returnWidget;
  }

  // Widget messagesBuilder() {
  //   return FutureBuilder(
  //       future: ,
  //       builder: (context, snapshot) {
  //         return snapshot.data != null
  //             ? messagesListview(snapshot.data as List<ResponseBody>)
  //             : Center(child: CircularProgressIndicator());
  //       });
  // }

  messagesListview() {
    return Obx(
      () => Stack(children: [
        inboxController.isLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                reverse: false,
                controller: inboxController.scrollController,
                itemCount: inboxController.chatList.length,
                itemBuilder: (BuildContext context, int index) {
                  // children: [

                  //   ...List.generate(inboxController.chatList.length, (index) {
                  return Column(
                    children: [
                      ListItemCalling(inboxController.chatList[index])
                    ],
                  );
                })
      ]),
    );
  }

  ListItemCalling(ResponseBody data) {
    log("user id.. " +
        "${UserSession.getStringFromSession(UserSession.keyUserId)}" +
        " . " +
        data.senderId.toString());
    if (data.senderId ==
        "${UserSession.getStringFromSession(UserSession.keyUserId)}") {
      return mineListTile(
          context,
          data.content.toString(),
          UTCToLocalConvert(data.createdAt.toString()),
          data.contentType.toString(),
          UserSession.getStringFromSession(UserSession.keyUserProfile)
              .toString());
    } else {
      return peerUserListTile(
          context,
          data.content.toString(),
          UTCToLocalConvert(data.createdAt.toString()),
          data.contentType.toString(),
          data.profilePic.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: messagesListview()),
          const SizedBox(
            height: 10,
          ),
          _buildTextComposer(),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  String returnTimeStamp(int messageTimeStamp) {
    String resultString = '';
    var format = DateFormat('hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
    resultString = format.format(date);
    return resultString;
  }

  String UTCToLocalConvert(String createdAt) {
    var dateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(createdAt, true);
    var local = dateTime.toLocal();
    log("dateTime UTCToLocalConvert    $local");

    var localDate = "${local.hour}:${local.minute}";
    log("dateTime UTCToLocalConvert    $localDate");

    return localDate;
  }

  Widget peerUserListTile(BuildContext context, String message, String time,
      String type, String profile) {
    final size = MediaQuery.of(context).size;
    print("-===-=-message $message" + " .  " + profile);
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 4.0),
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child:
                          (profile == "0" || profile == "null" || profile == "")
                              ? const Icon(
                                  Icons.account_circle_sharp,
                                  color: ConstColor.codeFieldColor,
                                )
                              : Image.network(AppConstents.baseUrl + profile,
                                  fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 8),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: size.width - size.width * 0.40),
                        decoration: BoxDecoration(
                          color: type == 'text'
                              ? ConstColor.codeFieldColor
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                              type == 'text' ? 10.0 : 0),
                          child: Container(
                              child: type == 'text'
                                  ? Text(
                                      message,
                                      style: const TextStyle(
                                          color: ConstColor.codeBackgroundColor),
                                    )
                                  : imageMessage(context, message)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          bottom: 14.0, start: 4, end: 8),
                      child: Text(
                        time,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mineListTile(BuildContext context, String message, String time,
      String type, String profile) {
    final size = MediaQuery.of(context).size;

    Get.log("-=-=userImage $profile");
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 2.0, end: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 4, 4),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: size.width - size.width * 0.40),
                      decoration: const BoxDecoration(
                        color: ConstColor.codeFieldColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(
                            type == 'text' ? 10.0 : 0),
                        child: Container(
                            child: type == 'text'
                                ? Text(
                                    message,
                                    style: const TextStyle(
                                        color: ConstColor.codeBackgroundColor),
                                  )
                                : imageMessage(context, message)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        bottom: 14.0, end: 4, start: 8),
                    child: Text(
                      time,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.all(5.0),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child:
                          (profile == "0" || profile == "null" || profile == "")
                              ? const Icon(
                                  Icons.account_circle_sharp,
                                  color: ConstColor.codeFieldColor,
                                )
                              : Image.network(
                                  profile,
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ConstColor.accentColor,
              borderRadius: BorderRadius.circular(35.0),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.photo_library,
                    color: ConstColor.codeFieldColor,
                  ),
                  onPressed: () {
                    // Platform.isIOS
                    //     ? showCupertinoModalPopup<void>(
                    //         context: context,
                    //         builder: (BuildContext context) =>
                    //             CupertinoActionSheet(
                    //           cancelButton: CupertinoActionSheetAction(
                    //             onPressed: () {
                    //               Navigator.pop(context);
                    //             },
                    //             child: const Text(
                    //               'Cancel',
                    //               style: TextStyle(color: Colors.red),
                    //             ),
                    //           ),
                    //           actions: <CupertinoActionSheetAction>[
                    //             CupertinoActionSheetAction(
                    //               onPressed: () {
                    //                 getFtyeImage(ImageSource.camera);
                    //               },
                    //               child: const Text(
                    //                 'Camera',
                    //               ),
                    //             ),
                    //             CupertinoActionSheetAction(
                    //               onPressed: () {
                    //                 getFtyeImage(ImageSource.gallery);
                    //               },
                    //               child: const Text('Gallery'),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     :
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return SafeArea(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                    leading: const Icon(Icons.photo),
                                    title: Text(AppLocalizations.of(
                                            Get.key.currentContext!)!
                                        .txt_gallery),
                                    onTap: () {
                                      getFtyeImage(ImageSource.gallery);
                                    }),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: Text(AppLocalizations.of(
                                          Get.key.currentContext!)!
                                      .txt_camera),
                                  onTap: () {
                                    getFtyeImage(ImageSource.camera);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 10),
                          hintText:
                              AppLocalizations.of(Get.key.currentContext!)!
                                  .txt_your_msg,
                          hintStyle:
                              const TextStyle(color: ConstColor.codeFieldColor),
                          fillColor: const Color(0xffff5f5f5),
                          filled: true,
                          // border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: ConstColor.codeFieldColor, width: 0.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: ConstColor.codeFieldColor, width: 0.2),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: ConstColor.codeFieldColor,
                                  width: 0.2))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          onTap: () {
            if (msgController.text.trim() == '') {
              showFlutterToast(
                  message: AppLocalizations.of(Get.key.currentContext!)!
                      .val_enter_message);
            } else {
              // socket condition change..
              // if (SocketConnection.socketId == "") {
              //   log("socket..    null " + SocketConnection.socketId.toString());
              //   SocketConnection.connectToServer();
              // }
              SocketConnection.sendMessage("send_message", {
                'booking_id': Get.arguments['booking_id'],
                'content': msgController.text,
                'content_type': 'text',
              });
              // SocketConnection.socket!.emit("send_message", {
              //   'booking_id': Get.arguments['booking_id'],
              //   'content': msgController.text,
              //   'content_type': 'text',
              // });

              log("DateTime.now().toLocal().toString()) . ..  ${DateTime.now()}");
              log("DateTime.now().toLocal().toString()) ..  ${inboxController.localToUtcConvert(DateTime.now())}");

              ResponseBody responseData = ResponseBody(
                senderId:
                    "${UserSession.getStringFromSession(UserSession.keyUserId)}",
                content: msgController.text,
                contentType: 'text',
                createdAt: inboxController.localToUtcConvert(DateTime.now()),
                profilePic: UserSession.getStringFromSession(
                    UserSession.keyUserProfile),
              );

              inboxController.chatList.add(responseData);
              msgController.text = '';
              final position = inboxController
                      .scrollController.position.maxScrollExtent +
                  inboxController.scrollController.position.viewportDimension;
              inboxController.scrollController.animateTo(position,
                  duration: Duration(milliseconds: 100), curve: Curves.linear);
            }
          },
          child: Image.asset(
            "assets/images/send.png",
            width: 35,
            height: 35,
          ),
        )
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black38,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  getFtyeImage(type) async {
    try {
      if (type == ImageSource.camera) {
        PermissionStatus permissionStatus = await Permission.camera.status;
        log("permissionStatus.. 11 " + permissionStatus.toString());
        if (permissionStatus.isLimited ||
            permissionStatus.isPermanentlyDenied ||
            permissionStatus.isRestricted) {
          log("permissionStatus.. denied ");
          Get.back();
          showFlutterToast(message: AppConstents().cameraSettingPermission);

          // showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (BuildContext context) => AlertDialog(
          //         title: Text(AppLocalizations.of(Get.key.currentContext!)!
          //             .txt_camera_permission),
          //         content: Container(
          //             color: Colors.white,
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Container(
          //                     child: Text(
          //                   AppLocalizations.of(Get.key.currentContext!)!
          //                       .txt_permission_camera,
          //                   style: TextStyle(
          //                       fontSize: 16, fontWeight: FontWeight.w400),
          //                 )),
          //                 InkWell(
          //                   onTap: () {
          //                     Get.back();
          //                     FocusManager.instance.primaryFocus?.unfocus();
          //                     Permission.camera.request();
          //                   },
          //                   child: Container(
          //                       decoration: linearColorDecoration,
          //                       margin: const EdgeInsetsDirectional.only(
          //                           top: 15, bottom: 10),
          //                       padding: const EdgeInsetsDirectional.only(
          //                           start: 55, end: 55, top: 8, bottom: 8),
          //                       child: Text(
          //                           AppLocalizations.of(
          //                                   Get.key.currentContext!)!
          //                               .txt_retry,
          //                           style: TextStyle(
          //                               fontSize: 16,
          //                               fontWeight: FontWeight.w600,
          //                               color: Colors.white))),
          //                 ),
          //                 InkWell(
          //                     onTap: () {
          //                       Get.back();
          //                       FocusManager.instance.primaryFocus?.unfocus();
          //                     },
          //                     child: Container(
          //                       child: Text(
          //                           AppLocalizations.of(
          //                                   Get.key.currentContext!)!
          //                               .txt_im_sure,
          //                           style: TextStyle(
          //                             fontSize: 14,
          //                             fontWeight: FontWeight.w600,
          //                           )),
          //                     ))
          //               ],
          //             ))));
        } else if (permissionStatus.isGranted) {
          log(type.toString());
          Get.back();
          FocusManager.instance.primaryFocus?.unfocus();
          ImageController.instance.cropImageFromFile(type).then((value) {
            log(value!.path.toString());
            inboxController.imagePath.value = value.path;
            inboxController.updateMedia();
          });
        } else if (permissionStatus.isDenied) {
          Get.back();
          FocusManager.instance.primaryFocus?.unfocus();
          var data = await Permission.camera.request();
          if (data == PermissionStatus.granted) {
            ImageController.instance.cropImageFromFile(type).then((value) {
              log(value!.path.toString());
              inboxController.imagePath.value = value.path;
              inboxController.updateMedia();
            });
          } else {
            showFlutterToast(message: AppConstents().cameraSettingPermission);
          }
        }
      } else if (type == ImageSource.gallery) {
        if (Platform.isIOS || Platform.isAndroid) {
          Get.back();
          ImageController.instance.cropImageFromFile(type).then((value) {
            log(value!.path.toString());
            inboxController.imagePath.value = value.path;
            inboxController.updateMedia();
          });
        } else {
          Get.back();
          PermissionStatus permissionStatus =
              await Permission.storage.request();
          log("permissionStatus..222  " + permissionStatus.toString());
          if (permissionStatus.isLimited ||
              permissionStatus.isDenied ||
              permissionStatus.isRestricted) {
            Get.back();
            FocusManager.instance.primaryFocus?.unfocus();
            showFlutterToast(message: AppConstents().cameraSettingPermission);

            // showDialog(
            //     context: context,
            //     barrierDismissible: false,
            //     builder: (BuildContext context) => AlertDialog(
            //         title: Text(AppLocalizations.of(Get.key.currentContext!)!
            //             .txt_gallery_permission),
            //         content: Container(
            //             color: Colors.white,
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 Container(
            //                     child: Text(
            //                   AppLocalizations.of(Get.key.currentContext!)!
            //                       .txt_permision_gallery,
            //                   style: TextStyle(
            //                       fontSize: 16, fontWeight: FontWeight.w400),
            //                 )),
            //                 InkWell(
            //                   onTap: () {
            //                     Get.back();
            //                     FocusManager.instance.primaryFocus?.unfocus();
            //                     Permission.storage.request();
            //                   },
            //                   child: Container(
            //                       decoration: linearColorDecoration,
            //                       margin: const EdgeInsetsDirectional.only(
            //                           top: 15, bottom: 10),
            //                       padding: const EdgeInsetsDirectional.only(
            //                           start: 55, end: 55, top: 8, bottom: 8),
            //                       child: Text(
            //                           AppLocalizations.of(
            //                                   Get.key.currentContext!)!
            //                               .txt_retry,
            //                           style: TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w600,
            //                               color: Colors.white))),
            //                 ),
            //                 InkWell(
            //                     onTap: () {
            //                       Get.back();
            //                       FocusManager.instance.primaryFocus?.unfocus();
            //                     },
            //                     child: Container(
            //                       child: Text(
            //                           AppLocalizations.of(
            //                                   Get.key.currentContext!)!
            //                               .txt_im_sure,
            //                           style: const TextStyle(
            //                             fontSize: 14,
            //                             fontWeight: FontWeight.w600,
            //                           )),
            //                     ))
            //               ],
            //             ))));
          } else if (permissionStatus.isGranted) {
            log(type.toString());
            Get.back();
            FocusManager.instance.primaryFocus?.unfocus();
            ImageController.instance.cropImageFromFile(type).then((value) {
              log(value!.path.toString());
              inboxController.imagePath.value = value.path;
              inboxController.updateMedia();
            });
          } else if (permissionStatus.isPermanentlyDenied) {
            // openAppSettings();
            showFlutterToast(message: AppConstents().gallerySettingPermission);
          }
        }
      }
    } catch (e) {
      print("Exception - profile_picture.dart - selectImageFromGallery()" +
          e.toString());
    }
  }

  Widget imageMessage(context, imageUrlFromFB) {
    return SizedBox(
      // width: 160,
      height: 200,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PhotoViewScreen(
                        imagePath: imageUrlFromFB,
                      )),
            );
          },
          child: FadeInImage(
              fit: BoxFit.cover,
              image: NetworkImage(AppConstents.baseUrl + imageUrlFromFB),
              placeholder: NetworkImage(AppConstents.baseUrl + imageUrlFromFB),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/image/userimageN.png",
                );
              }),
        ),
      ),
    );
  }
}

class PhotoViewScreen extends StatefulWidget {
  final String imagePath;
  const PhotoViewScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.accentColor,
      appBar: ReusableWidgets.getAppBar(AppConstents().txtImage),
      body: PhotoView(
        imageProvider: NetworkImage(AppConstents.baseUrl + widget.imagePath),
      ),
    );
  }
}

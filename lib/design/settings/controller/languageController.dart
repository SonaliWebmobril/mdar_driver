import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';

import '../../../l10n/l10n.dart';
import '../../../services/api_sevices.dart';
import '../../../utils/user_session.dart';
import '../../dashboard/controller/home_controller.dart';

class LanguageController extends GetxController {
  var isLoading = false.obs;
  NetworkServices networkServices = NetworkServices();
  HomeController homeController = HomeController();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    log("disp controller");
    super.dispose();
  }

  Future<void> getUpdateLanguageApi(int index) async {
    final locale = L10n.all[index].languageCode;
    try {
      // isLoading(true);
      //await getToken();
      final response = await networkServices.updateLanguage(locale);
      if (response['ResponseCode'] == 200) {
        print("local and index local..   $locale   $index");
        UserSession.setLng(UserSession.keyLocalLng, locale);
        UserSession.setLngIndex(UserSession.keyLocalIndex, index);
        print("  selected local..   $locale");

        Get.updateLocale(Locale(locale));
       await homeController.BookingStatusThroughFirebase(isLoading.value);
        //Future.delayed(Duration(seconds: ))
        isLoading.value = false;
      } else {
        isLoading(false);
      }
    } catch (e) {
      isLoading(false);
      log(e.toString());
    }
  }
}

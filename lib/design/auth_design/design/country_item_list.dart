import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/design/auth_design/auth_model/country_model.dart';
import 'package:madr_driver/design/controller/auth_controller.dart';
import 'package:madr_driver/design/controller/country_controller.dart';

import '../../../utils/app_constents.dart';

class CountryItemList extends StatefulWidget {
  ListData data;

  CountryItemList(this.data, {super.key});

  @override
  State<CountryItemList> createState() => CountryItemState(data);
}

class CountryItemState extends State<CountryItemList> {
  ListData data;
  var countryController = Get.put(CountryController());
  var authController = Get.find<AuthController>();

  late ScrollController scrollController;

  CountryItemState(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 10),
        child: InkWell(
            onTap: () {
              authController.phoneCodeController.text =
                  data.dialingCode.toString();
              authController.selectedCountryCode.value = data.iso2.toString();
              authController.selectedCountryFlag.value =
                  "${AppConstents.baseUrl}Uploads/flags/${data.iso2!.toLowerCase()}.png";
              Get.back();
            },
            child: Row(
              children: [
                Container(
                  child: CachedNetworkImage(
                    width: 30,
                    height: 40,
                    imageUrl: AppConstents.baseUrl +
                        "Uploads/flags/${data.iso2!.toLowerCase()}.png",
                    //placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Container(
                    margin: const EdgeInsetsDirectional.only(start: 17),
                    child: Text(
                      data.name.toString(),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ))
              ],
            )));
  }
}

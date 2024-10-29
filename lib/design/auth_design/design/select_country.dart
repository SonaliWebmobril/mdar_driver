import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madr_driver/design/auth_design/design/country_item_list.dart';
import 'package:madr_driver/design/controller/country_controller.dart';
import 'package:madr_driver/utils/app_constents.dart';
import 'package:madr_driver/utils/const_color.dart';

class SelectCountry extends StatefulWidget {
  static String routeName = "SelectCountry";
  const SelectCountry({Key? key}) : super(key: key);

  @override
  State<SelectCountry> createState() => _CountrySelectionState();
}

class _CountrySelectionState extends State<SelectCountry> {
  var countryController = Get.put(CountryController());

  @override
  void initState() {
    super.initState();
    countryController.isLoading.value = true;
    countryController.currentList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProgressHUD(
        inAsyncCall: countryController.isLoading.value,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ConstColor.bluecodeTextButtonColor,
            title: Text(AppConstents().txtPickCountry),
          ),
          body: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsetsDirectional.only(bottom: 5, top: 5),
              child: ListView.builder(
                  shrinkWrap: true,
                  reverse: false,
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: countryController.scrollController,
                  itemCount: countryController.countryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CountryItemList(
                        countryController.countryList[index]);
                  })),
        ),
      ),
    );
  }
}

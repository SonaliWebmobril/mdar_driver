import 'package:get/get.dart';

import 'app_constents.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppValidation {}

extension EamailValidation on AppValidation {
  String firstNameValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_first_name;
    } else if (value.length < 3) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_first_name_short;
    }

    return "";
  }

  String lastNameValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_last_name;
    } else if (value.length < 3) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_last_name_short;
    }

    return "";
  }

  String userIdOrEmialIdValodator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!
          .val_enter_userid_email;
    } else if (value.length < 3) {
      return AppLocalizations.of(Get.key.currentContext!)!
          .val_userid_email_short;
    }

    return "";
  }

  String userIdValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_userid;
    } else if (value.length < 3) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_atleast_3char;
    }

    return "";
  }

  String emailValidator(String value) {
    final RegExp emailValidatorRegExp =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_email;
    } else if (!emailValidatorRegExp.hasMatch(value)) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_valid_enter;
    }

    return "";
  }

  String validateIdCard(String val) {
    final RegExp idVal = RegExp(r"(^[0-9]{12}[A-Z])$");
    if (!idVal.hasMatch(val)) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_IdCard;
    } else {
      return '';
    }
  }

  String validateDrivingLicense(String val) {
    final RegExp idVal = RegExp(r"(^[0-9]{8}/[0-9])$");
    if (!idVal.hasMatch(val)) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_driving_license;
    } else {
      return '';
    }
  }

  String AlphaNumericName(String val) {
    final RegExp idVal = RegExp(r'^[A-Za-z a-z]+$');
    if (!idVal.hasMatch(val)) {
      return "invalid";
    } else {
      return '';
    }
  }

  String nameLengthValidate(String val) {
    final RegExp idVal = RegExp(r"(^[A-Za-z]{3,20})$");
    if (!idVal.hasMatch(val)) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_name_len;
    } else {
      return '';
    }
  }

  String phoneValidator(String value) {
    print("phone valll..    " + value.length.toString());
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_mobile;
    } else if (value.length < 5) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_valid_number;
    } else if (value.length > 15) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_valid_number;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return AppLocalizations.of(Get.key.currentContext!)!.txt_valid_phone;
    }

    return "";
  }

  String AmtValidate(String value) {
    print(" AmtValidate valll..    " + value.toString());
    if (value.isEmpty) {
      return AppConstents().EnterAmt;
    } else if (value == "0") {
      return AppConstents().ValidAmt;
    } else if (!RegExp(r'^\d{0,8}(\.\d{1,4})?$').hasMatch(value)) {
      return AppConstents().ValidAmt;
    }

    return "";
  }

  String postalCodeValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!
          .val_enter_postal_code;
    } else if (value.length < 6) {
      return AppLocalizations.of(Get.key.currentContext!)!
          .val_valid_postal_code;
    }
    return "";
  }

  String landmarkValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_landmark;
    }

    return "";
  }

  String cityValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_city;
    }
    return "";
  }

  String stateValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_state;
    }
    return "";
  }

  String addressValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_address;
    }
    return "";
  }

  String passwordValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_password;
    } else if (value.length < 6) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_pass_short;
    }
    return "";
  }

  String passwordValidatorLogin(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_password;
    }
    return "";
  }

  String confirmPasswordValidator(String value, String passwordVal) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!
          .val_enter_confirm_pass;
    } else if (passwordVal != value) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_pass_not_match;
    }
    return "";
  }

  String otpCodeValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_otp;
    }

    return "";
  }

  String newPasswordValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_new_pass;
    } else if (value.length < 6) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_pass_short;
    }
    return "";
  }

  String oldPasswordValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_old_pass;
    } else if (value.length < 6) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_pass_short;
    }
    return "";
  }

  String fullNameValidator(String value) {
    //For first word capital and rest in small...
    // RegExp nameRegExp = RegExp(r'^[A-Za-z][a-z]*(?:\s[A-Za-z][a-z]*)*$');
    // Not restricted for capital and small letter..
    RegExp nameRegExp = RegExp(r'^[A-Za-z][A-Za-z]*(?:\s[A-Za-z][A-Za-z]*)*$');
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_name;
    } else if (value.length < 3) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_fullname_short;
    } else if (nameRegExp.hasMatch(value) == false) {
      return AppConstents().validName;
    }

    return "";
  }

  String messageValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!.val_enter_query;
    }

    return "";
  }

  String specificationValidator(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(Get.key.currentContext!)!
          .val_enter_specification;
    }

    return "";
  }
}

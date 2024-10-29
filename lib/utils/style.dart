import 'package:flutter/material.dart';
import 'package:madr_driver/utils/const_color.dart';
import 'package:madr_driver/utils/app_constents.dart';

TextStyle loginHeadingStyle = const TextStyle(
    fontSize: 32, color: ConstColor.accentColor, fontWeight: FontWeight.w600);

TextStyle headingStyle = const TextStyle(
    fontSize: 16,
    color: ConstColor.codeHeadingColor,
    fontWeight: FontWeight.w600);

TextStyle whiteHeadingStyle = const TextStyle(
    fontSize: 32, color: ConstColor.accentColor, fontWeight: FontWeight.w600);

TextStyle black14Normal500 = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: ConstColor.blackColor,
);
TextStyle black14Normal5001 = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: ConstColor.accentColor,
);

TextStyle black10Normal500 = const TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w500,
  color: ConstColor.blackColor,
);

TextStyle black12Normal500 = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: ConstColor.blackColor,
);

BoxDecoration blackBg = BoxDecoration(
  color: ConstColor.accentColor,
  borderRadius: BorderRadius.circular(8),
);

TextStyle loginStyle = const TextStyle(
    fontSize: 16, color: ConstColor.accentColor, fontWeight: FontWeight.w600);

TextStyle formHeadingStyle = const TextStyle(
    fontSize: 14, color: ConstColor.accentColor, fontWeight: FontWeight.w400);

TextStyle loginFormHeadingStyle = const TextStyle(
    fontSize: 14,
    color: ConstColor.accentColor,
    fontWeight: FontWeight.w400);
TextStyle loginFormHeadingStyleB = const TextStyle(
    fontSize: 14,
    color: ConstColor.codeFieldTextColor,
    fontWeight: FontWeight.w400);

TextStyle formhintStyle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: ConstColor.codeFieldColor,
);

TextStyle small500TextBlack = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ConstColor.accentColor,
    letterSpacing: 0.55);

TextStyle prductListDetailTitleStyle = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: ConstColor.codeFieldColor,
);

TextStyle largeSizeTextstyleGreen = const TextStyle(
    fontSize: 16, color: ConstColor.accentColor, fontWeight: FontWeight.w400);

TextStyle buttonTitleStyle = const TextStyle(
    color: ConstColor.codeFieldTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w600);

TextStyle mainTitleStyle = const TextStyle(
    color: ConstColor.blackColor, fontSize: 18, fontWeight: FontWeight.w600);

TextStyle black18Normal500 = const TextStyle(
    fontSize: 18, color: ConstColor.blackColor, fontWeight: FontWeight.w500);

TextStyle buttonBlackTitleStyle = const TextStyle(
    color: ConstColor.blackColor, fontSize: 18, fontWeight: FontWeight.w600);

TextStyle buttonBlackTitle = const TextStyle(
    color: ConstColor.codeFieldTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w600);

TextStyle black14Bold600 = const TextStyle(
    color: ConstColor.blackColor, fontSize: 14, fontWeight: FontWeight.w600);

TextStyle black16Bold600 = const TextStyle(
    fontSize: 16, color: ConstColor.blackColor, fontWeight: FontWeight.w600);

TextStyle black14Normal400 = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: ConstColor.accentColor,
);

TextStyle white16Normal400 = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: ConstColor.blackColor,
);

TextStyle white18Bold5001 = const TextStyle(
    fontSize: 18, color: ConstColor.accentColor, fontWeight: FontWeight.w500);
TextStyle white18Bold500 = const TextStyle(
    fontSize: 18, color: ConstColor.blackColor, fontWeight: FontWeight.w500);

TextStyle white12Normal500 = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: ConstColor.accentColor,
);

TextStyle fieldText12Normal500 = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: ConstColor.codeFieldTextColor,
);

TextStyle fieldText15Normal400 = const TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: ConstColor.codeFieldTextColor,
);

TextStyle greyButtonStyle = const TextStyle(
    color: ConstColor.greyButtonTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w600);

TextStyle uploadButtonTitleStyle = const TextStyle(
    color: ConstColor.blackColor, fontSize: 14, fontWeight: FontWeight.w600);

TextStyle homeButtonStye = const TextStyle(
    color: ConstColor.accentColor, fontSize: 17, fontWeight: FontWeight.w700);

TextStyle notmemberStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 12,
  color: ConstColor.accentColor,
);

TextStyle cancelBottomSheetTextStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: ConstColor.accentColor,
);
TextStyle cancelDialogTextStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: ConstColor.textColor,
);

TextStyle signUpTextStyle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: ConstColor.bluecodeTextButtonColor,
);

TextStyle growWhiteTextStyle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: ConstColor.rideInputColor,
);

TextStyle quantityTextStyle = const TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: ConstColor.codeFieldTextColor,
);

TextStyle quantityTextStyle1 = const TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: ConstColor.blackColor,
);

TextStyle drawerHeading = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: ConstColor.codeFieldColor,
);

BoxDecoration authBgDecoration = const BoxDecoration(
    image: DecorationImage(
  image: AssetImage(AppConstents.mapBgImg),
  fit: BoxFit.fitWidth,
));

BoxDecoration whiteBg = const BoxDecoration(
  color: ConstColor.accentColor,
  //  borderRadius: BorderRadius.all(Radius.circular(15))
);

BoxDecoration backgroundGradient = BoxDecoration(
  gradient: const LinearGradient(
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomEnd,
    colors: [
      ConstColor.appBgFirstColor,
      ConstColor.appBgSecondColor,
    ],
  ),
  borderRadius: BorderRadius.circular(15),
);

TextStyle appbarTextStyle = const TextStyle(
    color: ConstColor.accentColor,
    fontSize: 16,
    letterSpacing: 0.6,
    fontWeight: FontWeight.w600);

TextStyle notificationTextStyle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: ConstColor.accentColor,
);
TextStyle documentTextStyle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: ConstColor.accentColor,
);
TextStyle subTitleStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: ConstColor.blackColor,
);
TextStyle black46Normal500 = const TextStyle(
  fontSize: 46,
  fontWeight: FontWeight.w500,
  color: ConstColor.blackColor,
);
TextStyle drawerTextStyle = const TextStyle(
    color: ConstColor.codeFieldTextColor,
    fontSize: 15,
    letterSpacing: 0.2,
    fontWeight: FontWeight.w400);

TextStyle drawer1TextStyle = const TextStyle(
    color: ConstColor.codeFieldTextColor,
    fontSize: 15,
    letterSpacing: 0.2,
    fontWeight: FontWeight.w400);

TextStyle hintTextStyle = const TextStyle(
    color: ConstColor.codeFieldTextColor,
    fontSize: 14,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w400);

TextStyle myTipePriceStyle = const TextStyle(
    color: ConstColor.amountColor, fontSize: 14, fontWeight: FontWeight.w700);
TextStyle completedRideTstyle = const TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600, color: ConstColor.rideCompleted);

TextStyle completedRidestyle = const TextStyle(
    fontSize: 20, fontWeight: FontWeight.w700, color: ConstColor.rideComplete);
TextStyle tripDetailTextStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: ConstColor.accentColor,
);
TextStyle addressTextStryle = const TextStyle(
    color: ConstColor.textColor, fontSize: 13, fontWeight: FontWeight.w600);

TextStyle pickupDroppHeadingStyle = const TextStyle(
    fontSize: 14,
    color: ConstColor.rideInputColor,
    fontWeight: FontWeight.w400);

TextStyle MainHeadingTextStyle = const TextStyle(
    color: ConstColor.codeBackgroundColor,
    fontSize: 14,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w500);

TextStyle successTextStyle = const TextStyle(
    color: ConstColor.successGreen, fontSize: 16, fontWeight: FontWeight.w600);

TextStyle declineTextStyle = const TextStyle(
    color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600);

TextStyle PendingTextStyle = const TextStyle(
    color: Color.fromARGB(255, 219, 117, 110),
    fontSize: 16,
    fontWeight: FontWeight.w600);

TextStyle smallNormalStyle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: ConstColor.accentColor,
);

TextStyle pendingTextStyle = const TextStyle(
    color: ConstColor.codeTextButtonColor,
    fontSize: 16,
    fontWeight: FontWeight.w600);

//*********** box decoration ************/
BoxDecoration linearColorDecoration = BoxDecoration(
  gradient: const LinearGradient(
    begin: AlignmentDirectional.topEnd,
    end: AlignmentDirectional.bottomStart,
    colors: [
      ConstColor.codeTextButtonColor,
      ConstColor.codeTextButtonColor,
    ],
  ),
  borderRadius: BorderRadius.circular(15),
);
BoxDecoration borderDecoration = BoxDecoration(
    border: Border.all(color: ConstColor.codeFieldColor),
    borderRadius: BorderRadius.circular(15));

BoxDecoration withoutBorderDecoration = BoxDecoration();

TextStyle homeRatingTextStyle = const TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w700,
  color: ConstColor.accentColor,
);

TextStyle homeSheetDetailTextStyle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: ConstColor.rideInputColor,
);
BoxDecoration bottomSheetDecoration = const BoxDecoration(
    color: ConstColor.blackcodeTextButtonColor,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)));

TextStyle codeFieldColor18Bold700 = const TextStyle(
    fontSize: 18,
    color: ConstColor.codeFieldColor,
    fontWeight: FontWeight.w700);

TextStyle white18Bold700 = const TextStyle(
    fontSize: 18, color: ConstColor.codeFieldTextColor, fontWeight: FontWeight.w700);

TextStyle codeFieldColor30Bold700 = const TextStyle(
    fontSize: 30, color: ConstColor.textColor, fontWeight: FontWeight.w700);

TextStyle white30Bold700 = const TextStyle(
    fontSize: 30, color: ConstColor.accentColor, fontWeight: FontWeight.w700);

TextStyle white16Bold700 = const TextStyle(
    fontSize: 16, color: ConstColor.codeFieldTextColor, fontWeight: FontWeight.w700);

TextStyle codeFieldColor11Bold400 = const TextStyle(
    fontSize: 11,
    color: ConstColor.codeFieldColor,
    fontWeight: FontWeight.w400);

TextStyle white11Bold400 = const TextStyle(
    fontSize: 11, color: ConstColor.accentColor, fontWeight: FontWeight.w400);

TextStyle greyLight16Bold700 = const TextStyle(
    fontSize: 16,
    color: ConstColor.codeFieldColor,
    fontWeight: FontWeight.w700);

TextStyle blackLight11Bold400 = const TextStyle(
    fontSize: 11, color: ConstColor.textColor, fontWeight: FontWeight.w400);

TextStyle blackLight16Bold700 = const TextStyle(
    fontSize: 16, color: ConstColor.textColor, fontWeight: FontWeight.w700);

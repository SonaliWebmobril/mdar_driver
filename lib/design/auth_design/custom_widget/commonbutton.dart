import 'package:flutter/material.dart';
import '../../../utils/const_color.dart';
import '../../../utils/app_constents.dart';
import '../../../utils/style.dart';
import '../../../utils/user_session.dart';

class CommonButton extends StatefulWidget {
  final Function() onPressed;
  final String title;
  final double? width;
  final double? height;
  final Color? color;
  final TextStyle? txtStyle;

  const CommonButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.width,
      this.height,
      this.color,
      this.txtStyle})
      : super(key: key);

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: widget.onPressed,
      child: Container(
        height: widget.height ?? 35,
        alignment: AlignmentDirectional.center,
        // padding: const EdgeInsetsDirectional.only(
        //     start: 10, end: 10, top: 10, bottom: 10),
        width: widget.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topEnd,
            end: AlignmentDirectional.bottomStart,
            colors: [
              widget.color ?? ConstColor.codeTextButtonColor,
              widget.color ?? ConstColor.codeTextButtonColor,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: widget.txtStyle ?? buttonTitleStyle,
        ),
      ),
    );
  }
}

class GreyButton extends StatefulWidget {
  final Function() onPressed;
  final String title;

  const GreyButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  State<GreyButton> createState() => _GreyButtonState();
}

class _GreyButtonState extends State<GreyButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        height: 35,
        alignment: AlignmentDirectional.center,
        width: 180,
        decoration: BoxDecoration(
          // ignore: use_full_hex_values_for_flutter_colors
          color: ConstColor.accentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.title,
          style: greyButtonStyle,
        ),
      ),
    );
  }
}

class BlueCurveLogoWidget extends StatefulWidget {
  const BlueCurveLogoWidget({Key? key}) : super(key: key);

  @override
  State<BlueCurveLogoWidget> createState() => _BlueCurveLogoWidgetState();
}

class _BlueCurveLogoWidgetState extends State<BlueCurveLogoWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        // Container(
        //   // alignment: AlignmentDirectional.centerEnd,
        //   child: Image.asset(
        //     logo(),
        //     fit: BoxFit.fill,
        //   ),
        // ),
        Container(
          width: 200,
          height: 180,
          alignment: Alignment.center,
          child: Center(
            child: Image.asset(
              AppConstents.appLogo,
              fit: BoxFit.contain,
            ),
          ),
        )
      ],
    ));
  }

  logo() {
    // int? lngIndex =
    //     UserSession.getIntFromSession(UserSession.keyLocalIndex) as int?;
    int lngIndex = (UserSession.getLngIndex(UserSession.keyLocalIndex));
    print("index..  $lngIndex");
    if (lngIndex == 2 || lngIndex == 3) {
      return AppConstents.blackRightBgImg;
    } else {
      return AppConstents.blackBgImg;
    }
  }
}

Widget socialIconsButton(icon) {
  return Image.asset(
    icon,
    fit: BoxFit.contain,
    width: 35,
    height: 35,
  );
}

Widget pickupDropoffRow(icon, text, maxlines, style) {
  return Row(
    children: [
      Image.asset(
        icon,
        height: 15,
        width: 15,
      ),
      const SizedBox(
        width: 5,
      ),
      Expanded(
        child: Text(
          text,
          style: style,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      )
    ],
  );
}

Widget rideOTP() {
  return Container(
    height: 42,
    width: 32,
    decoration:
        BoxDecoration(border: Border.all(color: ConstColor.accentColor)),
    child: Center(
      child: Text(
        "5",
        style: quantityTextStyle,
      ),
    ),
  );
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 60));
  }

  void dispose() {
    super.dispose();
    _animationController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 45.0,
            height: 28.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: widget.value == false ? Colors.grey : Colors.green,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                  top: 2.0, bottom: 2.0, end: 2.0, start: 2.0),
              child: Container(
                alignment: widget.value
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

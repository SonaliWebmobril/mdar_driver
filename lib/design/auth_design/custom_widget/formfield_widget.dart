// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api, unnecessary_null_in_if_null_operators

import 'package:flutter/material.dart';

import '../../../utils/const_color.dart';
import '../../../utils/style.dart';

class AllInputDesign extends StatefulWidget {
  final controller;
  final textInputAction;
  final focusNode;
  final prefixText;
  final enabled;
  final hintText;
  final inputHeaderName;
  final prefixStyle;
  final validator;
  final errorText;
  final keyBoardType;
  final validatorFieldValue;
  final readonly;
  final obsecureText;
  final dynamic suffixIcon;
  final prefixIcon;
  final maxlength;

  const AllInputDesign({
    Key? key,
    this.controller,
    this.enabled,
    this.prefixText,
    this.prefixStyle,
    this.keyBoardType,
    this.obsecureText,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText,
    this.inputHeaderName,
    this.validatorFieldValue,
    this.validator,
    this.errorText,
    this.textInputAction,
    this.focusNode,
    this.readonly,
    this.maxlength,
  }) : super(key: key);

  @override
  _AllInputDesignState createState() => _AllInputDesignState();
}

class _AllInputDesignState extends State<AllInputDesign> {
  // var cf = CommonFunctions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Text(
            (widget.inputHeaderName != null) ? widget.inputHeaderName : '',
            style: loginFormHeadingStyle,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 50,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
          child: TextFormField(
            maxLength: widget.maxlength,

            readOnly: widget.readonly ?? false,
            cursorColor: ConstColor.bluecodeTextButtonColor,
            // onSaved: widget.onSaved,
            textInputAction: widget.textInputAction ?? TextInputAction.done,
            //  onEditingComplete: widget.onEditingComplete,
            focusNode: widget.focusNode,

            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.8,
            ),
            keyboardType: widget.keyBoardType,
            validator: (val) =>
                widget.validator(val, widget.validatorFieldValue),
            controller: widget.controller,
            enabled: widget.enabled,

            //  inputFormatters: widget.inputFormatterData,
            obscureText: widget.obsecureText ?? false,
            //  onChanged: widget.onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: "",
              filled: true,
              fillColor: Colors.white,
              hintText: (widget.hintText != null) ? widget.hintText : '',
              hintStyle: const TextStyle(
                  color: ConstColor.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              suffixIcon: widget.suffixIcon ?? null,
              prefixIcon: widget.prefixIcon ?? null,
              prefixText: widget.prefixText ?? null,
              prefixStyle: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.8,
              ),
              errorText: widget.errorText,
              contentPadding:
                  const EdgeInsetsDirectional.symmetric(horizontal: 16),
              // focusedBorder: OutlineInputBorder(
              //   // borderRadius: BorderRadius.circular(15),
              //   borderSide: const BorderSide(
              //       color: ConstColor.codeFieldColor, width: 0.2),
              // ),
              // enabledBorder: OutlineInputBorder(
              //   //  borderRadius: BorderRadius.circular(15),
              //   borderSide: const BorderSide(
              //       color: ConstColor.codeFieldColor, width: 0.2),
              // ),
              // border: OutlineInputBorder(
              //     // borderRadius: BorderRadius.circular(15),
              //     borderSide: const BorderSide(
              //         color: ConstColor.codeFieldColor, width: 0.2))
            ),
          ),
        ),
      ],
    );
  }
}

class EditProfileAllInputDesing extends StatefulWidget {
  final controller;
  final textInputAction;
  final focusNode;
  final enabled;
  final hintText;
  final prefixStyle;
  final errorText;
  final keyBoardType;
  final readonly;
  final maxlength;
  const EditProfileAllInputDesing(
      {Key? key,
      this.controller,
      this.enabled,
      this.prefixStyle,
      this.keyBoardType,
      this.hintText,
      this.errorText,
      this.textInputAction,
      this.focusNode,
      this.readonly,
      this.maxlength})
      : super(key: key);

  @override
  State<EditProfileAllInputDesing> createState() =>
      _EditProfileAllInputDesingState();
}

class _EditProfileAllInputDesingState extends State<EditProfileAllInputDesing> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: TextFormField(
            maxLength: widget.maxlength,
            readOnly: widget.readonly ?? false,
            cursorHeight: 18,
            cursorColor: ConstColor.blackColor,
            textInputAction: widget.textInputAction,
            focusNode: widget.focusNode,
            style: const TextStyle(
              color: ConstColor.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
            keyboardType: widget.keyBoardType,
            controller: widget.controller,
            enabled: widget.enabled,
            decoration: InputDecoration(
                // border: InputBorder.none,
                counterText: "",
                // filled: true,
                // fillColor: ConstColor.codeFieldColor,
                labelText: (widget.hintText != null) ? widget.hintText : '',
                labelStyle: const TextStyle(
                    color: ConstColor.blackColor,
                    fontSize: 16,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w600),
                contentPadding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 8),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: ConstColor.codeFieldTextColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: ConstColor.codeFieldTextColor, width: 1),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: ConstColor.codeFieldTextColor, width: 1))),
          ),
        ),
        // Container(
        //   margin: const EdgeInsetsDirectional.symmetric(horizontal: 30),
        //   height: 2,
        //   color: ConstColor.blackColor,
        // )
      ],
    );
  }
}

class RideConfirmInputDesign extends StatefulWidget {
  final controller;
  final textInputAction;
  final focusNode;
  final prefixText;
  final enabled;
  final hintText;
  final inputHeaderName;
  final prefixStyle;
  final validator;
  final errorText;
  final keyBoardType;
  final validatorFieldValue;
  final readonly;
  final obsecureText;
  final dynamic suffixIcon;
  final prefixIcon;
  final maxlength;

  const RideConfirmInputDesign({
    Key? key,
    this.controller,
    this.enabled,
    this.prefixText,
    this.prefixStyle,
    this.keyBoardType,
    this.obsecureText,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText,
    this.inputHeaderName,
    this.validatorFieldValue,
    this.validator,
    this.errorText,
    this.textInputAction,
    this.focusNode,
    this.readonly,
    this.maxlength,
  }) : super(key: key);

  @override
  _RideConfirmInputDesignState createState() => _RideConfirmInputDesignState();
}

class _RideConfirmInputDesignState extends State<RideConfirmInputDesign> {
  // var cf = CommonFunctions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
          child: Text(
            (widget.inputHeaderName != null) ? widget.inputHeaderName : '',
            style: loginFormHeadingStyle,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 40,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
          child: TextFormField(
            maxLength: widget.maxlength,

            readOnly: widget.readonly ?? false,
            cursorColor: ConstColor.bluecodeTextButtonColor,
            // onSaved: widget.onSaved,
            textInputAction: widget.textInputAction,
            //  onEditingComplete: widget.onEditingComplete,
            focusNode: widget.focusNode,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.8,
            ),
            keyboardType: widget.keyBoardType,
            validator: (val) =>
                widget.validator(val, widget.validatorFieldValue),
            controller: widget.controller,
            enabled: widget.enabled,
            //  inputFormatters: widget.inputFormatterData,
            obscureText: widget.obsecureText ?? false,
            //  onChanged: widget.onChanged,
            decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: ConstColor.rideInputColor,
                hintText: (widget.hintText != null) ? widget.hintText : '',
                hintStyle: const TextStyle(
                    color: ConstColor.codeFieldColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                suffixIcon: widget.suffixIcon ?? null,
                prefixIcon: widget.prefixIcon ?? null,
                errorText: widget.errorText,
                contentPadding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                      color: ConstColor.rideInputColor, width: 0.2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                      color: ConstColor.rideInputColor, width: 0.2),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                        color: ConstColor.rideInputColor, width: 0.2))),
          ),
        ),
      ],
    );
  }
}

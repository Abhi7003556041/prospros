import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizing/sizing.dart';

import '../constants/color.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required this.labelTxt,
      required this.hintTxt,
      this.controller,
      this.suffixIcon,
      //this.prefixIcon,
      this.obscureText = false,
      this.maxLines,
      this.labelTextStyle,
      this.initialValue,
      this.autoFoucus = false,
      this.isBordered = true,
      this.prefixIcon,
      this.validator,
      this.hintTextStyle,
      this.inputFormatters,
      this.keyboardType = TextInputType.text,
      this.onChanged,
      this.style})
      : super(key: key);
  final String labelTxt;
  final String hintTxt;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final String? initialValue;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final int? maxLines;
  final bool autoFoucus;
  final bool isBordered;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return maxLines == null
        ? TextFormField(
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            validator: validator,
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            obscureText: obscureText,
            scrollPadding: EdgeInsets.all(20),
            cursorColor: Colors.black,
            initialValue: initialValue,
            onChanged: onChanged,
            style: style,
            decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                //labelText: labelTxt,
                label: Text(labelTxt, textAlign: TextAlign.start),
                hintText: hintTxt,
                hintStyle: hintTextStyle,
                floatingLabelAlignment: FloatingLabelAlignment.center,
                border: isBordered ? customInputBorder() : InputBorder.none,
                enabledBorder:
                    isBordered ? customInputBorder() : InputBorder.none,
                focusedBorder:
                    isBordered ? customFocusBorder() : InputBorder.none,
                errorBorder:
                    isBordered ? customErrorBorder() : InputBorder.none,
                contentPadding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon))
        : TextFormField(
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            validator: validator,
            controller: controller,
            obscureText: false,
            maxLines: maxLines,
            autofocus: autoFoucus,
            initialValue: initialValue,
            onChanged: onChanged,
            style: style,
            decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                // labelText: labelTxt,
                contentPadding: EdgeInsets.all(8.ss),
                hintText: hintTxt,
                labelStyle: labelTextStyle,
                label: Text(
                  labelTxt,
                  textAlign: TextAlign.start,
                ),
                hintStyle: hintTextStyle,
                border: isBordered ? customInputBorder() : InputBorder.none,
                enabledBorder:
                    isBordered ? customInputBorder() : InputBorder.none,
                focusedBorder:
                    isBordered ? customFocusBorder() : InputBorder.none,
                errorBorder:
                    isBordered ? customErrorBorder() : InputBorder.none,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon
                //prefixIcon: prefixIcon
                ),
          );
  }
}

OutlineInputBorder customErrorBorder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: Colors.red));
}

OutlineInputBorder customInputBorder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: AppColor.borderColor //width: 1
          ));
}

OutlineInputBorder customFocusBorder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: AppColor.borderColor));
}

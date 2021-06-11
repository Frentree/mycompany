import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';

InputDecoration loginTextFormRoundBorderDecoration({String? hintText, Widget? suffixIcon}) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 12.0.w),
    filled: true,
    fillColor: Color(0xffF7F7F7),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0.r),
      borderSide: BorderSide(
        width: 0.0,
        style: BorderStyle.none
      ),
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      fontSize: 14.0.sp,
      color: hintTextColor,
    ),
    counterText: "",
    suffixIcon: suffixIcon,
    suffixIconConstraints: BoxConstraints(),
  );
}

InputDecoration loginTextFormUnderlineBorderDecoration({String? hintText, Widget? suffixIcon}) {
  return InputDecoration(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffC4C4C4)
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffC4C4C4)
      ),
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      fontSize: 14.0.sp,
      color: hintTextColor,
    ),
    suffixIcon: suffixIcon,
    suffixIconConstraints: BoxConstraints(),
  );
}
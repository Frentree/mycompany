import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';

class DecorationStyle {
  InputDecoration textFormDecoration({String? hintText}) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0.w),
      filled: true,
      fillColor: textFormBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0.r),
        borderSide: BorderSide(
          width: 0.0,
          style: BorderStyle.none,
        ),
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 13.0.sp,
        color: hintTextColor,
      ),
    );
  }
}

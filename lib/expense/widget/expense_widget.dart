import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';

SizedBox expenseBottomSheetButton({required BuildContext context, required String buttonName, required Color buttonNameColor, required Color buttonColor, VoidCallback? buttonAction,}){
  return SizedBox(
    width: 180.0.w,
    height: 57.0.h,
    child: ElevatedButton(
      child: Text(
        buttonName,
        style: TextStyle(
          fontSize: 15.0.sp,
          fontWeight: fontWeight["Medium"],
          color: buttonNameColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        primary: buttonColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0.r)
        ),
      ),
      onPressed: buttonAction,
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';

Container attendanceDialogElevatedButton({required double topPadding, required String buttonName, VoidCallback? buttonAction}) {
  return Container(
    padding: EdgeInsets.only(
      top: topPadding,
      bottom: 15.0.h,
    ),
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Color(0xff949494);
          }
          else {
            return Color(0xff2093F0);
          }
        }),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
        ),
        elevation: MaterialStateProperty.all(
          0.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25.0.w,
        ),
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 13.0.sp,
            color: whiteColor,
          ),
        ),
      ),
      onPressed: buttonAction,
    ),
  );
}

Container attendanceDialogConfirmButton({required String buttonName, VoidCallback? buttonAction,}){
  return Container(
    padding: EdgeInsets.only(top: 24.0.h),
    child: SizedBox(
      width: 75.0.w,
      height: 26.0.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff2093F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          elevation: 0.0,
        ),
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 13.0.sp,
            color: whiteColor,
          ),
        ),
        onPressed: buttonAction,
      ),
    ),
  );
}

Container attendanceDialogCancelButton({required String buttonName, VoidCallback? buttonAction,}){
  return Container(
    padding: EdgeInsets.only(top: 24.0.h),
    child: SizedBox(
      width: 75.0.w,
      height: 26.0.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xffECECEC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          elevation: 0.0,
        ),
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 13.0.sp,
            color: textColor,
          ),
        ),
        onPressed: buttonAction,
      ),
    ),
  );
}

SizedBox attendanceBottomSheetButton({required String buttonName, required Color buttonNameColor, required Color buttonColor, VoidCallback? buttonAction,}){
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
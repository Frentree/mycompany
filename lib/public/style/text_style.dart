
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle getNotoSantRegular({required double fontSize,required Color color}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w400,
    fontFamily: "NotoSansKR",
    color: color,
  );
}

TextStyle getNotoSantMedium({required double fontSize,required Color color}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w500,
    fontFamily: "NotoSansKR",
    color: color,
  );
}

TextStyle getNotoSantBold({required double fontSize,required Color color}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "NotoSansKR",
    color: color,
  );
}

TextStyle getRobotoRegular({required double fontSize,required Color color}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
    color: color,
  );
}

TextStyle getRobotoMedium({required double fontSize,required Color color}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
    color: color,
  );
}

TextStyle getRobotoBold({required double fontSize,required Color color}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
    color: color,
  );
}
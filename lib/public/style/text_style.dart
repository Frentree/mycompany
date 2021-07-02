
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle getNotoSantRegular({required double fontSize,required Color color, TextDecoration? decoration}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w400,
    fontFamily: "NotoSansKR",
    color: color,
    decoration: decoration
  );
}

TextStyle getNotoSantMedium({required double fontSize,required Color color, TextDecoration? decoration}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w500,
    fontFamily: "NotoSansKR",
    color: color,
    decoration: decoration
  );
}

TextStyle getNotoSantBold({required double fontSize,required Color color, TextDecoration? decoration}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "NotoSansKR",
    color: color,
    decoration: decoration
  );
}

TextStyle getRobotoRegular({required double fontSize,required Color color, TextDecoration? decoration}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
    color: color,
    decoration: decoration
  );
}

TextStyle getRobotoMedium({required double fontSize,required Color color, TextDecoration? decoration}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
    color: color,
    decoration: decoration
  );
}

TextStyle getRobotoBold({required double fontSize,required Color color, TextDecoration? decoration}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
    color: color,
    decoration: decoration
  );
}
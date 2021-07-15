
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/public/style/color.dart';

Future<dynamic> settingDialogWidget({required BuildContext context, required String message, List<Widget>? actions, required double width}) {
  return showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          child: Container(
            width: width.w,
            padding: EdgeInsets.only(
              top: 19.0.h,
              bottom: 15.0.h,
              left: 18.0.w,
              right: 17.0.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12.0.sp,
                    color: textColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: actions != null ? actions : [],
                ),
              ],
            ),
          ),
        );
      }
  );
}
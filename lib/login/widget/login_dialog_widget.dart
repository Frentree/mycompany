import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:easy_localization/easy_localization.dart';

Future<dynamic> loginDialogWidget({required BuildContext context, required String message, List<Widget>? actions}) {
  return showDialog(
    context: context,
    builder: (BuildContext context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.r),
        ),
        child: Container(
          width: 232.0.w,
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
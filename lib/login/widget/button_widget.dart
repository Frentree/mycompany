import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';

class ButtonWidget {
  Container elevatedButton({required double topPadding, required String buttonName, VoidCallback? buttonAction}) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 1.0.sw,
      padding: EdgeInsets.only(
        top: topPadding,
        left: 27.5.w,
        right: 27.5.w,
      ),
      child: SizedBox(
        width: 305.0.w,
        height: 40.0.h,
        child: ElevatedButton(
          style: ButtonStyle(

            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return Color(0xff949494);
              }
              else {
                return Color(0xff2573D5);
              }
            }),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0.r),
              ),
            ),
            elevation: MaterialStateProperty.all(
              0.0,
            )
          ),
          child: Text(
            buttonName,
            style: TextStyle(
              fontSize: 14.0.sp,
              color: whiteColor,
            ),
          ),
          onPressed: buttonAction,
        ),
      ),
    );
  }

  Container outlinedButton({required double topPadding, required String buttonName, VoidCallback? buttonAction}) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 1.0.sw,
      padding: EdgeInsets.only(
        top: topPadding,
        left: 27.5.w,
        right: 27.5.w,
      ),
      child: SizedBox(
        width: 305.0.w,
        height: 40.0.h,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0.r),
              side: BorderSide(
                color: Color(0xffC4C4C4),
              )
            ),
            elevation: 0.0
          ),
          child: Text(
            buttonName,
            style: TextStyle(
              fontSize: 14.0.sp,
              color: textColor,
            ),
          ),
          onPressed: buttonAction,
        ),
      ),
    );
  }
  
  IconButton textFormClearButton({required TextEditingController textEditingController}) {
    return IconButton(
      icon: Icon(
        Icons.cancel,
      ),
      color: Color(0xffC4C4C4),
      iconSize: 15.0.w,
      onPressed: (){
        textEditingController.clear();
      },
    );
  }
}

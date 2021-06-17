import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';

Container loginElevatedButton({required double topPadding, required String buttonName, VoidCallback? buttonAction}) {
  return Container(
    padding: EdgeInsets.only(
      top: topPadding,
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
          ),
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

Container loginOutlinedButton({required double topPadding, required String buttonName, VoidCallback? buttonAction}) {
  return Container(
    padding: EdgeInsets.only(
      top: topPadding,
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

Widget textFormClearButton({required TextEditingController textEditingController}) {
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

IconButton textFormSearchButton() {
  return IconButton(
    icon: Icon(
      Icons.search,
    ),
    color: Color(0xff2093F0),
    disabledColor: Color(0xff2093F0),
    iconSize: 15.0.w,
    onPressed: null,
  );
}

Container loginDialogConfirmButton({required String buttonName, VoidCallback? buttonAction,}){
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

Container loginDialogCancelButton({required String buttonName, VoidCallback? buttonAction,}){
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

Container userTypeSelectButton({required BuildContext context, required double topPadding, required String buttonName, required String secondButtonName, required String iconPath, required Widget movePageName}){
  return Container(
    padding: EdgeInsets.only(
      top: topPadding,
    ),
    child: SizedBox(
      width: 266.0.w,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 8.3.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0.r),
              side: BorderSide(
                color: Color(0xffC4C4C4),
              )
          ),
          elevation: 0.0
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 47.0.w,
              height: 47.0.h,
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0.h),
              child: Text(
                buttonName,
                style: TextStyle(
                  fontSize: 15.0.sp,
                  fontWeight: fontWeight['Bold'],
                  color: Color(0xff131313),
                ),
              ),
            ),
            Container(
              child: Text(
                "(${secondButtonName})",
                style: TextStyle(
                  fontSize: 13.0.sp,
                  color: Color(0xff131313),
                ),
              ),
            ),
          ],
        ),
        onPressed: () => pageMove(context: context, pageName: movePageName),
      ),
    ),
  );
}


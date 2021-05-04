import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';

class LoginDialogWidget {
  Future<dynamic> loginDialogWidget({required BuildContext context, String? title, required Widget content, required List<Widget> actions}){
    return showDialog(
      context: context,
      /*barrierDismissible: false,*/
      builder: (BuildContext context){
        return AlertDialog(
          content: content,
          actions: actions
        );
      }
    );
  }

  Future<dynamic> firebaseAuthErrorDialogWidget({required BuildContext context, required String errorMessage,}) {
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          child: Container(
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
                  errorMessage,
                  style: TextStyle(
                    fontSize: 12.0.sp,
                    color: textColor,
                  ),
                ),
                Container(
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
                        "확인",
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: whiteColor,
                        ),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
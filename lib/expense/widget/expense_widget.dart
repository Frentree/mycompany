import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/expense/widget/expense_dialog_widget.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/public/style/text_style.dart';

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


Widget getExpenseUserItem({
  required BuildContext context,
  required ApprovalModel model,
  required double size,
  required UserModel loginUser
}){
  DateFormatCustom _format = DateFormatCustom();
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xff9C9C9C).withOpacity(0.3),
            offset: Offset(1.0, 15.0),
            blurRadius: 20.0,
          ),
        ],
        color: whiteColor,
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0.w,
                vertical: 10.0.h,
              ),
              decoration: BoxDecoration(
                color: Color(0xff2093F0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0.r),
                  topRight: Radius.circular(12.0.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.user,
                    style: getRobotoBold(fontSize: 13, color: whiteColor),
                  ),
                  Icon(
                    Icons.zoom_in_sharp,
                    color: whiteColor,
                  )
                ],
              ),
            ),
            onTap: () {
              showExpenseDataDetail(context: context, model: model, loginUser: loginUser);
            },
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 5.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            width: 70.0.w,
                            child: Text(
                              (model.isSend! == false) ? "미입금" : "입금 완료",
                              style: getRobotoBold(fontSize: 13, color: (model.isSend! == false) ? Colors.red : Colors.blue),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            )
                        ),
                        Container(
                            width: 100.0.w,
                            child: Text(
                              model.requestStartDate.toDate().month.toString() + "월 경비 내역" ,
                              style: getRobotoBold(fontSize: 13, color: textColor),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            )
                        ),
                        Container(
                            child: Text(model.totalCost!.toString() + "원",
                              style: getRobotoBold(fontSize: 13, color: textColor),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            )
                        ),
                      ],
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.double_arrow
                      ),
                      onPressed: () {

                      },
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}

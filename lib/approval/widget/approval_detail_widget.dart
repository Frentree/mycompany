import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/expense/widget/expense_dialog_widget.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';

Widget getDetailsContents({
  required String title,
  required String content,
  required double size,
}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
    child: Container(
      width: double.infinity,
      height: size.h,
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
          Container(
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
            child: Text(
              title.tr(),
              style: getRobotoBold(fontSize: 13, color: whiteColor),
            ),

          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                right: 16.0.w,
                left: 16.0.w,
                top: 5.0.h,
              ),
              child: Text(
                content,
                style: getNotoSantRegular(fontSize: 12, color: textColor),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget getDetailsApprovalContents({
  required String title,
  required TextEditingController noteController,
  required double size,
}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
    child: Container(
      width: double.infinity,
      height: size.h,
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
          Container(
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
            child: Text(
              title.tr(),
              style: getRobotoBold(fontSize: 13, color: whiteColor),
            ),

          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                right: 16.0.w,
                left: 16.0.w,
                top: 5.0.h,
              ),
              child: Container(
                child: TextFormField(
                    controller: noteController,
                    autofocus: false,
                    minLines: 1,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "approval_content_input".tr(),
                      hintStyle: getNotoSantRegular(
                        fontSize: 13.0,
                        color: hintTextColor,
                      ),
                    ),
                    style: getNotoSantRegular(
                        fontSize: 13.0,
                        color: textColor
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget getDetailsScrollContents({
  required String title,
  required String content,
  required double size,
}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
    child: Container(
      width: double.infinity,
      height: size.h,
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
          Container(
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
            child: Text(
              title.tr(),
              style: getRobotoBold(fontSize: 13, color: whiteColor),
            ),

          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  right: 16.0.w,
                  left: 16.0.w,
                  top: 5.0.h,
                ),
                child: Text(
                  content,
                  style: getNotoSantRegular(fontSize: 12, color: textColor),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}



Widget getExpenseItem({
  required BuildContext context,
  required String title,
  required ApprovalModel model,
  required double size,
  required UserModel loginUser
}){
  return InkWell(
    child: Padding(
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
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0.w,
            vertical: 10.0.h,
          ),
          decoration: BoxDecoration(
            color: Color(0xff2093F0),
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.tr(),
                style: getRobotoBold(fontSize: 13, color: whiteColor),
              ),
              Icon(
                Icons.zoom_in_sharp,
                color: whiteColor,
              )
            ],
          ),
        ),
      ),
    ),
    onTap: () {
      showExpenseDataDetail(context: context, model: model, loginUser: loginUser);
    },
  );
}


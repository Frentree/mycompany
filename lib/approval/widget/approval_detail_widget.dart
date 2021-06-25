import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';

Widget getContents({
  required String title,
  required String content
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        height: 23.0.h,
        color: calendarDetailLineColor,
        padding: EdgeInsets.only(left: 17.0.w),
        alignment: Alignment.centerLeft,
        child: Text(
          title.tr(),
          style: getNotoSantBold(fontSize: 13.0, color: textColor),
        ),
      ),
      SizedBox(height: 7.0.h,),
      Container(
        padding: EdgeInsets.only(left: 15.0.w),
        child: Text(content, style: getNotoSantMedium(fontSize: 12.0, color: textColor))),
      SizedBox(height: 7.0.h,),
    ],
  );
}

Widget getApprovalContents({
  required String title,
  required TextEditingController noteController,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        height: 23.0.h,
        color: calendarDetailLineColor,
        padding: EdgeInsets.only(left: 17.0.w),
        alignment: Alignment.centerLeft,
        child: Text(
          title.tr(),
          style: getNotoSantBold(fontSize: 13.0, color: textColor),
        ),
      ),
      SizedBox(height: 7.0.h,),
      Container(
        padding: EdgeInsets.only(left: 15.0.w),
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
      SizedBox(height: 7.0.h,),
    ],
  );
}

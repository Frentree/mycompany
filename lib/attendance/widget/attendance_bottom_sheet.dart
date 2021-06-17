import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/attendance/widget/attendance_dialog_widget.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:easy_localization/easy_localization.dart';

Future<dynamic> applyOvertimeBottomSheet({required BuildContext context}) {
  int? overtime = 0;

  return showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4.0.r),
        topRight: Radius.circular(4.0.r),
      ),
    ),
    context: context,
    builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context, setState){
          return Container(
            padding: EdgeInsets.only(
              top: 10.0.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 27.0.w,
                  height: 6.0.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0.r),
                    ),
                    color: Color(0xffC4C4C4),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 17.0.h,
                  ),
                  child: bottomSheetRadioItem(
                    itemName: "1시간",
                    groupValue: overtime!,
                    value: 1,
                    onChanged: (int? value){
                      setState((){
                        overtime = value;
                      });
                    }
                  ),
                ),
                bottomSheetRadioItem(
                  itemName: "2시간",
                  groupValue: overtime!,
                  value: 2,
                  onChanged: (int? value){
                    setState((){
                      overtime = value;
                    });
                  }
                ),
                bottomSheetRadioItem(
                  itemName: "3시간",
                  groupValue: overtime!,
                  value: 3,
                  onChanged: (int? value){
                    setState((){
                      overtime = value;
                    });
                  }
                ),
                bottomSheetRadioItem(
                  itemName: "4시간",
                  groupValue: overtime!,
                  value: 4,
                  onChanged: (int? value){
                    setState((){
                      overtime = value;
                    });
                  }
                ),
                Row(
                  children: [
                    attendanceBottomSheetButton(
                      buttonName: 'dialogCancel'.tr(),
                      buttonNameColor: textColor,
                      buttonColor: Color(0xffF7F7F7),
                      buttonAction: (){
                        backPage(context: context);
                      }
                    ),
                    attendanceBottomSheetButton(
                      buttonName: "연장근무 신청",
                      buttonNameColor: whiteColor,
                      buttonColor: Color(0xff2093F0),
                      buttonAction: (){
                        backPage(context: context);
                      }
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Container bottomSheetRadioItem(
    {required String itemName,
      required int groupValue,
      required int value,
      required ValueChanged<int?> onChanged}) {
  return Container(
    padding: EdgeInsets.only(
      left: 25.0.w,
      right: 25.0.w,
    ),
    color: groupValue == value ? Color(0xff2093F0).withOpacity(0.1) : null,
    child: RadioListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        itemName,
        style: TextStyle(
          fontSize: 13.0.sp,
          fontWeight: fontWeight["Medium"],
          color: textColor,
        ),
      ),
      value: value,
      onChanged: onChanged,
      groupValue: groupValue,
      controlAffinity: ListTileControlAffinity.trailing,
    ),
  );
}


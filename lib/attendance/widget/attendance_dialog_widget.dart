import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/attendance/db/attendance_firestore_repository.dart';
import 'package:mycompany/attendance/function/show_work_type.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:easy_localization/easy_localization.dart';

Future<dynamic> changeWorkingStatusDialog({required BuildContext context, required String buttonName}) {
  DateFormatCustom dateFormatCustom = DateFormatCustom();

  int? attendance = 0;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0.r),
            ),
            child: Container(
              width: 232.0.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateFormatCustom.todayStringFormat(),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13.0.sp,
                            fontWeight: fontWeight['Medium'],
                            color: whiteColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 13.0.w,
                            color: whiteColor,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () => backPage(context: context, returnValue: attendance),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0.h),
                    child: dialogRadioItem(
                      itemName: "내근",
                      groupValue: attendance!,
                      value: 1,
                      onChanged: (int? value) {
                        setState(
                          () {
                            attendance = value;
                          },
                        );
                      },
                    ),
                  ),
                  dialogRadioItem(
                    itemName: "외근",
                    groupValue: attendance!,
                    value: 2,
                    onChanged: (int? value) {
                      setState(
                        () {
                          attendance = value;
                        },
                      );
                    },
                  ),
                  dialogRadioItem(
                    itemName: "직출",
                    groupValue: attendance!,
                    value: 3,
                    onChanged: (int? value) {
                      setState(
                        () {
                          attendance = value;
                        },
                      );
                    },
                  ),
                  dialogRadioItem(
                    itemName: "재택",
                    groupValue: attendance!,
                    value: 4,
                    onChanged: (int? value) {
                      setState(
                        () {
                          attendance = value;
                        },
                      );
                    },
                  ),
                  attendanceDialogElevatedButton(
                    topPadding: 11.0.h,
                    buttonName: buttonName,
                    buttonAction: attendance == 0 ? null : (){
                      backPage(context: context, returnValue: attendance);
                    }
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<dynamic> viewWorkingStatusDialog({required BuildContext context, Timestamp? attendTime, Timestamp? endTime, required int workTypeNumber}){
  DateFormatCustom dateFormatCustom = DateFormatCustom();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0.r),
            ),
            child: Container(
              width: 232.0.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateFormatCustom.todayStringFormat(),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13.0.sp,
                            fontWeight: fontWeight['Medium'],
                            color: whiteColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 13.0.w,
                            color: whiteColor,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () => backPage(context: context, returnValue: 0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 18.0.h,
                      left: 16.0.w,
                      right: 16.0.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Color(0xff2093F0),
                                size: 20.0.w,
                              ),
                              SizedBox(
                                width: 7.0.w,
                              ),
                              Text(
                                workTypeNumber == 0 ? "" : workTypeNumber != 6 ? "${dateFormatCustom.changeTimeToString(time: attendTime!)}" : "${dateFormatCustom.changeTimeToString(time: attendTime!)} - ${dateFormatCustom.changeTimeToString(time: endTime!)}",
                                style: TextStyle(
                                  fontSize: 13.0.sp,
                                  fontWeight: fontWeight["Medium"],
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          changeWorkTypeNumberToString(workTypeNumber: workTypeNumber),
                          style: TextStyle(
                            fontSize: 13.0.sp,
                            fontWeight: fontWeight["Medium"],
                            color: textColor,
                          ),
                        )
                      ],
                    ),
                  ),

                  attendanceDialogElevatedButton(
                    topPadding: 11.0.h,
                    buttonName: "근무상태변경",
                    buttonAction: workTypeNumber != 0 ? () async {
                      workTypeNumber = await changeWorkingStatusDialog(context: context, buttonName: "변경");
                      backPage(context: context, returnValue: workTypeNumber);
                    } : null,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<dynamic> finishWorkDialog({required BuildContext context}) {
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
              left: 32.0.w,
              right: 32.0.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "퇴근 하시겠습니까?",
                  style: TextStyle(
                    fontSize: 12.0.sp,
                    color: textColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    attendanceDialogCancelButton(
                      buttonName: 'dialogCancel'.tr(),
                      buttonAction: () {
                        backPage(context: context, returnValue: false);
                      }
                    ),
                    attendanceDialogConfirmButton(
                      buttonName: 'dialogConfirm'.tr(),
                      buttonAction: (){
                        backPage(context: context, returnValue: true);
                      }
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
  );
}



Container dialogRadioItem(
    {required String itemName,
    required int groupValue,
    required int value,
    required ValueChanged<int?> onChanged}) {
  return Container(
    padding: EdgeInsets.only(
      left: 16.0.w,
      right: 16.0.w,
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

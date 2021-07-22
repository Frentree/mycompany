
import 'package:flutter/material.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/attendance/widget/attendance_dialog_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_picker_widget.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_theme.dart';

Future<dynamic> expenseReceiptWidget({required BuildContext context, required String? ImageUrl}) {
  return showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          child: Container(
            width: 200.0.w,
            padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.h),
            child:  FadeInImage.assetNetwork(
              placeholder: 'assets/icons/spinner.gif',
              placeholderScale: 9.0,
              image: ImageUrl.toString(),
            ),
          ),
        );
      }
  );
}


Future<DateTime> showExpenseDatePicker({required BuildContext context, required DateTime date}) async {
  DateTime pickDate = date;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(top: 20, bottom: 20),
        content: Container(
            width: MediaQuery.of(context).size.width,
            height: 270.0.h,
            child: Center(
              child: DatePickerWidget(
                dateFormat: "yyyy MM dd",
                minDateTime: DateTime(1900),
                maxDateTime: DateTime(3000),
                onMonthChangeStartWithFirstDate: true,
                pickerTheme: DateTimePickerTheme(
                  pickerHeight: 200.0.h,
                  showTitle: true,
                ),
                locale: DateTimePickerLocale.ko,
                initialDateTime: date,
                onCancel: () {},
                onConfirm: (dateTime, selectedIndex) {
                  pickDate = dateTime;
                },
                onChange: (dateTime, selectedIndex) {

                },
              ),
            )

          /*CupertinoDatePicker(
              minimumYear: 1900,
              mode: CupertinoDatePickerMode.time,
              initialDateTime: date,
              onDateTimeChanged: (value) {

              },
            ),*/
        ),
      );

    },

  );
  return pickDate;
}


/* 내정보 관련 다이얼로그 시작 */
Future<dynamic> insertExpensePhotoDialog({required BuildContext context}) {
  int? selectOption = 0;

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
                          "영수증 사진 첨부",
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
                          onPressed: () => backPage(context: context, returnValue: selectOption),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0.h),
                    child: dialogRadioItem(
                      itemName: "사진 삭제",
                      groupValue: selectOption!,
                      value: 1,
                      onChanged: (int? value) {
                        setState((){
                          selectOption = value;
                        });
                      },
                    ),
                  ),
                  dialogRadioItem(
                    itemName: "앨범에서 사진 선택",
                    groupValue: selectOption!,
                    value: 2,
                    onChanged: (int? value) {
                      setState((){
                        selectOption = value;
                      });
                    },
                  ),
                  dialogRadioItem(
                    itemName: "카메라로 사진 찍기",
                    groupValue: selectOption!,
                    value: 3,
                    onChanged: (int? value) {
                      setState((){
                        selectOption = value;
                      });
                    },
                  ),
                  attendanceDialogElevatedButton(
                      topPadding: 11.0.h,
                      buttonName: "확인",
                      buttonAction: selectOption == 0 ? null : (){
                        backPage(context: context, returnValue: selectOption,);
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
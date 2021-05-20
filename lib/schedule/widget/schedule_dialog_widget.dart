

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_widget.dart';

class ScheduleDialogWidget {
  DateFormat _format = DateFormat();

  Widget? showScheduleDetail({required BuildContext context,required List<dynamic> data,required DateTime date}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: 21.0.h, left: 17.0.w, right: 17.0.w),
          title: Container(
            width: 313.0.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _format.dateFormat(date: date),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Noto Sans'
                  ),
                ),
                GestureDetector(
                  child: SvgPicture.asset(
                    'assets/icons/close.svg',
                    width: 13.17.w,
                    height: 13.17.h,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          //contentPadding: EdgeInsets.only(top: 21.0.h, bottom: 5.0.h),
          content: Container(
            width: 313.0.w,
            height: 571.0.h,
            child: ListView(
              children: data.map((e) => Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: e.color,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          e.subject + " " + e.startTime.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                        ),
                        Text(
                          e.notes.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                        ),
                        e.location != '' ? Text(
                          e.location.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              )).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<DateTime> showDatePicker({required BuildContext context, required DateTime date}) async {
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
              child: DateTimePickerWidget(
                minDateTime: DateTime.parse('1900-01-01'),
                dateFormat: 'yyyy년 MM월 dd일 HH시 mm분',
                locale: DateTimePickerLocale.ko,
                initDateTime: date,

                onConfirm: (dateTime, selectedIndex) {
                  pickDate = dateTime;
                },
                onChange: (dateTime, selectedIndex) {
                },
                onCancel: () {
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
}
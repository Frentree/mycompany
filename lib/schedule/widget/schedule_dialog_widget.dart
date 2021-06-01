

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_widget.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class ScheduleDialogWidget {
  DateFormatCustom _format = DateFormatCustom();

  Widget? showScheduleDetail({required BuildContext context,required List<dynamic> data,required DateTime date}) {
    List<Appointment> amAppointment = [];
    List<Appointment> pmAppointment = [];

    for(Appointment appoint in data) {
      if(0 < DateTime(date.year, date.month, date.day, 12, 00).difference(DateTime.parse(appoint.startTime.toString())).inHours){
        amAppointment.add(appoint);
        print("오전");
      } else {
        pmAppointment.add(appoint);
        print("오후");
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          titlePadding: EdgeInsets.all(0),
          title: Container(),
          contentPadding: EdgeInsets.all(0),
          //contentPadding: EdgeInsets.only(top: 21.0.h, bottom: 5.0.h),
          content: Container(
            width: 313.0.w,
            height: 621.0.h,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 17.0.w, top: 21.0.h, bottom: 17.0.h, right: 23.1.w),
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
                        child: Container(
                          color: whiteColor,
                          width: 40.0.w,
                          height: 30.0.h,
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(
                            'assets/icons/close.svg',
                            width: 13.17.w,
                            height: 13.17.h,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: getCalendarPerseonalDetail(appointment: amAppointment, timeZone: 1),
                      ),
                      Column(
                        children: getCalendarPerseonalDetail(appointment: pmAppointment, timeZone: 2),
                      )
                    ]
                  ),

                ),
              ],
            ),
          ),
        );
      },
    );
  }


  getCalendarPerseonalDetail({required List<Appointment> appointment,required int timeZone}) {
    var list = <Widget>[Container(width: 16)]; // container is left padding

    if(appointment.isEmpty){
      return list;
    }

    list.add(Column(
      children: [
        Container(
          width: 313.0.w,
          height: 23.0.h,
          color: calendarDetailLineColor,
          padding: EdgeInsets.only(left: 17.0.w),
          alignment: Alignment.centerLeft,
          child: Text(
            timeZone == 0 ? "종일" : timeZone == 1 ? "오전" : "오후",
            style: TextStyle(
                fontSize: 12.0.sp,
                fontFamily: "Noto Sans"
            ),
          ),
        ),
        SizedBox(height: 15.0.h,),
      ],
    ));

    for(Appointment app in appointment){
      list.add(
        Column(
          children: [
            Container(
              width: 278.0.w,
              height: 36.0.h,
              padding: EdgeInsets.only(left: 17.0.w, right: 17.0.w),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        app.subject,
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Noto Sans"
                        ),
                      ),
                      Text(
                        "대리 / 개발팀",
                        style: TextStyle(
                          fontSize: 10.0.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Noto Sans",
                          color: hintTextColor
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 13.0.w,
                  ),
                  Container(
                    width: 2.0.w,
                    height: 29.0.h,
                    color: app.color,
                  ),
                  SizedBox(
                    width: 6.0.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _format.calendarDetailTime(date: app.startTime),
                        style: TextStyle(
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Roboto"
                        ),
                      ),
                      Text(
                        _format.calendarDetailTime(date: app.endTime),
                        style: TextStyle(
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Roboto",
                            color: hintTextColor
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: app.color,
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        width: 34.0.w,
                        height: 19.0.h,
                        child: Center(
                          child: Text(
                            app.type.toString(),
                            style: TextStyle(
                              fontSize: 10.0.sp,
                              color: whiteColor,
                              fontFamily: "Noto Sans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0.h,),
          ],
        )
      );
    }

    return list;
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
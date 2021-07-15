

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/model/employee_model.dart';

import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/view/schedule_detail_view.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_picker_widget.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_widget.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';
import 'package:mycompany/schedule/widget/userProfileImage.dart';

import 'package:easy_localization/easy_localization.dart';

  DateFormatCustom _format = DateFormatCustom();

  Widget? showScheduleDetail({required BuildContext context,required List<dynamic> data,required DateTime date, required List<EmployeeModel> employeeList}) {
    data.sort((a,b) => a.startTime.compareTo(b.startTime));

    List<Appointment> allDayAppointment = [];
    List<Appointment> amAppointment = [];
    List<Appointment> pmAppointment = [];

    for(Appointment appoint in data) {
      if(appoint.isAllDay == true){
        allDayAppointment.add(appoint);
      } else if(0 < DateTime(date.year, date.month, date.day, 12, 00).difference(DateTime.parse(appoint.startTime.toString())).inHours){
        amAppointment.add(appoint);
      } else {
        pmAppointment.add(appoint);
      }
    }

/*    amAppointment.sort((a, b) => a.startTime.compareTo(b.startTime));
    pmAppointment.sort((a, b) => a.startTime.compareTo(b.startTime));*/

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
                        style: getNotoSantBold(fontSize: 14.0, color: textColor),
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: getCalendarPerseonalDetail(context: context, appointment: allDayAppointment, timeZone: 0, employeeList: employeeList),
                        ),
                        Column(
                          children: getCalendarPerseonalDetail(context: context, appointment: amAppointment, timeZone: 1, employeeList: employeeList),
                        ),
                        Column(
                          children: getCalendarPerseonalDetail(context: context, appointment: pmAppointment, timeZone: 2, employeeList: employeeList),
                        )
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  getCalendarPerseonalDetail({required BuildContext context, required List<Appointment> appointment,required int timeZone, required List<EmployeeModel> employeeList}) {
    var list = <Widget>[Container(width: 16.w)]; // container is left padding

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
            timeZone == 0 ? "all_day".tr() : timeZone == 1 ? "am".tr() : "pm".tr(),
            style: TextStyle(
                fontSize: 12.0.sp,
                fontFamily: "NotoSansKR"
            ),
          ),
        ),
        SizedBox(height: 15.0.h,),
      ],
    ));

    for(Appointment app in appointment){
      list.add(
        InkWell(
          child: Column(
            children: [
              Container(
                width: 278.0.w,
                height: 36.0.h,
                padding: EdgeInsets.only(left: 17.0.w, right: 17.0.w),
                child: Row(
                  children: [
                    getProfileImage(
                      size: 36.0,
                      ImageUri: employeeList.firstWhere((element) => element.mail == app.profile).profilePhoto.toString(),
                    ),
                    SizedBox(
                      width: 6.0.w,
                    ),
                    Container(
                      width: 50.0.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            app.subject,
                            style: getNotoSantBold(fontSize: 12.0, color: textColor)
                          ),
                          Text(
                            app.position.toString(),
                            style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor)
                          ),
                        ],
                      ),
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
                          _format.getTime(date: app.startTime),
                          style: getRobotoMedium(fontSize: 10.0, color: textColor),
                        ),
                        Text(
                          _format.getTime(date: app.endTime),
                          style: getRobotoMedium(fontSize: 10.0, color: hintTextColor)
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: app.color,
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                              width: 34.0.w,
                              height: 19.0.h,
                              child: Center(
                                child: Text(
                                  app.type.toString(),
                                  style: getNotoSantRegular(fontSize: 10.0, color: whiteColor),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: app.type == "미팅",
                              child: Text(app.organizerName.toString(), style: getNotoSantRegular(fontSize: 9.0, color: hintTextColor),)
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0.h,),
            ],
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleDetailView(appointment: app, employeeList: employeeList,))),
        ),
      );
    }

    return list;
  }

Future<DateTime> showDatesPicker({required BuildContext context, required DateTime date}) async {
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
                minDateTime: DateTime.parse('1900-01-01'),
                maxDateTime: DateTime.parse('3000-12-31'),
                onMonthChangeStartWithFirstDate: true,
                dateFormat: 'yyyy년 MM월 dd일',
                locale: DateTimePickerLocale.ko,
                initialDateTime: date,
                onConfirm: (DateTime dateTime, selectedIndex) {
                  pickDate = DateTime(dateTime.year, dateTime.month, dateTime.day, date.hour, date.minute, 00);
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

Future<DateTime> showTimesPicker({required BuildContext context, required DateTime date}) async {
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


  Future<DateTime> showDateTimePicker({required BuildContext context, required DateTime date}) async {
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
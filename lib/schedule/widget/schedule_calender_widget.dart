
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class ScheduleCalenderWidget {
  Widget setAppointMentBuilder({required BuildContext context, required CalendarAppointmentDetails details, required DateTime selectTime}) {
    UserModel loginUser = PublicFunction().getUserProviderSetting(context);
    Appointment meeting = details.appointments.last;

    if(details.date.month != selectTime.month){
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w),
      child: Stack(
        children: [
          meeting.profile == loginUser.mail
              ? Container(
            width: 2.0.w,
            color: meeting.color,
          ) : Container(),
          Container(
            color: meeting.color.withOpacity(0.12),
            child:(meeting.profile != loginUser.mail) ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  meeting.type!.substring(0,1),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: getNotoSantBold(fontSize: 8, color: textColor),
                ),
                Container(
                  width: 29.0.w,
                  child: Text(
                    meeting.profile == loginUser.mail
                        ? meeting.title! : meeting.subject,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: getNotoSantRegular(fontSize: 8, color: textColor),
                  ),
                ),
              ],
            ) : Center(
              child: Text(
                meeting.title!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: getNotoSantRegular(fontSize: 8, color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setMonthCellBuilder(BuildContext context, MonthCellDetails details, CalendarController _controller) {
    var mid = details.visibleDates.length ~/ 2.toInt();
    var midDate = details.visibleDates[0].add(Duration(days: mid));

    if (details.appointments.isNotEmpty) {
      //Appointment bbb = details.appointments[0];
      return Container(
        height: details.bounds.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.0.h,
              child: Container(
                color: calendarLineColor.withOpacity(0.1),
              ),
            ),
            Expanded(
              child: Center(
                child: (details.date.month == midDate.month) ? Column(
                  children: [
                    SizedBox(height: 4.0.h,),
                    Text(
                      details.date.day.toString(),
                      style: TextStyle(
                          fontSize: 9.sp,
                          color: details.date.weekday == 7 ? Colors.red : details.date.weekday == 6 ? Colors.blue : Colors.black87,
                          fontFamily: 'Roboto'
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: details.appointments.map((data) => _buildData(context, data)).toList(),
                      ),
                    ),
                  ],
                ) :
                Column(
                  children: [
                    SizedBox(height: 4.0.h,),
                    Text(
                      details.date.day.toString(),
                      style: TextStyle(
                          fontSize: 9.sp,
                          color: calendarLineColor.withOpacity(0.6),
                          fontFamily: 'Roboto'
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: details.bounds.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.0.h,
              child: Container(
                color: calendarLineColor.withOpacity(0.1),
              ),
            ),
            Center(
              child: (details.date.month == midDate.month) ? Column(
                children: [
                  SizedBox(height: 4.0.h,),
                  Text(
                    details.date.day.toString(),
                    style: TextStyle(
                        fontSize: 9.sp,
                        color: details.date.weekday == 7 ? Colors.red : details.date.weekday == 6 ? Colors.blue : Colors.black87,
                        fontFamily: 'Roboto'
                    ),
                  ),
                ],
              ) :
              Column(
                children: [
                  SizedBox(height: 4.0.h,),
                  Text(
                    details.date.day.toString(),
                    style: TextStyle(
                        fontSize: 9.sp,
                        color: calendarLineColor.withOpacity(0.6),
                        fontFamily: 'Roboto'
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildData(BuildContext context, dynamic details) {
    UserModel loginUser = PublicFunction().getUserProviderSetting(context);
    final Appointment appointment = details;
    return Container(
      child: Stack(
        children: [
          appointment.profile == loginUser.mail
              ? Container(
            width: 4.0.w,
            color: appointment.color,
          )
              : Container(),
          Container(
            color: appointment.color.withOpacity(0.22),
            child: Center(
                child: Text(
                  appointment.subject,
                  style: TextStyle(
                    fontSize: 10.0.sp,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}



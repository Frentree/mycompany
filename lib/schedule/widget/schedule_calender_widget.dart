import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_picker_widget.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_theme.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleCalenderWidget {
  Widget setAppointMentBuilder(BuildContext context, CalendarAppointmentDetails details, CalendarController _controller) {
    final Appointment meeting = details.appointments.first;
    return Container(
      child: Stack(
        children: [
          meeting.subject == "이윤혁"
              ? Container(
                  width: 4.0.w,
                  color: meeting.color,
                )
              : Container(),
          Container(
            color: meeting.color.withOpacity(0.22),
            child: Center(
                child: Text(
              meeting.subject,
              style: TextStyle(
                fontSize: 10.0.sp,
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget setMonthCellBuilder(BuildContext context, MonthCellDetails details, CalendarController _controller) {
    //final Appointment meeting = details.appointments.first;
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 1.0.h,
            child: Container(
              color: calenderLineColor.withOpacity(0.1),
            ),
          ),
          Center(
            child: Text(
              details.date.day.toString(),
              style: TextStyle(
                fontSize: 9.sp
              ),
            ),
          ),
        ],
      ),
    );
  }
}

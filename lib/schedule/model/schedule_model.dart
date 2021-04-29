import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleModel extends CalendarDataSource {
  ScheduleModel(List<Appointment> source/*, List<CalendarResource> resourceColl*/) {
    appointments = source;
    //resources = resourceColl;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  List<Object> getResourceIds(int index) {
    return appointments![index].ids;
  }
}


import 'package:flutter/cupertino.dart';
import 'package:mycompany/schedule/function/calender_function.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class ScheduleFunctionReprository {
  CalenderFunction _calenderFunction = CalenderFunction();

  Future<List<Appointment>> getSheduleData({required String companyCode}) =>
      _calenderFunction.getSheduleData(companyCode);

  void getScheduleDetail({required CalendarTapDetails details,required BuildContext context}) =>
      _calenderFunction.getScheduleDetail(details, context);

  Future<DateTime> dateTimeSet({required DateTime date, required BuildContext context}) =>
      _calenderFunction.dateTimeSet(date, context);

}
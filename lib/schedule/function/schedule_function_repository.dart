

import 'package:flutter/cupertino.dart';
import 'package:mycompany/schedule/function/calender_function.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleFunctionReprository {
  CalenderFunction _calenderFunction = CalenderFunction();

  Future<List<Appointment>> getSheduleData({required String companyCode}) =>
      _calenderFunction.getSheduleData(companyCode);

  void getScheduleDetail({required CalendarTapDetails details,required BuildContext context}) =>
      _calenderFunction.getScheduleDetail(details, context);

}


import 'package:mycompany/schedule/function/calender_function.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleFunctionReprository {
  CalenderFunction _calenderFunction = CalenderFunction();

  Future<List<Appointment>> getSheduleData({String? companyCode}) =>
      _calenderFunction.getSheduleData(companyCode);

}
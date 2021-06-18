

import 'package:flutter/cupertino.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/schedule/function/calender_function.dart';
import 'package:mycompany/schedule/model/team_model.dart';
import 'package:mycompany/schedule/model/company_user_model.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class ScheduleFunctionReprository {
  CalenderFunction _calenderFunction = CalenderFunction();

  Future<List<Appointment>> getSheduleData({required String companyCode}) =>
      _calenderFunction.getSheduleData(companyCode);

  void getScheduleDetail({required CalendarTapDetails details,required BuildContext context}) =>
      _calenderFunction.getScheduleDetail(details, context);

  Future<DateTime> dateTimeSet({required DateTime date, required BuildContext context}) =>
      _calenderFunction.dateTimeSet(date, context);

  Future<List<TeamModel>> getTeam({required companyCode}) =>
      _calenderFunction.getTeam(companyCode);

  Future<List<EmployeeModel>> getEmployee({required companyCode}) =>
      _calenderFunction.getEmployee(companyCode);

}
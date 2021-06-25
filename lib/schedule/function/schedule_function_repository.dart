

import 'package:flutter/cupertino.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/schedule/function/calender_method.dart';
import 'package:mycompany/schedule/model/team_model.dart';
import 'package:mycompany/schedule/model/company_user_model.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class ScheduleFunctionReprository {
  CalenderMethod _calenderFunction = CalenderMethod();

  Future<DateTime> dateTimeSet({required DateTime date, required BuildContext context}) =>
      _calenderFunction.dateTimeSet(date, context);

  Future<List<TeamModel>> getTeam({required companyCode}) =>
      _calenderFunction.getTeam(companyCode);

  Future<List<EmployeeModel>> getEmployee({required companyCode}) =>
      _calenderFunction.getEmployee(companyCode);

  Future<List<EmployeeModel>> getEmployeeMy({required companyCode}) =>
      _calenderFunction.getEmployeeMy(companyCode);

}
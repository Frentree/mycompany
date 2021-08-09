import 'package:flutter/material.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/public_funtion.dart';


class PublicFunctionRepository {
  PublicFunction _function = PublicFunction();

  void mainNavigator({required BuildContext context,required Widget navigator, required bool isMove, required UserModel loginUser, required EmployeeModel employeeModel}) =>
      _function.mainNavigator(context, navigator, isMove, loginUser, employeeModel);

  Future<bool> onBackPressed({required BuildContext context}) =>
      _function.onBackPressed(context);


  Future<bool> onScheduleBackPressed({required BuildContext context}) =>
      _function.onScheduleBackPressed(context);
}
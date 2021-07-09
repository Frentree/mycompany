
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/schedule/view/schedule_registration_view.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:provider/provider.dart';

class PublicFunction {

  void mainNavigator(BuildContext context, Widget navigator, bool isMove){
    Navigator.push(context, MaterialPageRoute(builder: (context) => navigator));
  }

  Future<bool> onBackPressed(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleView(),));
    return true;
  }

  Future<bool> onScheduleBackPressed(BuildContext context) async {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ScheduleView(),), (route) => false);
    return true;
  }

  UserModel getUserProviderSetting(BuildContext context){
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

    return userInfoProvider.getUserData()!;
  }

  UserModel getUserProviderListenSetting(BuildContext context){
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);

    return userInfoProvider.getUserData()!;
  }

  EmployeeModel getEmployeeProviderSetting(BuildContext context){
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context, listen: false);

    return employeeInfoProvider.getEmployeeData()!;
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/function/sign_out_function.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/setting/model/setting_model.dart';
import 'package:mycompany/setting/view/setting_colleague_view.dart';
import 'package:mycompany/setting/view/setting_company_information_view.dart';
import 'package:mycompany/setting/view/setting_grade_view.dart';
import 'package:mycompany/setting/view/setting_my_information_view.dart';
import 'package:mycompany/setting/view/setting_my_vacation_view.dart';
import 'package:mycompany/setting/view/setting_position_view.dart';
import 'package:mycompany/setting/view/setting_team_view.dart';
import 'package:mycompany/setting/view/setting_unimplemented_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/setting/view/setting_vacation_view.dart';
import 'package:mycompany/setting/view/setting_wifi_view.dart';

List<SettingModel> getSettingMenu({required BuildContext context, required EmployeeModel employeeModel}) {
  List<SettingModel> list = [];

  list.add(SettingModel(munuName: "setting_menu_1".tr(), menuLavel: [0], menuIcon: Icon(Icons.contact_mail, color: workInsertColor, size: 30.0.h),
    widget: SettingMyInformationView()
  ));

  list.add(SettingModel(munuName: "setting_menu_11".tr(), menuLavel: [0], menuIcon: Icon(Icons.airport_shuttle_rounded, color: workInsertColor, size: 30.0.h),
      widget: SettingMyVacationView()
  ));

  list.add(SettingModel(munuName: "setting_menu_10".tr(), menuLavel: [0], menuIcon: Icon(Icons.home_work_outlined, color: workInsertColor, size: 30.0.h),
    widget: SettingCompanyInformationView(gradeLevel: employeeModel.level!,)
  ));

  if(getGradeChk(employeeModel: employeeModel, level: [6,8,9])){
    list.add(SettingModel(munuName: "setting_menu_9".tr(), menuLavel: [6,8,9], menuIcon: Icon(Icons.airplanemode_on_sharp, color: workInsertColor, size: 30.0.h),
        widget: SettingVacationView()
    ));
  }

  if(getGradeChk(employeeModel: employeeModel, level: [8,9])){
    list.add(SettingModel(munuName: "setting_menu_2".tr(), menuLavel: [0], menuIcon: Icon(Icons.supervised_user_circle_outlined, color: workInsertColor, size: 30.0.h),
        widget: SettingColleagueView()
    ));
  }

  list.add(SettingModel(munuName: "team_setting".tr(), menuLavel: [0], menuIcon: Icon(Icons.group, color: workInsertColor, size: 30.0.h),
      widget: SettingTeamView(gradeLevel: employeeModel.level!,)
  ));

  list.add(SettingModel(munuName: "setting_menu_3".tr(), menuLavel: [0], menuIcon: Icon(Icons.account_tree_outlined, color: workInsertColor, size: 30.0.h),
        widget: SettingPositionView(gradeLevel: employeeModel.level!,)
  ));


  if(getGradeChk(employeeModel: employeeModel, level: [8,9])){
    list.add(SettingModel(munuName: "grade_setting".tr(), menuLavel: [0], menuIcon: Icon(Icons.lock_open, color: workInsertColor, size: 30.0.h),
        widget: SettingGradeView()
    ));
  }
  // 와이파이 설정
  if(getGradeChk(employeeModel: employeeModel, level: [8,9])){
    list.add(SettingModel(munuName: "setting_menu_4".tr(), menuLavel: [0], menuIcon: Icon(Icons.wifi, color: workInsertColor, size: 30.0.h),
        widget: SettingWifiView()
    ));
  }
  /*
  // 앱버전
  list.add(SettingModel(munuName: "setting_menu_5".tr(), menuLavel: [0], menuIcon: Icon(Icons.perm_device_info, color: workInsertColor, size: 30.0.h),
      widget: SettingUnomplementedScreen()
  ));

  // 공지사항
  list.add(SettingModel(munuName: "setting_menu_6".tr(), menuLavel: [0], menuIcon: Icon(Icons.assignment_late_outlined, color: workInsertColor, size: 30.0.h),
      widget: SettingUnomplementedScreen()
  ));

  // 도움말
  list.add(SettingModel(munuName: "setting_menu_7".tr(), menuLavel: [0], menuIcon: Icon(Icons.wb_incandescent_outlined, color: workInsertColor, size: 30.0.h),
      widget: SettingUnomplementedScreen()
  ));
  */

  // 로그아웃
  list.add(SettingModel(munuName: "setting_menu_8".tr(), menuLavel: [0], menuIcon: Icon(Icons.logout, color: workInsertColor, size: 30.0.h),));

  return list;
}

bool getGradeChk({required EmployeeModel employeeModel, required List<int> level}){
  bool result = false;

  for(int i = 0; i < level.length; i++){
    if(employeeModel.level!.contains(level[i])){
      result = true;
      break;
    }
  }

  return result;
}

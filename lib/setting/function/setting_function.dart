import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/setting/model/setting_model.dart';
import 'package:mycompany/setting/view/setting_position_view.dart';
import 'package:mycompany/setting/view/setting_team_view.dart';
import 'package:mycompany/setting/view/setting_unimplemented_screen.dart';
import 'package:easy_localization/easy_localization.dart';

List<SettingModel> getSettingMenu({required BuildContext context}) {
  List<SettingModel> list = [];

  list.add(SettingModel(munuName: "setting_menu_1".tr(), menuLavel: 0, menuIcon: Icon(Icons.contact_mail, color: workInsertColor, size: 30.0.h),
    widget: SettingUnomplementedScreen()
  ));
  list.add(SettingModel(munuName: "setting_menu_9".tr(), menuLavel: 0, menuIcon: Icon(Icons.airplanemode_on_sharp, color: workInsertColor, size: 30.0.h),
      widget: SettingUnomplementedScreen()
  ));
  list.add(SettingModel(munuName: "setting_menu_2".tr(), menuLavel: 0, menuIcon: Icon(Icons.home_work_outlined, color: workInsertColor, size: 30.0.h),
      widget: SettingUnomplementedScreen()
  ));
  list.add(SettingModel(munuName: "team_setting".tr(), menuLavel: 0, menuIcon: Icon(Icons.group, color: workInsertColor, size: 30.0.h),
    widget: SettingTeamView()
  ));
  list.add(SettingModel(munuName: "setting_menu_3".tr(), menuLavel: 0, menuIcon: Icon(Icons.supervised_user_circle_outlined, color: workInsertColor, size: 30.0.h),
      widget: SettingPositionView()
  ));
  list.add(SettingModel(munuName: "setting_menu_4".tr(), menuLavel: 0, menuIcon: Icon(Icons.wifi, color: workInsertColor, size: 30.0.h),
      widget: SettingUnomplementedScreen()
  ));
  list.add(SettingModel(munuName: "setting_menu_5".tr(), menuLavel: 0, menuIcon: Icon(Icons.perm_device_info, color: workInsertColor, size: 30.0.h),
      widget: SettingUnomplementedScreen()
  ));
  list.add(SettingModel(munuName: "setting_menu_6".tr(), menuLavel: 0, menuIcon: Icon(Icons.assignment_late_outlined, color: workInsertColor, size: 30.0.h),
      widget: SettingUnomplementedScreen()
  ));
  list.add(SettingModel(munuName: "setting_menu_7".tr(), menuLavel: 0, menuIcon: Icon(Icons.wb_incandescent_outlined, color: workInsertColor, size: 30.0.h),
      widget: SettingUnomplementedScreen()
  ));
  list.add(SettingModel(munuName: "setting_menu_8".tr(), menuLavel: 0, menuIcon: Icon(Icons.logout, color: workInsertColor, size: 30.0.h),
      widget: SettingUnomplementedScreen()
  ));

  return list;
}

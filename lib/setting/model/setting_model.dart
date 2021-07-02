
import 'package:flutter/cupertino.dart';

class SettingModel{
  String munuName;
  int menuLavel;
  Icon menuIcon;
  Widget? widget;

  SettingModel({
   required this.munuName,
   required this.menuLavel,
   required this.menuIcon,
   this.widget,
  });

}
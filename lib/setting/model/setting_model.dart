import 'package:flutter/cupertino.dart';

class SettingModel {
  String munuName;
  List<int> menuLavel;
  Icon menuIcon;
  Widget? widget;
  Function? function;

  SettingModel({
    required this.munuName,
    required this.menuLavel,
    required this.menuIcon,
    this.widget,
    this.function,
  });
}

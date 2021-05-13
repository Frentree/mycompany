
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/schedule/view/schedule_registration_view.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';

class PublicFunction {

  void mainNavigator(BuildContext context, Widget navigator, bool isMove){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => navigator), (route) => isMove);
  }

  /*Future<bool> onBackPressed(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleView(),));
    return true;
  }*/
}
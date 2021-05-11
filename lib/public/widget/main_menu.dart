import 'package:flutter/material.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/schedule/view/schedule_registration_view.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:mycompany/schedule/widget/cirecular_button_item.dart';
import 'package:mycompany/schedule/widget/cirecular_button_menu.dart';

PublicFunctionReprository _reprository = PublicFunctionReprository();

Widget getMainCircularMenu({required BuildContext context,required String navigator}) {
  return CircularMenu(
      alignment: Alignment.bottomRight,
      radius: 170.0,
      toggleButtonColor: Colors.red,
      //startingAngleInRadian: 0.0,
      items: [
        CircularMenuItem(
            icon: Icons.home,
            color: navigator != 'home' ? Colors.blue : Colors.black38,
            onTap: () => navigator != 'home' ? _reprository.mainNavigator(context: context, navigator: ScheduleView(), isMove: false) : {}),
        CircularMenuItem(
            icon: Icons.schedule,
            color: navigator != 'schedule' ? Colors.blue : Colors.black38,
            onTap: () => navigator != 'schedule' ? _reprository.mainNavigator(context: context, navigator: ScheduleRegisrationView(), isMove: false) : {}),
        CircularMenuItem(
            icon: Icons.settings,
            color: navigator != 'star' ? Colors.blue : Colors.black38,
            onTap: () => navigator != 'schedule' ? _reprository.mainNavigator(context: context, navigator: ScheduleView(), isMove: false) : {}),
        CircularMenuItem(
            icon: Icons.star,
            color: navigator != 'good' ? Colors.blue : Colors.black38,
            onTap: () => navigator != 'schedule' ? _reprository.mainNavigator(context: context, navigator: ScheduleView(), isMove: false) : {}),
        CircularMenuItem(
            icon: Icons.settings,
            color: navigator != 'setting' ? Colors.blue : Colors.black38,
            onTap: () => navigator != 'setting' ?  _reprository.mainNavigator(context: context, navigator: ScheduleView(), isMove: false) : {}),
      ]);
}

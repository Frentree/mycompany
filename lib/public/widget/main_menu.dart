import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/approval/view/approval_main_view.dart';
import 'package:mycompany/inquiry/view/inquiry_view.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/schedule/view/schedule_registration_view.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:mycompany/schedule/widget/cirecular_button_item.dart';
import 'package:mycompany/schedule/widget/cirecular_button_menu.dart';

PublicFunctionRepository _reprository = PublicFunctionRepository();

Widget getMainCircularMenu({required BuildContext context,required String navigator, required bool isToggleChk}) {

  return CircularMenu(
    alignment: Alignment.bottomRight,
    radius: 170.0,
    toggleButtonColor: Colors.black,
    backgroundWidget: isToggleChk ? Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: blackColor.withOpacity(0.7),
    ) : Container(),
    toggleButtonBoxShadow: [BoxShadow(color: Colors.black)],
    toggleButtonOnPressed: (){
      isToggleChk = !isToggleChk;
    },
    //startingAngleInRadian: 0.0,
    items: [
      CircularMenuItem(
          icon: Icons.home,
          boxShadow: [BoxShadow(color: Colors.black)],
          badgeLabel: "gdgd",
          color: navigator != 'home' ? Colors.blue : Colors.black38,
          onTap: () => navigator != 'home' ? _reprository.mainNavigator(context: context, navigator: ScheduleView(), isMove: false) : {}),
      CircularMenuItem(
          icon: Icons.schedule,
          boxShadow: [BoxShadow(color: Colors.black)],
          color: navigator != 'schedule' ? Colors.blue : Colors.black38,
          onTap: () => navigator != 'schedule' ? _reprository.mainNavigator(context: context, navigator: ScheduleRegisrationView(), isMove: false) : {}),
      CircularMenuItem(
          icon: Icons.settings,
          boxShadow: [BoxShadow(color: Colors.black)],
          color: navigator != 'star' ? Colors.blue : Colors.black38,
          onTap: () => navigator != 'schedule' ? _reprository.mainNavigator(context: context, navigator: InquiryView(), isMove: false) : {}),
      CircularMenuItem(
          icon: Icons.star,
          boxShadow: [BoxShadow(color: Colors.black)],
          color: navigator != 'good' ? Colors.blue : Colors.black38,
          onTap: () => navigator != 'schedule' ? _reprository.mainNavigator(context: context, navigator: ScheduleView(), isMove: false) : {}),
      CircularMenuItem(
          icon: Icons.settings,
          boxShadow: [BoxShadow(color: Colors.black)],
          color: navigator != 'setting' ? Colors.blue : Colors.black38,
           onTap: () => navigator != 'setting' ?  _reprository.mainNavigator(context: context, navigator: ScheduleView(), isMove: false) : {}),
    ]);
}

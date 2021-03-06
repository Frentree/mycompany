import 'package:flutter/material.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/fcm/send_fcm.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/function/vacation/vacation.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:mycompany/schedule/widget/cirecular_button_item.dart';
import 'package:mycompany/schedule/widget/cirecular_button_menu.dart';
import 'package:mycompany/schedule/view/schedule_registration_view.dart';
import 'package:provider/provider.dart';

PublicFunctionRepository _reprository = PublicFunctionRepository();

Widget getMainCircularMenu(
    {required BuildContext context, required String navigator}) {

  UserInfoProvider _userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
  UserModel? _userModel = _userInfoProvider.getUserData();

  EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);
  EmployeeModel? loginEmployeeData = employeeInfoProvider.getEmployeeData();

  return CircularMenu(
      alignment: Alignment.bottomRight,
      radius: 170.0,
      toggleButtonColor: Colors.red,
      //startingAngleInRadian: 0.0,
      items: [
        CircularMenuItem(
            icon: Icons.home,
            color: navigator != 'home' ? Colors.blue : Colors.black38,
            onTap: () => navigator != 'home'
                ? _reprository.mainNavigator(
                    context: context, navigator: ScheduleView(), isMove: false)
                : {}),
        CircularMenuItem(
            icon: Icons.schedule,
            color: navigator != 'schedule' ? Colors.blue : Colors.black38,
            onTap: () => navigator != 'schedule'
                ? _reprository.mainNavigator(
                    context: context,
                    navigator: ScheduleRegisrationView(),
                    isMove: false)
                : {}),
        CircularMenuItem(
            icon: Icons.settings,
            color: navigator != 'star' ? Colors.blue : Colors.black38,
            onTap: () => navigator != 'schedule'
                ? _reprository.mainNavigator(
                    context: context, navigator: ScheduleView(), isMove: false)
                : {}),
        CircularMenuItem(
            icon: Icons.star,
            color: navigator != 'good' ? Colors.blue : Colors.black38,
            onTap: () {
              testForUsedVacation();
            }
            // onTap: ()  {
            //   UsedVacation('0S9YLBX',
            //       'jun@frentree.com', '2018.10.23', false);}
            // onTap: () => TotalVacation('2018.10.10', false, 0),
            // onTap: () => navigator != 'schedule'
            //     ? _reprository.mainNavigator(
            //         context: context, navigator: ScheduleView(), isMove: false)
            //     : {}

                ),
        CircularMenuItem(
            icon: Icons.settings,
            color: navigator != 'setting' ? Colors.blue : Colors.black38,
            onTap: () => navigator != 'setting'
                ? _reprository.mainNavigator(
                    context: context, navigator: ScheduleView(), isMove: false)
                : {}),
      ]);
}


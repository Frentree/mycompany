import 'package:flutter/material.dart';
import 'package:mycompany/attendance/view/attendance_dashboard_view.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/view/force_sign_out_view.dart';
import 'package:mycompany/login/view/join_company_success_view.dart';
import 'package:mycompany/login/view/reject_join_company_approval_view.dart';
import 'package:mycompany/login/view/sign_in_view.dart';
import 'package:mycompany/login/view/wait_join_company_approval_view.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/run_app/view/splash_view_blue.dart';
import 'package:mycompany/run_app/view/splash_view_white.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:provider/provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/view/user_type_select_view.dart';

class AuthView extends StatelessWidget {
  String? deviceToken;

  AuthView({this.deviceToken});


  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);

    UserModel? loginUserData = userInfoProvider.getUserData();
    EmployeeModel? loginEmployeeData = employeeInfoProvider.getEmployeeData();

    print("auth");

    if(loginUserData == null){
      return SignInView();
    }

    else if(loginUserData.token != deviceToken){
      return ForceSignOutView();
    }

    else{
      switch(loginUserData.state){
        case 0:
          return UserTypeSelectView();

        case 1:
          return WaitJoinCompanyApprovalView();

        case 2:
          return ScheduleView();
          /*if(loginEmployeeData == null){
            return JoinCompanySuccessView();
          }
          else{
            return AttendanceDashboardView();
          }*/

        case 3:
          return RejectJoinCompanyApprovalView();

        default:
          return SignInView();
      }
    }
  }
}
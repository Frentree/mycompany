import 'package:flutter/material.dart';
import 'package:mycompany/attendance/view/attendance_dashboard_view.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/view/force_sign_out_view.dart';
import 'package:mycompany/login/view/join_company_success_view.dart';
import 'package:mycompany/login/view/reject_join_company_approval_view.dart';
import 'package:mycompany/login/view/sign_in_view.dart';
import 'package:mycompany/login/view/wait_join_company_approval_view.dart';
import 'package:mycompany/public/provider/device_Info_provider.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/run_app/function/auto_check_on_work_function.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:provider/provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/view/user_type_select_view.dart';

class AuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);
    DeviceInfoProvider deviceInfoProvider = Provider.of<DeviceInfoProvider>(context);

    UserModel? loginUserData = userInfoProvider.getUserData();
    EmployeeModel? loginEmployeeData = employeeInfoProvider.getEmployeeData();
    String? deviceId = deviceInfoProvider.getDeviceId();


    if(loginUserData == null){
      return SignInView();
    }

    else{
      if(loginUserData.deviceId != deviceId){
        return ForceSignOutView();
      }
      switch(loginUserData.state){
        case 0:
          return UserTypeSelectView();

        case 1:
          if(loginUserData.companyCode == ""){
            return WaitJoinCompanyApprovalView();
          }
          else{
            return JoinCompanySuccessView();
          }

        case 2:
          autoCheckOnWorkFunction(employeeInfo: loginEmployeeData!);
          return ScheduleView();

        case 3:
          return RejectJoinCompanyApprovalView();

        default:
          return SignInView();
      }
    }
  }
}
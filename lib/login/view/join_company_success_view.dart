import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/run_app/view/splash_view_blue.dart';
import 'package:provider/provider.dart';

class JoinCompanySuccessView extends StatefulWidget {
  @override
  JoinCompanySuccessViewState createState() => JoinCompanySuccessViewState();
}

class JoinCompanySuccessViewState extends State<JoinCompanySuccessView> {
  @override
  Widget build(BuildContext context) {
    LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 47.0.w,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 159.0.h,
              ),
              child: Container(
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xff2093F0),
                  size: 44.0.w,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 19.0.h,
              ),
              child: SizedBox(
                  child: Text(
                    'joinCompanySuccessViewMainMessage'.tr(),
                    style: TextStyle(
                      fontSize: 22.0.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  )
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 8.0.h,
              ),
              child: SizedBox(
                  child: Text(
                    'joinCompanySuccessViewHintMessage'.tr(),
                    style: TextStyle(
                      fontSize: 13.0.sp,
                      fontWeight: fontWeight['Medium'],
                      color: hintTextColor,
                    ),
                    textAlign: TextAlign.center,
                  )
              ),
            ),
            loginElevatedButton(
              topPadding: 81.0.h,
              buttonName: 'startButton'.tr(),
              buttonAction: () async {
                UserModel loginUserData = await loginFirestoreRepository.readUserData(email: userInfoProvider.getUserData()!.email);
                EmployeeModel loginEmployeeData = await loginFirestoreRepository.readEmployeeData(companyId: loginUserData.companyId!, email: loginUserData.email);

                //UserInfoProvider 업데이트
                userInfoProvider.saveUserDataToPhone(userModel: loginUserData);

                //EmployeeInfoProvider 저장
                employeeInfoProvider.saveEmployeeDataToPhone(employeeModel: loginEmployeeData);

                pageMoveAndRemoveBackPage(context: context, pageName: SplashViewBlue());
              }
            )
          ],
        ),
      ),
    );
  }
}
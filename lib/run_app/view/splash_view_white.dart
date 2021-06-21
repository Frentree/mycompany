import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'dart:async';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:provider/provider.dart';
import 'package:mycompany/run_app/view/auth_view.dart';

class SplashViewWhite extends StatefulWidget {
  @override
  SplashViewWhiteState createState() => SplashViewWhiteState();
}

class SplashViewWhiteState extends State<SplashViewWhite> {
  String? deviceToken;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => pageMoveAndRemoveBackPage(context: context, pageName: AuthView(deviceToken: deviceToken,)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context, listen: false);

    userInfoProvider.loadUserDataToPhone();
    employeeInfoProvider.loadEmployeeDataToPhone();

    FirebaseMessaging.instance.getToken().then((value) => deviceToken = value);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 105.7.w,
              vertical: 340.7.h,
            ),
            child: SizedBox(
              width: 148.5.w,
              height: 74.53.h,
              child: SvgPicture.asset(
                'assets/images/logo_blue.svg',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/function/sign_out_function.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/login/view/join_company_view.dart';
import 'package:mycompany/login/view/create_company_view.dart';
import 'package:mycompany/login/view/sign_up_view.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';

class UserTypeSelectView extends StatefulWidget {
  @override
  UserTypeSelectViewState createState() => UserTypeSelectViewState();
}

class UserTypeSelectViewState extends State<UserTypeSelectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: 27.5.w,
              right: 27.5.w,
              top: 68.0.h,
            ),
            child: SizedBox(
              height: 26.0.h,
              child: IconButton(
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                ),
                iconSize: 24.0.h,
                splashRadius: 24.0.r,
                onPressed: () => SignOutFunction().signOutFunction(context: context),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                color: Color(0xff2093F0),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 47.0.w,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 82.0.h,
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
                      'userTypeSelectViewMainMessage'.tr(),
                      style: TextStyle(
                        fontSize: 21.0.sp,
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
                      'userTypeSelectViewHintMessage'.tr(),
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        fontWeight: fontWeight['Medium'],
                        color: hintTextColor,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),
                ),
                userTypeSelectButton(
                  context: context,
                  topPadding: 40.0.h,
                  buttonName: 'createCompanyButton'.tr(),
                  secondButtonName: 'typeManager'.tr(),
                  iconPath: 'assets/icons/icon_company.svg',
                  movePageName: CreateCompanyView(),
                ),
                userTypeSelectButton(
                  context: context,
                  topPadding: 11.0.h,
                  buttonName: 'joinCompanyButton'.tr(),
                  secondButtonName: 'typeEmployee'.tr(),
                  iconPath: 'assets/icons/icon_search.svg',
                  movePageName: JoinCompanyView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/view/join_company_view.dart';
import 'package:mycompany/login/view/create_company_view.dart';
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
                  'userTypeSelectViewMainMessage'.tr(),
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
    );
  }
}
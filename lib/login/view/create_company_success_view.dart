import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/view/join_company_view.dart';
import 'package:mycompany/login/view/create_company_view.dart';
import 'package:mycompany/login/view/sign_up_view.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';

class CreateCompanySuccessView extends StatefulWidget {
  @override
  CreateCompanySuccessViewState createState() => CreateCompanySuccessViewState();
}

class CreateCompanySuccessViewState extends State<CreateCompanySuccessView> {
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
                    'createCompanySuccessViewMainMessage'.tr(),
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
                    'createCompanySuccessViewHintMessage'.tr(),
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
              buttonName: "시작하기",
              buttonAction: () => pageMoveAndRemoveBackPage(context: context, pageName: SignUpView())
            )
          ],
        ),
      ),
    );
  }
}
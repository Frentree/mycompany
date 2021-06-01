import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';

class WaitJoinCompanyApprovalView extends StatefulWidget {
  @override
  WaitJoinCompanyApprovalViewState createState() => WaitJoinCompanyApprovalViewState();
}

class WaitJoinCompanyApprovalViewState extends State<WaitJoinCompanyApprovalView> {
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
                  color: Color(0xff9C9C9C),
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
                  'waitJoinCompanyApprovalViewMainMessage'.tr(),
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
                  'waitJoinCompanyApprovalViewHintMessage'.tr(),
                  style: TextStyle(
                    fontSize: 13.0.sp,
                    fontWeight: fontWeight['Medium'],
                    color: hintTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            loginElevatedButton(
              topPadding: 81.0.h,
              buttonName: 'closeAppButton'.tr(),
              buttonAction: () => {SystemNavigator.pop()}
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:provider/provider.dart';

class RejectJoinCompanyApprovalView extends StatefulWidget {
  @override
  RejectJoinCompanyApprovalViewState createState() => RejectJoinCompanyApprovalViewState();
}

class RejectJoinCompanyApprovalViewState extends State<RejectJoinCompanyApprovalView> {
  LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);
    UserModel userModel = userInfoProvider.getUserData()!;

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
                  Icons.cancel,
                  color: Color(0xffDC0101),
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
                    'rejectJoinCompanyApprovalViewMainMessage'.tr(),
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
                  'rejectJoinCompanyApprovalViewHintMessage'.tr(),
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
              buttonName: 'rejoinButton'.tr(),
              buttonAction: () async {
                userModel.state = 0;
                await loginFirestoreRepository.updateUserData(userModel: userModel); //토큰값 DB에 업데이트
                userInfoProvider.saveUserDataToPhone(userModel: userModel);
              }
            )
          ],
        ),
      ),
    );
  }
}
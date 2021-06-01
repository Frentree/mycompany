import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/view/sign_in_view.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'dart:async';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ForceSignOutView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    Future.delayed(Duration.zero, (){
      loginDialogWidget(
        context: context,
        message: "다른 기기에서 로그인하여, 자동 로그아웃 됩니다.",
        actions: [
          loginDialogConfirmButton(
            buttonName: 'dialogConfirm'.tr(),
            buttonAction: () async {
              await userInfoProvider.deleteUserDataToPhone();
              pageMoveAndRemoveBackPage(context: context, pageName: SignInView());
            }
          ),
        ],
      );
    });

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
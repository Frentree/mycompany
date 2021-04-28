import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/function/sign_in_function.dart';
import 'package:mycompany/login/style/loing_style_repository.dart';
import 'package:mycompany/login/widget/login_widget_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/run_app/view/splash_view_blue.dart';

class SignUpView extends StatefulWidget {
  @override
  SignUpViewState createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  LoginStyleRepository _loginStyleRepository = LoginStyleRepository();
  LoginWidgetRepository _loginWidgetRepository = LoginWidgetRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 69.0.h,
              left: 29.w,
            ),
            child: SizedBox(
              width: 192.0.w,
              height: 24.0.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                    ),
                    iconSize: 24.0.h,
                    splashRadius: 24.0.r,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    color: Color(0xff2093F0),
                  ),
                  Text(
                    'sign_up'.tr(),
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 47.0.h,
              left: 27.5.w,
              right: 27.5.w,
            ),
            child: SizedBox(
              width: 305.0.w,
              height: 40.0.h,
              child: TextFormField(
                decoration: _loginStyleRepository.textFormDecoration(hintText: 'name'.tr()),
                style: TextStyle(
                  fontSize: 13.0.sp,
                  color: textColor,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 12.0.h,
              left: 27.5.w,
              right: 27.5.w,
            ),
            child: SizedBox(
              width: 305.0.w,
              height: 40.0.h,
              child: TextFormField(
                decoration: _loginStyleRepository.textFormDecoration(hintText: 'email'.tr()),
                style: TextStyle(
                  fontSize: 13.0.sp,
                  color: textColor,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 12.0.h,
              left: 27.5.w,
              right: 27.5.w,
            ),
            child: SizedBox(
              width: 305.0.w,
              height: 40.0.h,
              child: TextFormField(
                decoration: _loginStyleRepository.textFormDecoration(hintText: 'password'.tr()),
                style: TextStyle(
                  fontSize: 13.0.sp,
                  color: textColor,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 12.0.h,
              left: 27.5.w,
              right: 27.5.w,
            ),
            child: SizedBox(
              width: 305.0.w,
              height: 40.0.h,
              child: TextFormField(
                decoration: _loginStyleRepository.textFormDecoration(hintText: 'password_confirm'.tr()),
                style: TextStyle(
                  fontSize: 13.0.sp,
                  color: textColor,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 12.0.h,
              left: 27.5.w,
              right: 27.5.w,
            ),
            child: SizedBox(
              width: 305.0.w,
              height: 40.0.h,
              child: TextFormField(
                decoration: _loginStyleRepository.textFormDecoration(hintText: 'birthday_hint'.tr()),
                style: TextStyle(
                  fontSize: 13.0.sp,
                  color: textColor,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 12.0.h,
              left: 27.5.w,
              right: 27.5.w,
            ),
            child: SizedBox(
              width: 305.0.w,
              height: 40.0.h,
              child: TextFormField(
                decoration: _loginStyleRepository.textFormDecoration(hintText: 'phone'.tr()),
                style: TextStyle(
                  fontSize: 13.0.sp,
                  color: textColor,
                ),
              ),
            ),
          ),
          _loginWidgetRepository.elevatedButton(topPadding: 20.0.h, buttonName: 'sign_up'.tr(), buttonAction: () => SignInFunction().page(context)),
        ],
      ),
    );
  }
}
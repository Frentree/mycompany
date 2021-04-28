import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/function/sign_in_function.dart';
import 'package:mycompany/login/style/loing_style_repository.dart';
import 'package:mycompany/login/widget/login_widget_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/run_app/view/splash_view_blue.dart';

class SignInView extends StatefulWidget {
  @override
  SignInViewState createState() => SignInViewState();
}

class SignInViewState extends State<SignInView> {
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
            alignment: Alignment.centerRight,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 42.0.h,
              right: 28.w,
            ),
            child: GestureDetector(
              child: Container(
                child: SizedBox(
                  height: 19.0.h,
                  child: Text(
                    "Release 1.0.1",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.0.sp,
                      color: Color(0xff585858),
                    ),
                  )
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SplashViewBlue()));
              },
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 49.0.h,
              left: 106.2.w,
            ),
            child: GestureDetector(
              child: Container(
                child: SizedBox(
                  width: 148.5.w,
                  height: 74.53.h,
                  child: Image.asset('assets/images/logo_blue.png'),
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SplashViewBlue()));
              },
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 60.7.h,
              left: 27.5.w,
            ),
            child: Container(
              child: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w700,
                  color: titleTextColor,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 21.0.h,
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
          _loginWidgetRepository.elevatedButton(topPadding: 20.0.h, buttonName: 'sign_in'.tr(), buttonAction: () => SignInFunction().page(context)),
          _loginWidgetRepository.outlinedButton(topPadding: 12.0.h, buttonName: 'sign_up'.tr(), buttonAction: () => SignInFunction().page(context)),
          Container(
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.only(
              top: 20.0.h,
              left: 27.5.w,
              right: 27.5.w,
            ),
            child: Row(
              children: [
                Container(
                  width: 186.0.w,
                  height: 19.0.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16.0.w,
                        height: 19.0.h,
                        child: Image.asset('assets/icons/icon_password.png'),
                      ),
                      SizedBox(
                        width: 8.0.w,
                      ),
                      Text(
                        'forgot_password'.tr(),
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: hintTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 34.4.w,
                ),
                SizedBox(
                  width: 84.6.w,
                  height: 19.0.h,
                  child: TextButton(
                    onPressed: (){},
                    child: Text(
                      'find_password'.tr(),
                    ),
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        color: titleTextColor,
                        fontSize: 13.0.sp,
                      ),
                      padding: EdgeInsets.all(0.0)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
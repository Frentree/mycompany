import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/login/function/login_function_repository.dart';
import 'package:mycompany/login/function/sign_in_function.dart';
import 'package:mycompany/login/style/loing_style_repository.dart';
import 'package:mycompany/login/widget/login_widget_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/run_app/view/splash_view_blue.dart';
import 'package:mycompany/public/word/app_version.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';

class SignInView extends StatefulWidget {
  @override
  SignInViewState createState() => SignInViewState();
}

class SignInViewState extends State<SignInView> {
  LoginStyleRepository _loginStyleRepository = LoginStyleRepository();
  LoginWidgetRepository _loginWidgetRepository = LoginWidgetRepository();
  LoginFunctionRepository _loginFunctionRepository = LoginFunctionRepository();

  late TextEditingController _passwordController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 27.5.w,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(
                top: 42.0.h,
              ),
              child: SizedBox(
                  height: 19.0.h,
                  child: Text(
                    "Release ${APP_VERSION}",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.0.sp,
                      color: Color(0xff585858),
                    ),
                  )
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 49.0.h,
              ),
              child: GestureDetector(
                child: SvgPicture.asset(
                  'assets/images/logo_blue.svg',
                  width: 148.5.w,
                  height: 74.53.h,
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleView()));
                },
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: 60.7.h,
              ),
              child: Container(
                child: Text(
                  'sign_in'.tr(),
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
              padding: EdgeInsets.only(
                top: 21.0.h,
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
              ),
              child: SizedBox(
                width: 305.0.w,
                height: 40.0.h,
                child: TextFormField(
                  controller: _passwordController,
                  decoration: _loginStyleRepository.textFormDecoration(
                    hintText: 'password'.tr(),
                    suffixIcon: _loginWidgetRepository.textFormClearButton(textEditingController: _passwordController),
                  ),
                  style: TextStyle(
                    fontSize: 13.0.sp,
                    color: textColor,
                  ),
                ),
              ),
            ),
            _loginWidgetRepository.elevatedButton(topPadding: 20.0.h, buttonName: 'sign_in'.tr(), buttonAction: () => _loginFunctionRepository.signInFunction(context: context, email: "", password: "")),
            _loginWidgetRepository.outlinedButton(topPadding: 12.0.h, buttonName: 'sign_up'.tr(), /*buttonAction: () => SignInFunction().page(context)*/),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: 20.0.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 19.0.h,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/icon_password.svg',
                          width: 16.0.w,
                          height: 19.0.h,
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
      ),
    );
  }
}
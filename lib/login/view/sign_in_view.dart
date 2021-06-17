import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/login/function/login_function_repository.dart';
import 'package:mycompany/login/view/sign_up_view.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_text_form_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/word/app_version.dart';

class SignInView extends StatefulWidget {
  @override
  SignInViewState createState() => SignInViewState();
}

class SignInViewState extends State<SignInView> {
  LoginFunctionRepository _loginFunctionRepository = LoginFunctionRepository();

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  ValueNotifier<List<bool>> isFormValid =
      ValueNotifier<List<bool>>([false, false]);

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                )),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 49.0.h,
              ),
              child: SizedBox(
                width: 148.5.w,
                height: 74.53.h,
                child: SvgPicture.asset(
                  'assets/images/logo_blue.svg',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 60.7.h,
              ),
              child: Container(
                child: Text(
                  'signIn'.tr(),
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w700,
                    color: titleTextColor,
                  ),
                ),
              ),
            ),
            signInViewTextFormField(
              topPadding: 21.0.h,
              textEditingController: _emailTextController,
              type: "email",
              valueNotifier: isFormValid,
              index: 0,
            ),
            signInViewTextFormField(
              topPadding: 12.0.h,
              textEditingController: _passwordTextController,
              type: "password",
              obscureText: true,
              valueNotifier: isFormValid,
              index: 1,
            ),
            ValueListenableBuilder(
              valueListenable: isFormValid,
              builder: (BuildContext context, List<bool> value, Widget? child) {
                return loginElevatedButton(
                  topPadding: 20.0.h,
                  buttonName: 'signIn'.tr(),
                  buttonAction: value.contains(false) ? null : () {
                    FocusScope.of(context).unfocus();
                    _loginFunctionRepository.signInFunction(
                      context: context,
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );
                  },
                );
              },
            ),
            loginOutlinedButton(
              topPadding: 12.0.h,
              buttonName: 'signUp'.tr(),
              buttonAction: () {
                _emailTextController.clear();
                _passwordTextController.clear();
                pageMove(
                  context: context,
                  pageName: SignUpView(),
                );
              },
            ),
            Container(
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
                          'forgotPassword'.tr(),
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
                      onPressed: () {},
                      child: Text(
                        'findPassword'.tr(),
                      ),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          color: titleTextColor,
                          fontSize: 13.0.sp,
                        ),
                        padding: EdgeInsets.all(0.0),
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

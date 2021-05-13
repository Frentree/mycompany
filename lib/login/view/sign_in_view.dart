import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/login/function/login_function_repository.dart';
import 'package:mycompany/login/style/decoration_style.dart';
import 'package:mycompany/login/view/sign_up_view.dart';
import 'package:mycompany/login/widget/button_widget.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/word/app_version.dart';
import 'package:mycompany/run_app/view/splash_view_blue.dart';


/*
class SignInView extends StatefulWidget {
  @override
  SignInViewState createState() => SignInViewState();
}

class SignInViewState extends State<SignInView> {
  LoginFunctionRepository _loginFunctionRepository = LoginFunctionRepository();
  PublicFunctionRepository _publicFunctionRepository = PublicFunctionRepository();

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SplashViewBlue()));
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
                  'signIn'.tr(),
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
                  decoration: loginTextFormDecoration(hintText: 'email'.tr()),
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
                  decoration: loginTextFormDecoration(
                    hintText: 'password'.tr(),
                    suffixIcon: textFormClearButton(textEditingController: _passwordController),
                  ),
                  style: TextStyle(
                    fontSize: 13.0.sp,
                    color: textColor,
                  ),
                ),
              ),
            ),
            elevatedButton(topPadding: 20.0.h, buttonName: 'signIn'.tr(), buttonAction: () => _loginFunctionRepository.signInFunction(context: context, email: "min@naver.com", password: "fren1212")),
            outlinedButton(topPadding: 12.0.h, buttonName: 'signUp'.tr(), buttonAction: () => _publicFunctionRepository.pageMove(context: context, pageName: SignUpView())),
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
                      onPressed: (){},
                      child: Text(
                        'findPassword'.tr(),
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
}*/

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var inputText = "";
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              maxLength: 60,
              textCapitalization: TextCapitalization.words,
              onChanged: (text) {
                setState(() {
                  inputText = text;
                });
              },
              decoration: InputDecoration(
                  filled: true,
                  prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: (){},),
                  suffixIcon: hidingIcon()),
            ),
          ],
        ),
      ),
    );
  }

  Widget? hidingIcon() {
    if (inputText.length > 0) {
      return IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.red,
          ),
          splashColor: Colors.redAccent,
          onPressed: () {
            setState(() {
              _controller.clear();
              inputText = "";
            });
          });
    } else {
      return null;
    }
  }
}

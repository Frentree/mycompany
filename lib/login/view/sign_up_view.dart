import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_text_form_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/function/login_function_repository.dart';
import 'package:mycompany/login/view/sign_in_view.dart';

class SignUpView extends StatefulWidget {
  @override
  SignUpViewState createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  LoginFunctionRepository _loginFunctionRepository = LoginFunctionRepository();

  GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _confirmPasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _birthdayFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();

  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController = TextEditingController();
  TextEditingController _birthdayTextController = MaskedTextController(mask: '0000.00.00');
  TextEditingController _phoneTextController = MaskedTextController(mask: '000-0000-0000');

  ValueNotifier<List<bool>> isFormValid = ValueNotifier<List<bool>>([false, false, false, false, true, true]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: 27.5.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 68.0.h,
                ),
                child: SizedBox(
                  height: 26.0.h,
                  child: Row(
                    children: [
                      IconButton(
                        constraints: BoxConstraints(),
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                        ),
                        iconSize: 24.0.h,
                        splashRadius: 24.0.r,
                        onPressed: () => backPage(context: context),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        color: Color(0xff2093F0),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'signUp'.tr(),
                            style: TextStyle(
                              fontSize: 18.0.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: StreamBuilder<Object>(
                    stream: null,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          signUpViewValidationForm(
                            index: 0,
                            context: context,
                            topPadding: 47.0.h,
                            formKey: _nameFormKey,
                            textEditingController: _nameTextController,
                            type: "name",
                          ),
                          signUpViewValidationForm(
                            index: 1,
                            context: context,
                            topPadding: 12.0.h,
                            formKey: _emailFormKey,
                            textEditingController: _emailTextController,
                            type: "email",
                          ),
                          signUpViewValidationForm(
                            index: 2,
                            context: context,
                            topPadding: 12.0.h,
                            formKey: _passwordFormKey,
                            textEditingController: _passwordTextController,
                            comparisonFormKey: _confirmPasswordFormKey,
                            type: "password",
                            maxLength: 20,
                            obscureText: true,
                          ),
                          signUpViewValidationForm(
                            index: 3,
                            context: context,
                            topPadding: 12.0.h,
                            formKey: _confirmPasswordFormKey,
                            textEditingController: _confirmPasswordTextController,
                            type: "confirmPassword",
                            comparisonValue: _passwordTextController,
                            obscureText: true,
                          ),
                          signUpViewValidationForm(
                            index: 4,
                            context: context,
                            topPadding: 12.0.h,
                            formKey: _birthdayFormKey,
                            textEditingController: _birthdayTextController,
                            type: "birthday",
                            hintText: 'birthdayHint'.tr(),
                          ),
                          signUpViewValidationForm(
                            index: 5,
                            context: context,
                            topPadding: 12.0.h,
                            formKey: _phoneFormKey,
                            textEditingController: _phoneTextController,
                            type: "phone",
                          ),
                          ValueListenableBuilder(
                            valueListenable: isFormValid,
                            builder: (BuildContext context, List<bool> value, Widget? child){
                              return loginElevatedButton(
                                topPadding: 20.0.h,
                                buttonName: 'signUp'.tr(),
                                buttonAction: value.contains(false) ? null : () async {
                                  bool _isSignUpSuccess = await _loginFunctionRepository.signUpFunction(
                                    context: context,
                                    name: _nameTextController.text.replaceAll(" ", ""),
                                    email: _emailTextController.text.replaceAll(" ", ""),
                                    password: _passwordTextController.text.replaceAll(" ", ""),
                                    birthday: _birthdayTextController.text != "" ? _birthdayTextController.text.replaceAll(".", "") : "",
                                    phone: _phoneTextController.text,
                                  );
                                  if(_isSignUpSuccess){
                                    backPage(context: context);
                                  }
                                }
                              );
                            },
                          ),
                        ],
                      );
                    }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

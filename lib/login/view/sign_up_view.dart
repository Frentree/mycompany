import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/function/sign_in_function.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/button_widget.dart';
import 'package:mycompany/login/widget/login_text_form_widget.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/function/login_function_repository.dart';

class SignUpView extends StatefulWidget {
  @override
  SignUpViewState createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  LoginFunctionRepository _loginFunctionRepository = LoginFunctionRepository();
  PublicFunctionRepository _publicFunctionRepository = PublicFunctionRepository();

  final _nameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _confirmPasswordFormKey = GlobalKey<FormState>();
  final _birthdayFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();

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
      body: Container(
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
                width: 186.0.w,
                height: 26.0.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                      iconSize: 24.0.h,
                      splashRadius: 24.0.r,
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                    ),
                    Text(
                      'signUp'.tr(),
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
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: StreamBuilder<Object>(
                  stream: null,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        loginValidationForm(
                          index: 0,
                          context: context,
                          topPadding: 47.0.h,
                          formKey: _nameFormKey,
                          textEditingController: _nameTextController,
                          type: "name",
                        ),
                        loginValidationForm(
                          index: 1,
                          context: context,
                          topPadding: 12.0.h,
                          formKey: _emailFormKey,
                          textEditingController: _emailTextController,
                          type: "email",
                        ),
                        loginValidationForm(
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
                        loginValidationForm(
                          index: 3,
                          context: context,
                          topPadding: 12.0.h,
                          formKey: _confirmPasswordFormKey,
                          textEditingController: _confirmPasswordTextController,
                          type: "confirmPassword",
                          comparisonValue: _passwordTextController,
                          obscureText: true,
                        ),
                        loginValidationForm(
                          index: 4,
                          context: context,
                          topPadding: 12.0.h,
                          formKey: _birthdayFormKey,
                          textEditingController: _birthdayTextController,
                          type: "birthday",
                          hintText: 'birthdayHint'.tr(),
                        ),
                        loginValidationForm(
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
                            return elevatedButton(
                                topPadding: 20.0.h,
                                buttonName: 'signUp'.tr(),
                                buttonAction: value.contains(false) ? null : () async {
                                  await _loginFunctionRepository.signUpFunction(
                                    context: context,
                                    name: _nameTextController.text.replaceAll(" ", ""),
                                    email: _emailTextController.text.replaceAll(" ", ""),
                                    password: _passwordTextController.text.replaceAll(" ", ""),
                                    birthday: _birthdayTextController.text != "" ? _birthdayTextController.text.replaceAll(".", "") : "",
                                    phone: _phoneTextController.text,
                                  );
                                  Navigator.pop(context);
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
    );
  }
}

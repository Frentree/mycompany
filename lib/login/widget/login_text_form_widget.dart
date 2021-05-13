import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/function/login_function_repository.dart';
import 'package:mycompany/login/style/decoration_style.dart';
import 'package:mycompany/login/view/sign_up_view.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/button_widget.dart';

Container loginValidationForm({required index, required BuildContext context, required double topPadding, required GlobalKey<FormState> formKey, required TextEditingController textEditingController, required String type, String? hintText, int? maxLength, TextEditingController? comparisonValue, GlobalKey<FormState>? comparisonFormKey,  bool? obscureText}) {
  LoginFunctionRepository _loginFunctionRepository = LoginFunctionRepository();
  String errorMessage = "";

  return Container(
    padding: EdgeInsets.only(
      top: topPadding,
    ),
    child: Container(
      child: StatefulBuilder(
        builder: (context, setState) {
          SignUpViewState parent = context.findAncestorStateOfType<SignUpViewState>()!;
          return SizedBox(
            width: 305.0.w,
            child: Form(
              onChanged: () {
                formKey.currentState!.validate();
                if(type == "birthday" || type == "phone"){
                  if(textEditingController.text == "" || errorMessage == ""){
                    parent.isFormValid.value = List.from(parent.isFormValid.value)
                      ..replaceRange(index, index + 1, [true]);
                    setState((){
                      errorMessage = "";
                    });
                  }
                  else{
                    parent.isFormValid.value = List.from(parent.isFormValid.value)
                      ..replaceRange(index, index + 1, [false]);
                  }
                }
                else{
                  if(type == "password"){
                    comparisonFormKey!.currentState!.validate();
                  }
                  if (errorMessage != "") {
                    parent.isFormValid.value = List.from(parent.isFormValid.value)
                      ..replaceRange(index, index + 1, [false]);
                  }
                  else {
                    parent.isFormValid.value = List.from(parent.isFormValid.value)
                      ..replaceRange(index, index + 1, [true]);
                  }
                }
              },
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.0.w),
                    child: Text(
                      errorMessage == "" ? type.tr() : errorMessage,
                      style: TextStyle(
                        fontSize: 10.0.sp,
                        color: errorMessage == "" ? Colors.black : Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0.h,
                    child: TextFormField(
                      obscureText: obscureText == null ? false : obscureText,
                      maxLength: maxLength,
                      controller: textEditingController,
                      validator: ((value) {
                        if (_loginFunctionRepository.formValidationFunction(
                            type: type,
                            value: value!,
                            value2: comparisonValue) != null) {
                          setState(() {
                            errorMessage =
                            _loginFunctionRepository.formValidationFunction(
                                type: type,
                                value: value,
                                value2: comparisonValue)!;
                          });
                        }
                        else {
                          setState(() {
                            errorMessage = "";
                          });
                        }
                      }),
                      decoration: loginTextFormDecoration(
                          hintText: hintText == null ? type.tr() : hintText,
                          suffixIcon: textEditingController.text == ""
                              ? null
                              : textFormClearButton(
                              textEditingController: textEditingController)),
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/function/login_function_repository.dart';
import 'package:mycompany/login/style/decoration_style.dart';
import 'package:mycompany/login/view/sign_up_view.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';

Container signInViewTextFormField({
  required double topPadding,
  required TextEditingController textEditingController,
  required String type,
  bool? obscureText,
  required ValueNotifier<List<bool>> valueNotifier,
  required int index,
}) {
  return Container(
    padding: EdgeInsets.only(
      top: topPadding,
    ),
    child: SizedBox(
      width: 305.0.w,
      height: 40.0.h,
      child: TextFormField(
        obscureText: obscureText == null ? false : obscureText,
        controller: textEditingController,
        decoration: loginTextFormRoundBorderDecoration(
          hintText: type.tr(),
          suffixIcon: textEditingController.text == ""
              ? null
              : textFormClearButton(
                  textEditingController: textEditingController,
                ),
        ),
        style: TextStyle(
          fontSize: 14.0.sp,
          color: textColor,
        ),
        onChanged: (value) {
          if (value.length == 0) {
            valueNotifier.value = List.from(valueNotifier.value)
              ..replaceRange(index, index + 1, [false]);
          } else {
            valueNotifier.value = List.from(valueNotifier.value)
              ..replaceRange(index, index + 1, [true]);
          }
        },
      ),
    ),
  );
}

Container companyViewTextFormField({
  required double topPadding,
  required TextEditingController textEditingController,
  required String hintText,
  Widget? suffixIcon,
  bool? readOnly,
  VoidCallback? onTab,
  ValueNotifier<List<bool>>? valueNotifier,
  int? index,
}) {
  return Container(
    padding: EdgeInsets.only(
      top: topPadding,
    ),
    child: SizedBox(
      width: 305.0.w,
      height: 40.0.h,
      child: TextFormField(
        readOnly: readOnly == null ? false : readOnly,
        controller: textEditingController,
        decoration: loginTextFormUnderlineBorderDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
        ),
        style: TextStyle(
          fontSize: 14.0.sp,
          color: textColor,
        ),
        onTap: onTab,
        onChanged: valueNotifier != null
            ? (value) {
                if (value.length == 0) {
                  valueNotifier.value = List.from(valueNotifier.value)
                    ..replaceRange(index!, index + 1, [false]);
                } else {
                  valueNotifier.value = List.from(valueNotifier.value)
                    ..replaceRange(index!, index + 1, [true]);
                }
              }
            : null,
      ),
    ),
  );
}

Container signUpViewValidationForm({
  required int index,
  required BuildContext context,
  required double topPadding,
  required GlobalKey<FormState> formKey,
  required TextEditingController textEditingController,
  required String type,
  String? hintText,
  int? maxLength,
  TextEditingController? comparisonValue,
  GlobalKey<FormState>? comparisonFormKey,
  bool? obscureText,
}) {
  LoginFunctionRepository _loginFunctionRepository = LoginFunctionRepository();
  String errorMessage = "";

  return Container(
    padding: EdgeInsets.only(
      top: topPadding,
    ),
    child: Container(
      child: StatefulBuilder(builder: (context, setState) {
        SignUpViewState parent = context.findAncestorStateOfType<SignUpViewState>()!;
        return SizedBox(
          width: 305.0.w,
          child: Form(
            onChanged: () {
              formKey.currentState!.validate();
              if (type == "birthday" || type == "phone") {
                if (textEditingController.text == "" || errorMessage == "") {
                  parent.isFormValid.value = List.from(parent.isFormValid.value)
                    ..replaceRange(index, index + 1, [true]);
                  setState(() {
                    errorMessage = "";
                  });
                } else {
                  parent.isFormValid.value = List.from(parent.isFormValid.value)
                    ..replaceRange(index, index + 1, [false]);
                }
              } else {
                if (type == "password") {
                  comparisonFormKey!.currentState!.validate();
                }
                if (errorMessage != "") {
                  parent.isFormValid.value = List.from(parent.isFormValid.value)
                    ..replaceRange(index, index + 1, [false]);
                } else {
                  parent.isFormValid.value = List.from(parent.isFormValid.value)
                    ..replaceRange(index, index + 1, [true]);
                }
              }
            },
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            value2: comparisonValue,
                          ) !=
                          null) {
                        setState(() {
                          errorMessage =
                              _loginFunctionRepository.formValidationFunction(
                            type: type,
                            value: value,
                            value2: comparisonValue,
                          )!;
                        });
                      } else {
                        setState(() {
                          errorMessage = "";
                        });
                      }
                    }),
                    decoration: loginTextFormRoundBorderDecoration(
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
                Visibility(
                  visible: errorMessage != "",
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.0.w),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        color: errorTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
  );
}

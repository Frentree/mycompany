import 'package:flutter/material.dart';
import 'package:mycompany/login/function/sign_in_function.dart';
import 'package:mycompany/login/function/form_validation_function.dart';
import 'package:mycompany/login/function/sign_up_function.dart';
import 'package:mycompany/login/model/user_model.dart';

class LoginFunctionRepository {
  SignInFunction _signInFunction = SignInFunction();
  SignUpFunction _signUpFunction = SignUpFunction();
  FormValidationFunction _formValidationFunction = FormValidationFunction();

  Future<void> signInFunction({
    required BuildContext context,
    required String email,
    required String password,
  }) =>
      _signInFunction.signInFunction(
        context: context,
        email: email,
        password: password,
      );

  Future<void> signUpFunction({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    String ? birthday,
    String ? phone,
  }) => _signUpFunction.signUpFunction(context: context, name: name, email: email, password: password, birthday: birthday, phone: phone);

  String? formValidationFunction({String? type, required String value, TextEditingController? value2}) => _formValidationFunction.formValidationFunction(type: type, value: value, value2: value2);
}

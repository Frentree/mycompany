import 'package:flutter/material.dart';
import 'package:mycompany/login/function/sign_in_function.dart';

class LoginFunctionRepository {
  SignInFunction _signInFunction = SignInFunction();

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
}

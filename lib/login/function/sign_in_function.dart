import 'package:flutter/material.dart';
import 'package:mycompany/login/view/sign_up_view.dart';
import 'package:mycompany/run_app/view/splash_view_blue.dart';

class SignInFunction {
  void page(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpView()));
  }
}

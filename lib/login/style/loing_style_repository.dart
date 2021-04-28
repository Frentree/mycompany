import 'package:flutter/material.dart';
import 'package:mycompany/login/style/decoration_style.dart';

class LoginStyleRepository {
  DecorationStyle _decorationStyle = DecorationStyle();

  InputDecoration textFormDecoration({String? hintText, Widget? suffixIcon}) =>
      _decorationStyle.textFormDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
      );
}

import 'package:flutter/cupertino.dart';
import 'package:mycompany/public/function/public_funtion.dart';

class PublicFunctionReprository {
  PublicFunction _function = PublicFunction();

  void mainNavigator({required BuildContext context,required Widget navigator, required isMove}) =>
      _function.mainNavigator(context, navigator, isMove);

  Future<bool> onBackPressed({required BuildContext context}) =>
      _function.onBackPressed(context);
}
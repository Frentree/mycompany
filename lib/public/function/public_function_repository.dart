import 'package:flutter/material.dart';
import 'package:mycompany/public/function/public_funtion.dart';


class PublicFunctionRepository {
  PublicFunction _function = PublicFunction();

  void mainNavigator({required BuildContext context,required Widget navigator, required isMove}) =>
      _function.mainNavigator(context, navigator, isMove);

  Future<bool> onBackPressed({required BuildContext context}) =>
      _function.onBackPressed(context);


  Future<bool> onScheduleBackPressed({required BuildContext context}) =>
      _function.onScheduleBackPressed(context);
}
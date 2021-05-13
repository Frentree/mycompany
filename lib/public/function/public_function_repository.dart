import 'package:flutter/material.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/function/public_funtion.dart';


class PublicFunctionRepository {
  PageRouting _pageRouting = PageRouting();
  PublicFunction _function = PublicFunction();


  void pageMove({required BuildContext context, required Widget pageName}) => _pageRouting.pageMove(context: context, pageName: pageName);
  void backPage({required BuildContext context}) => _pageRouting.backPage(context: context);

  void mainNavigator({required BuildContext context,required Widget navigator, required isMove}) =>
      _function.mainNavigator(context, navigator, isMove);

  /*Future<bool> onBackPressed({required BuildContext context}) =>
      _function.onBackPressed(context);*/
}
import 'package:flutter/material.dart';
import 'package:mycompany/public/function/page_route.dart';

class PublicFunctionRepository {
  PageRouting _pageRouting = PageRouting();

  void pageMove({required BuildContext context, required Widget pageName}) => _pageRouting.pageMove(context: context, pageName: pageName);
  void backPage({required BuildContext context}) => _pageRouting.backPage(context: context);
}
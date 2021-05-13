import 'package:flutter/material.dart';

class PageRouting{
  void pageMove({required BuildContext context, required Widget pageName}){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pageName)
    );
  }

  void backPage({required BuildContext context}) {
    Navigator.pop(context);
  }


}
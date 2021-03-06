import 'package:flutter/material.dart';

pageMove({required BuildContext context, required  pageName}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => pageName));
}

void backPage({required BuildContext context, dynamic? returnValue}) {
  Navigator.pop(context, returnValue);
}

void pageMoveAndRemoveBackPage(
    {required BuildContext context, required Widget pageName}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => pageName),
        (route) => false,
  );
}

/*
void pageReplacement(
    {required BuildContext context, required Widget pageName}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => pageName),
  );
}
*/

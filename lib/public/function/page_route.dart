import 'package:flutter/material.dart';

pageMove({required BuildContext context, required Widget pageName}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => pageName));
}

void backPage({required BuildContext context, bool? returnValue}) {
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

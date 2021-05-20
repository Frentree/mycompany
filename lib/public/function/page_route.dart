import 'package:flutter/material.dart';

pageMove({required BuildContext context, required Widget pageName}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => pageName));
}

void backPage({required BuildContext context}) {
  Navigator.pop(context);
}

void pageMoveAndRemoveBackPage(
    {required BuildContext context, required Widget pageName}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => pageName),
        (route) => false,
  );
}

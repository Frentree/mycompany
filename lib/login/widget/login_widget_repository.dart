import 'package:flutter/material.dart';
import 'package:mycompany/login/widget/button_widget.dart';

class LoginWidgetRepository {
  ButtonWidget _buttonWidget = ButtonWidget();

  Container elevatedButton({
    required double topPadding,
    required String buttonName,
    VoidCallback? buttonAction,
  }) =>
      _buttonWidget.elevatedButton(
        topPadding: topPadding,
        buttonName: buttonName,
        buttonAction: buttonAction,
      );

  Container outlinedButton({
    required double topPadding,
    required String buttonName,
    VoidCallback? buttonAction
  }) =>
      _buttonWidget.outlinedButton(
        topPadding: topPadding,
        buttonName: buttonName,
        buttonAction: buttonAction,
      );
}

import 'package:flutter/material.dart';
import 'package:mycompany/login/widget/button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';

class LoginWidgetRepository {
  LoginButtonWidget _loginButtonWidget = LoginButtonWidget();
  LoginDialogWidget _loginDialogWidget = LoginDialogWidget();

  Container elevatedButton({
    required double topPadding,
    required String buttonName,
    VoidCallback? buttonAction,
  }) =>
      _loginButtonWidget.elevatedButton(
        topPadding: topPadding,
        buttonName: buttonName,
        buttonAction: buttonAction,
      );

  Container outlinedButton({
    required double topPadding,
    required String buttonName,
    VoidCallback? buttonAction,
  }) =>
      _loginButtonWidget.outlinedButton(
        topPadding: topPadding,
        buttonName: buttonName,
        buttonAction: buttonAction,
      );

  IconButton textFormClearButton({
    required TextEditingController textEditingController,
  }) =>
      _loginButtonWidget.textFormClearButton(
        textEditingController: textEditingController,
      );

  Future<dynamic> loginDialogWidget({
    required BuildContext context,
    String? title,
    required Widget content,
    required List<Widget> actions,
  }) =>
      _loginDialogWidget.loginDialogWidget(
        context: context,
        title: title,
        content: content,
        actions: actions,
      );

  Future<dynamic> firebaseAuthErrorDialogWidget({
    required BuildContext context,
    required String errorMessage,
  }) =>
      _loginDialogWidget.firebaseAuthErrorDialogWidget(
        context: context,
        errorMessage: errorMessage,
      );
}

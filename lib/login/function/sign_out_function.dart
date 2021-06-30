import 'package:flutter/material.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/run_app/view/auth_view.dart';
import 'package:provider/provider.dart';

class SignOutFunction {
  Future<void> signOutFunction({
    required BuildContext context,
  }) async {
    LoginServiceRepository loginServiceRepository = LoginServiceRepository();
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context, listen: false);

    await loginDialogWidget(
      context: context,
      message: "로그아웃 하시겠습니까?",
      actions: [
        loginDialogCancelButton(
          buttonName: 'dialogCancel'.tr(),
          buttonAction: () {
            backPage(context: context);
          },
        ),
        loginDialogConfirmButton(
          buttonName: 'dialogConfirm'.tr(),
          buttonAction: () async {
            await loginServiceRepository.signOut();
            userInfoProvider.deleteUserDataToPhone();
            employeeInfoProvider.deleteEmployeeDataToPhone();
            pageMoveAndRemoveBackPage(context: context, pageName: AuthView());
          }
        ),
      ]
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/run_app/view/auth_view.dart';
import 'package:provider/provider.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';

class SignOutFunction {
  Future<void> signOutFunction({
    required BuildContext context,
  }) async {
    LoginServiceRepository loginServiceRepository = LoginServiceRepository();
    LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();

    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context, listen: false);

    UserModel loginUserData = userInfoProvider.getUserData()!;

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

                loginUserData.deviceId = "";
                await loginFirestoreRepository.updateUserData(userModel: loginUserData);

                userInfoProvider.deleteUserDataToPhone();
                employeeInfoProvider.deleteEmployeeDataToPhone();
                pageMoveAndRemoveBackPage(context: context, pageName: AuthView());
              }
          ),
        ]
    );
  }
}
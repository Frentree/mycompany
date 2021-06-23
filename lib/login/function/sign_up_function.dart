import 'package:flutter/material.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/public/function/page_route.dart';

class SignUpFunction {
  Future<bool> signUpFunction({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    String ? birthday,
    String ? phone,
  }) async {

    DateFormatCustom _dateFormatCustom = DateFormatCustom();
    LoginServiceRepository loginServiceRepository = LoginServiceRepository();
    LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();

    bool _firebaseAuthResult;


    _firebaseAuthResult = await loginServiceRepository.signUpWithEmailAndPassword(email: email, password: password);
    //firebase 인증 성공
    if (_firebaseAuthResult == true) {
      //userModel 생성
      UserModel userModel = UserModel(
        mail: email,
        name: name,
        birthday: birthday,
        phone: phone,
        createDate: _dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime.now()),
        lastModDate: _dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime.now()),
      );

      //User DB 생성
      await loginFirestoreRepository.createUserData(userModel: userModel);
      await loginDialogWidget(
        context: context,
        message: 'signUpSuccess'.tr(),
        actions: [
          loginDialogConfirmButton(
            buttonName: 'dialogConfirm'.tr(),
            buttonAction: () => backPage(context: context)
          )
        ]
      );
    }
    //firebase 인증 실패
    else {
      String errorMessage = loginServiceRepository.changeMessageToErrorCode();
      await loginDialogWidget(
        context: context,
        message: errorMessage,
        actions: [
          loginDialogConfirmButton(
            buttonName: 'dialogConfirm'.tr(),
            buttonAction: () => backPage(context: context)
          )
        ]
      );
    }

    return _firebaseAuthResult;
  }
}

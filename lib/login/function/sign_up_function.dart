import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';

class SignUpFunction {
  Future<void> signUpFunction({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    String ? birthday,
    String ? phone,
  }) async {

    DateFormat _dateFormat = DateFormat();
    LoginServiceRepository loginServiceRepository = LoginServiceRepository();
    LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();

    bool _firebaseAuthResult;


    _firebaseAuthResult = await loginServiceRepository.signUpWithEmailAndPassword(email: email, password: password);
    //firebase 인증 성공
    if (_firebaseAuthResult == true) {
      //userModel 생성
      UserModel userModel = UserModel(
        email: email,
        name: name,
        birthday: birthday != "" ? _dateFormat.changeStringToTimeStamp(dateString: birthday!) : null,
        phone: phone,
        createDate: _dateFormat.changeDateTimeToTimeStamp(dateTime: DateTime.now()),
        modifiedDate: _dateFormat.changeDateTimeToTimeStamp(dateTime: DateTime.now()),
      );

      //User DB 생성
      await loginFirestoreRepository.createUserData(userModel: userModel);
      await loginDialogWidget(
        context: context,
        title: "축하합니다!",
        content: Text("회원가입이 완료되었습니다."),
        actions: [
          TextButton(
            child: Text("확인"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]);
    }
    //firebase 인증 실패
    else {
      firebaseAuthErrorDialogWidget(
        context: context,
        errorMessage: loginServiceRepository.changeMessageToErrorCode(),
      );
    }
  }
}

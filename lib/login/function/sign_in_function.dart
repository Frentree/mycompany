import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/view/sign_up_view.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/public/provider/public_provider_repository.dart';
import 'package:mycompany/login/widget/login_widget_repository.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';

class SignInFunction {
  void page(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpView()));
  }

  Future<void> signInFunction({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    LoginServiceRepository loginServiceRepository = LoginServiceRepository();
    LoginFirestoreRepository loginFirestoreRepository =
        LoginFirestoreRepository();
    PublicProviderRepository publicProviderRepository =
        PublicProviderRepository();
    LoginWidgetRepository loginWidgetRepository = LoginWidgetRepository();

    UserModel _userModel;
    bool _firebaseAuthResult;

    _firebaseAuthResult = await loginServiceRepository
        .signInWithEmailAndPassword(email: email, password: password);
    //firebase 인증 성공
    if (_firebaseAuthResult == true) {
      _userModel = await loginFirestoreRepository.readUserData(
          email: email); //DB에서 user 정보 가져오기

      //저장된 토큰값이 없을 때(다른 기기에서 로그인 되어 있지 않음)
      if (_userModel.tokenId == null) {
        _userModel.tokenId = await firebaseMessaging.getToken(); //토큰값 가져오기
        await loginFirestoreRepository.updateUserData(
            userModel: _userModel); //토큰값 DB에 업데이트
        publicProviderRepository.saveUserDataToPhone(
            userModel: _userModel); //로그인 정보 핸드폰에 저장
      }
      //저장된 토큰값이 있을 때(다른 기기에서 로그인 되어 있음)
      else {
        await loginWidgetRepository.loginDialogWidget(
            context: context,
            title: "다른 기기에서 로그인 중입니다.",
            content: Text("강제 로그아웃하고, 현재 기기에서 로그인 하시겠습니까?"),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {},
              ),
              TextButton(
                child: Text("취소"),
                onPressed: () {},
              )
            ]);
      }
    }
    //firebase 인증 실패
    else {
      loginWidgetRepository.firebaseAuthErrorDialogWidget(
        context: context,
        errorMessage: loginServiceRepository.changeMessageToErrorCode(),
      );
    }
  }

  void schedule(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleView()));
  }
}

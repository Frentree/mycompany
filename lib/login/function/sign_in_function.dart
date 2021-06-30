import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/public/provider/device_Info_provider.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:provider/provider.dart';

class SignInFunction {
  Future<void> signInFunction({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    LoginServiceRepository loginServiceRepository = LoginServiceRepository();
    LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context, listen: false);
    DeviceInfoProvider deviceInfoProvider = Provider.of<DeviceInfoProvider>(context, listen: false);

    UserModel _userModel;
    EmployeeModel? _employeeModel;
    bool _firebaseAuthResult;
    String _deviceId = deviceInfoProvider.getDeviceId()!;

    _firebaseAuthResult = await loginServiceRepository.signInWithEmailAndPassword(email: email, password: password);
    //firebase 인증 성공
    if (_firebaseAuthResult == true) {
      _userModel = await loginFirestoreRepository.readUserData(email: email); //DB에서 user 정보 가져오기
      if(_userModel.state == 2){
        _employeeModel = await loginFirestoreRepository.readEmployeeData(companyId: _userModel.companyCode!, email: _userModel.mail);
      }

      //저장된 기기ID 값이 없을 때(다른 기기에서 로그인 되어 있지 않음)
      if (_userModel.deviceId == "") {
        _userModel.token = await firebaseMessaging.getToken(); //토큰값 가져오기
        _userModel.deviceId = _deviceId; //기기Id 가져오기
        await loginFirestoreRepository.updateUserData(userModel: _userModel); //토큰값 및 기기Id DB에 업데이트
        userInfoProvider.saveUserDataToPhone(userModel: _userModel); //로그인 정보 핸드폰에 저장
        if(_employeeModel != null){
          employeeInfoProvider.saveEmployeeDataToPhone(employeeModel: _employeeModel);
        }
      }

      //저장된 기기ID 값이 있을 때(다른 기기에서 로그인 되어 있음)
      else {
        if(_userModel.deviceId != _deviceId){
          await loginDialogWidget(
            context: context,
            message: 'duplicateLoginWarning'.tr(),
            actions: [
              loginDialogConfirmButton(
                  buttonName: 'dialogConfirm'.tr(),
                  buttonAction: () async {
                    _userModel.token = await firebaseMessaging.getToken();
                    _userModel.deviceId = _deviceId; //기기Id 가져오기
                    await loginFirestoreRepository.updateUserData(userModel: _userModel); //토큰값 DB에 업데이트
                    userInfoProvider.saveUserDataToPhone(userModel: _userModel);
                    if(_employeeModel != null){
                      employeeInfoProvider.saveEmployeeDataToPhone(employeeModel: _employeeModel);
                    }
                    backPage(context: context);
                  }
              ),
              loginDialogCancelButton(
                  buttonName: 'dialogCancel'.tr(),
                  buttonAction: () {
                    backPage(context: context);
                  }
              ),
            ],
          );
        }
        userInfoProvider.saveUserDataToPhone(userModel: _userModel);
        if(_employeeModel != null){
          employeeInfoProvider.saveEmployeeDataToPhone(employeeModel: _employeeModel);
        }
      }
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
  }
}

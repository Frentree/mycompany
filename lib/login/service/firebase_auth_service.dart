import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String firebaseAuthErrorCode = "";

  void setFirebaseAuthErrorCode({required String errorCode}) {
    firebaseAuthErrorCode = errorCode;
  }

  String getFirebaseAuthErrorCode() {
    String _returnErrorCode = firebaseAuthErrorCode;
    firebaseAuthErrorCode = "";

    return _returnErrorCode;
  }

  String changeMessageToErrorCode() {
    String _errorCode = getFirebaseAuthErrorCode();
    String _returnMessage = "";

    switch(_errorCode) {
      case 'ERROR_EMAIL_ALREADY_IN_USE' :
        _returnMessage = 'error_email_already_in_use'.tr();
        break;

      case 'ERROR_INVALID_EMAIL' :
      case 'ERROR_WRONG_PASSWORD' :
        _returnMessage = 'error_incorrect_login_information'.tr();
        break;

      case 'ERROR_TOO_MANY_REQUESTS' :
        _returnMessage = 'error_too_many_requests'.tr();
        break;

      default :
        _returnMessage = 'error_undefined'.tr();
        break;
    }

    return _returnMessage;
  }

  Future<bool> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      dynamic _result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if(_result != null) {
        return true;
      }

      else {
        return false;
      }
    } on FirebaseAuthException catch (error) {
      setFirebaseAuthErrorCode(errorCode: error.code);

      return false;
    }
  }
}

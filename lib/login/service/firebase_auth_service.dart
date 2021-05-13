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
        _returnMessage = 'errorEmailAlreadyInUse'.tr();
        break;

      case 'ERROR_INVALID_EMAIL' :
      case 'ERROR_WRONG_PASSWORD' :
        _returnMessage = 'errorIncorrectLoginInformation'.tr();
        break;

      case 'ERROR_TOO_MANY_REQUESTS' :
        _returnMessage = 'errorTooManyRequests'.tr();
        break;

      default :
        _returnMessage = 'errorUndefined'.tr();
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

  Future<bool> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      UserCredential _newUserCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      if(_newUserCredential.user != null) {
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

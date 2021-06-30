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
      case 'email-already-in-use' :
        _returnMessage = 'errorEmailAlreadyInUse'.tr();
        break;

      case 'user-not-found' :
      case 'wrong-password' :
      case 'invalid-email':
        _returnMessage = 'errorIncorrectLoginInformation'.tr();
        break;

      case 'too-many-requests' :
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
      print(error.code);
      setFirebaseAuthErrorCode(errorCode: error.code);

      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      UserCredential _newUserCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      if(_newUserCredential.user != null) {
        _newUserCredential.user!.updateProfile();
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

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();

    } on FirebaseAuthException catch (error) {
      print(error.code);
      setFirebaseAuthErrorCode(errorCode: error.code);
    }
  }
}

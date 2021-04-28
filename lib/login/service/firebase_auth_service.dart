/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String firebaseAuthErrorCode = "";

  void setFirebaseAuthErrorCode({String errorCode}) {
    firebaseAuthErrorCode = errorCode;
  }

  String getFirebaseAuthErrorCode() {
    String _returnErrorCode = firebaseAuthErrorCode;
    firebaseAuthErrorCode = null;

    return _returnErrorCode;
  }

  String changeMessageToErrorCode() {
    String _errorCode = getFirebaseAuthErrorCode();


  }

  Future<bool> signInWithEmailAndPassword({String email, String password}) async {
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
}*/

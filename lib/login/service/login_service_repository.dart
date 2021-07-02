import 'package:flutter/material.dart';
import 'package:mycompany/login/service/firebase_auth_service.dart';

class LoginServiceRepository {
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  String changeMessageToErrorCode() => _firebaseAuthService.changeMessageToErrorCode();
  Future<bool> signInWithEmailAndPassword({required String email, required String password}) => _firebaseAuthService.signInWithEmailAndPassword(email: email, password: password);
  Future<bool> signUpWithEmailAndPassword({required String email, required String password}) => _firebaseAuthService.signUpWithEmailAndPassword(email: email, password: password);
  Future<void> signOut() => _firebaseAuthService.signOut();
}

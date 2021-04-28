/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/word/database_name.dart';

class LoginFirebaseCrud {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createEmployeeData({EmployeeModel employeeModel}) async {
    return await _firebaseFirestore.collection(EMPLOYEE).doc(employeeModel.email).set(employeeModel.toJson());
  }

  Future<EmployeeModel> readEmployeeData({String email}) async {
    dynamic document = await _firebaseFirestore.collection(EMPLOYEE).doc(email).get();

    return EmployeeModel.fromMap(mapData: document.data());
  }

  Future<void> createUserData({UserModel userModel}) async {
    return await _firebaseFirestore.collection(USER).doc(userModel.email).set(userModel.toJson());
  }

  Future<UserModel> readUserData({String email}) async {
    dynamic document = await _firebaseFirestore.collection(USER).doc(email).get();

    return UserModel.fromMap(mapData: document.data());
  }
}*/

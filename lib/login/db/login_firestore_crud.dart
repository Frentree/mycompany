import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/word/database_name.dart';

class LoginFirestoreCrud {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createEmployeeData({required EmployeeModel employeeModel}) async {
    return await _firebaseFirestore.collection(EMPLOYEE).doc(employeeModel.email).set(employeeModel.toJson());
  }

  Future<EmployeeModel> readEmployeeData({required String email}) async {
    dynamic document = await _firebaseFirestore.collection(EMPLOYEE).doc(email).get();

    return EmployeeModel.fromMap(mapData: document.data());
  }

  Future<void> createUserData({required UserModel userModel}) async {
    return await _firebaseFirestore.collection(USER).doc(userModel.email).set(userModel.toJson());
  }

  Future<UserModel> readUserData({required String email}) async {
    dynamic document = await _firebaseFirestore.collection(USER).doc(email).get();

    return UserModel.fromMap(mapData: document.data());
  }

  Future<void> updateUserData({required UserModel userModel}) async {
    userModel.modifiedDate = Timestamp.now();

    return await _firebaseFirestore.collection(USER).doc(userModel.email).update(userModel.toJson());
  }
}

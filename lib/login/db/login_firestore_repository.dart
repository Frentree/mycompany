import 'package:mycompany/login/db/login_firestore_crud.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';

class LoginFirestoreRepository {
  LoginFirestoreCrud _loginFirebaseCrud = LoginFirestoreCrud();

  Future<void> createEmployeeData({required EmployeeModel employeeModel}) => _loginFirebaseCrud.createEmployeeData(employeeModel: employeeModel);
  Future<EmployeeModel> readEmployeeData({required String email}) => _loginFirebaseCrud.readEmployeeData(email: email);

  Future<void> createUserData({required UserModel userModel}) => _loginFirebaseCrud.createUserData(userModel: userModel);
  Future<UserModel> readUserData({required String email}) => _loginFirebaseCrud.readUserData(email: email);
  Future<void> updateUserData({required UserModel userModel}) => _loginFirebaseCrud.updateUserData(userModel: userModel);
}

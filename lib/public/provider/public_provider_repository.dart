import 'package:mycompany/login/db/login_firestore_crud.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';

class PublicProviderRepository {
  UserInfoProvider _userInfoProvider = UserInfoProvider();

  Future<void> saveUserDataToPhone({required UserModel userModel}) => _userInfoProvider.saveUserDataToPhone(userModel: userModel);
  Future<void> loadUserDataToPhone() => _userInfoProvider.loadUserDataToPhone();
  UserModel? getUserData() => _userInfoProvider.getUserData();

}

import 'package:flutter/material.dart';
import 'package:mycompany/login/view/sign_in_view.dart';
import 'package:mycompany/login/view/sign_up_view.dart';
import 'package:mycompany/run_app/view/splash_view_blue.dart';
import 'package:provider/provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/view/user_type_select_view.dart';

class AuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);
    UserModel? loginUserData = userInfoProvider.getUserData();
    print("auth: ${loginUserData}");
    if(loginUserData == null){
      print(loginUserData);
      return SignInView();
    }

    else{
      print(loginUserData);
      switch(loginUserData.joinStatus){
        case 0:
          return UserTypeSelectView();

        default:
          return UserTypeSelectView();
      }
    }
  }
}
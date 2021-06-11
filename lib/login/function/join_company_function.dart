import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/join_company_approval_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:provider/provider.dart';

class JoinCompanyFunction {
  LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();

  Future<void> joinCompanyFunction({
    required BuildContext context,
    required CompanyModel company,
  }) async {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false,);
    DateFormatCustom dateFormatCustom = DateFormatCustom();

    UserModel loginUserData = userInfoProvider.getUserData()!;

    JoinCompanyApprovalModel joinCompanyApprovalModel = JoinCompanyApprovalModel(
      requesterEmail: loginUserData.email,
      requesterName: loginUserData.name,
      requesterPhone: loginUserData.phone,
      requesterBirthday: loginUserData.birthday,
      requestDate: dateFormatCustom.changeDateTimeToTimeStamp(dateTime: DateTime.now()),
    );

    await loginFirestoreRepository.createJoinCompanyApprovalData(companyId: company.companyId, joinCompanyApprovalModel: joinCompanyApprovalModel);

    //로그인 사용자 joinStatus 및 companyCode 업데이트
    loginUserData.joinStatus = 1;
    loginUserData.modifiedDate = dateFormatCustom.changeDateTimeToTimeStamp(dateTime: DateTime.now());

    await loginFirestoreRepository.updateUserData(userModel: loginUserData);
  }
}
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:provider/provider.dart';

class CreateCompanyFunction {
  LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();

  String generateRandomCompanyId() {
    Random random = Random();

    // 제외할 문자 [:, ;, <, =, >, ?, @]
    List<int> skipValue = [
      0x3A,
      0x3B,
      0x3C,
      0x3D,
      0x3E,
      0x3F,
      0x40
    ];

    //랜덤 문자 범위 0~Z
    int minRandomValue = 0x30;
    int maxRandomValue = 0x5A;

    List<int> randomCompanyId = [];

    while (randomCompanyId.length <= 6) {
      int randomValue = minRandomValue +
          random.nextInt(maxRandomValue - minRandomValue);

      if (skipValue.contains(randomValue)) {
        continue;
      }

      randomCompanyId.add(randomValue);
    }

    return String.fromCharCodes(randomCompanyId.cast<int>());
  }

  Future<bool> companyIdDuplicateCheck({required String newCompanyId}) async {
    List<CompanyModel> allCompanyData = await loginFirestoreRepository.readAllCompanyData();
    bool isDuplicate = false;

    allCompanyData.forEach((element) {
      if (element.companyCode == newCompanyId) {
        isDuplicate = true;
      }
    });

    return isDuplicate;
  }

  Future<String> createCompanyId() async {
    String companyId = "";
    bool isDuplicate = true;

    while (isDuplicate == true) {
      companyId = generateRandomCompanyId();
      isDuplicate = await companyIdDuplicateCheck(newCompanyId: companyId);
    }

    return companyId;
  }

  Future<void> createCompanyFunction({
    required BuildContext context,
    required String companyName,
    required String companyAddress,
  }) async {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false,);
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context, listen: false,);

    DateFormatCustom dateFormatCustom = DateFormatCustom();

    UserModel loginUserData = userInfoProvider.getUserData()!;
    String companyId = await createCompanyId();

    CompanyModel companyModel = CompanyModel(
      companyCode: companyId,
      companyName: companyName,
      companyAddr: companyAddress,
    );

    await loginFirestoreRepository.createCompanyData(companyModel: companyModel);

    EmployeeModel employeeModel = EmployeeModel(
      token: loginUserData.token,
      mail: loginUserData.mail,
      name: loginUserData.name,
      phone: loginUserData.phone,
      birthday: loginUserData.birthday,
      companyCode: companyId,
      createDate: dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime.now()),
      lastModDate: dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime.now()),
    );

    employeeInfoProvider.saveEmployeeDataToPhoneWithoutNotifyListener(employeeModel: employeeModel);
    await loginFirestoreRepository.createEmployeeData(employeeModel: employeeModel);

    //로그인 사용자 joinStatus 및 companyCode 업데이트
    loginUserData.state = 2;
    loginUserData.companyCode = companyId;
    loginUserData.lastModDate = dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime.now());

    await loginFirestoreRepository.updateUserData(userModel: loginUserData);

  }
}
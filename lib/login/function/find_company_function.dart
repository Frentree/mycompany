import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:flutter/material.dart';

class FindCompanyFunction {
  LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();

  Future<void> findCompanyFunction({required String companyName, required ValueNotifier<List<CompanyModel>> valueNotifier,}) async {
    List<String> keyWord = companyName.split("");
    List<CompanyModel> findCompanyData = [];

    QuerySnapshot getData = await loginFirestoreRepository.findCompanyDataWithName(keyWord: keyWord[0]);

    getData.docs.forEach((doc) {
      CompanyModel _tempCompanyData = CompanyModel.fromMap(mapData: (doc.data() as dynamic));
      if(keyWord.length == 1) {
        findCompanyData.add(_tempCompanyData);
      }
      else{
        int _findKeywordIndex = _tempCompanyData.companySearch!.indexOf(keyWord[0]);
        if(_tempCompanyData.companySearch!.length - _findKeywordIndex >= keyWord.length){
          for(int i = 1; i < keyWord.length; i++){
            if(_tempCompanyData.companySearch![_findKeywordIndex + i] != keyWord[i]){
              break;
            }
            else{
              if(i == (keyWord.length -1)){
                findCompanyData.add(_tempCompanyData);
              }
            }
          }
        }
      }
    });
    valueNotifier.value = findCompanyData;
  }
}

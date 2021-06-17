import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/join_company_approval_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/word/database_name.dart';

class LoginFirestoreCrud {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //Employee 관련
  Future<void> createEmployeeData({required EmployeeModel employeeModel}) async {
    await _firebaseFirestore.collection(COMPANY).doc(employeeModel.companyCode).collection(USER).doc(employeeModel.mail).set(employeeModel.toJson());
  }

  Future<EmployeeModel> readEmployeeData({required String companyId, required String email}) async {
    dynamic document = await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(USER).doc(email).get();

    return EmployeeModel.fromMap(mapData: document.data());
  }

  //User 관련
  Future<void> createUserData({required UserModel userModel}) async {
    await _firebaseFirestore.collection(USER).doc(userModel.mail).set(userModel.toJson());
  }

  Future<UserModel> readUserData({required String email}) async {
    dynamic document = await _firebaseFirestore.collection(USER).doc(email).get();

    return UserModel.fromMap(mapData: document.data());
  }

  Future<void> updateUserData({required UserModel userModel}) async {
    userModel.lastModDate = Timestamp.now();

    await _firebaseFirestore.collection(USER).doc(userModel.mail).update(userModel.toJson());
  }

  //Company 관련
  Future<void> createCompanyData({required CompanyModel companyModel}) async {
    await _firebaseFirestore.collection(COMPANY).doc(companyModel.companyCode).set(companyModel.toJson());
  }

  Future<List<CompanyModel>> readAllCompanyData() async {
    QuerySnapshot getData = await _firebaseFirestore.collection(COMPANY).get();
    List<CompanyModel> allCompanyDataList = getData.docs.map((doc) => CompanyModel.fromMap(mapData: (doc.data() as dynamic))).toList();

    return allCompanyDataList;
  }

  Future<QuerySnapshot> findCompanyDataWithName({required String keyWord}) async {
    QuerySnapshot t = await _firebaseFirestore.collection(COMPANY).where("companySearch", arrayContains: keyWord).get();
    return await _firebaseFirestore.collection(COMPANY).where("companySearch", arrayContains: keyWord).get();
  }

  //JoinCompanyApproval 관련
  Future<void> createJoinCompanyApprovalData({required String companyId, required JoinCompanyApprovalModel joinCompanyApprovalModel}) async {
    await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(JOINCOMPANYAPPROVAL).add(joinCompanyApprovalModel.toJson());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/join_company_approval_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/word/database_name.dart';
import 'package:mycompany/setting/model/wifi_model.dart';

class LoginFirestoreCrud {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  LoginFirestoreCrud.settings({persistenceEnabled: true});

  //Employee 관련
  Future<void> createEmployeeData({required EmployeeModel employeeModel}) async {
    await _firebaseFirestore.collection(COMPANY).doc(employeeModel.companyCode).collection(USER).doc(employeeModel.mail).set(employeeModel.toJson());
  }

  Future<EmployeeModel> readEmployeeData({required String companyId, required String email}) async {
    dynamic document = await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(USER).doc(email).get();

    return EmployeeModel.fromMap(mapData: document.data());
  }

  Future<List<EmployeeModel>> readAllEmployeeData({required String companyId}) async {
    QuerySnapshot<Map<dynamic, dynamic>> getData = await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(USER).get();
    List<EmployeeModel> allEmployeeDataList = getData.docs.map((doc) => EmployeeModel.fromMap(mapData: doc.data())).toList();

    return allEmployeeDataList;
  }

  Future<List<EmployeeModel>> readMyTeamEmployeeData({required EmployeeModel employeeModel}) async {
    QuerySnapshot<Map<dynamic, dynamic>> getData = await _firebaseFirestore.collection(COMPANY).doc(employeeModel.companyCode).collection(USER).where("team", isEqualTo: employeeModel.team).get();
    List<EmployeeModel> myTeamEmployeeDataList = getData.docs.map((doc) => EmployeeModel.fromMap(mapData: doc.data())).toList();

    return myTeamEmployeeDataList;
  }

  Future<List<String>> getCompanyManagerMail({required String companyId}) async {
    QuerySnapshot<Map<dynamic, dynamic>> getData = await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(USER).where("level", arrayContains: [8, 9]).get();
    List<EmployeeModel> managerDataList = getData.docs.map((doc) => EmployeeModel.fromMap(mapData: doc.data())).toList();
    List<String> companyManagerMail = [];
    managerDataList.forEach((element) {
      companyManagerMail.add(element.mail);
    });

    return companyManagerMail;
  }

  Future<void> updateEmployeeData({required EmployeeModel employeeModel}) async {
    employeeModel.lastModDate = Timestamp.now();

    await _firebaseFirestore.collection(COMPANY).doc(employeeModel.companyCode).collection(USER).doc(employeeModel.mail).update(employeeModel.toJson());
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

  Future<void> updateUserJoinCompanyState({required String userMail, int? state, String? companyId,}) async {
    await _firebaseFirestore.collection(USER).doc(userMail).update({
      "lastModDate": Timestamp.now(),
      "companyCode": companyId,
    });
  }

  //Company 관련
  Future<void> createCompanyData({required CompanyModel companyModel}) async {
    await _firebaseFirestore.collection(COMPANY).doc(companyModel.companyCode).set(companyModel.toJson());
  }

  Future<List<CompanyModel>> readAllCompanyData() async {
    QuerySnapshot<Map<dynamic, dynamic>> getData = await _firebaseFirestore.collection(COMPANY).get();
    List<CompanyModel> allCompanyDataList = getData.docs.map((doc) => CompanyModel.fromMap(mapData: doc.data())).toList();

    return allCompanyDataList;
  }

  Future<QuerySnapshot> findCompanyDataWithName({required String keyWord}) async {
    return await _firebaseFirestore.collection(COMPANY).where("companySearch", arrayContains: keyWord).get();
  }

  Future<List<TeamModel>> readTeamData({required String companyId}) async {
    List<TeamModel> teamData = [];
    QuerySnapshot<Map<String, dynamic>> getData = await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(TEAM).get();

    teamData = getData.docs.map((doc) => TeamModel.fromMap(mapData: doc.data())).toList();

    return teamData;
  }

  Future<List<PositionModel>> readPositionData({required String companyId}) async {
    List<PositionModel> positionData = [];
    QuerySnapshot<Map<String, dynamic>> getData = await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(POSITION).get();

    positionData = getData.docs.map((doc) => PositionModel.fromMap(mapData: doc.data())).toList();

    return positionData;
  }

  //JoinCompanyApproval 관련
  Future<void> createJoinCompanyApprovalData({required String companyId, required JoinCompanyApprovalModel joinCompanyApprovalModel}) async {
    await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(JOINCOMPANYAPPROVAL).add(joinCompanyApprovalModel.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readJoinCompanyApprovalData({required String companyId}){
    return _firebaseFirestore.collection(COMPANY).doc(companyId).collection(JOINCOMPANYAPPROVAL).where("state", isEqualTo: 0).snapshots();
  }

  Future<void> updateJoinCompanyApprovalData({required String companyId, required JoinCompanyApprovalModel joinCompanyApprovalModel}) async {
    joinCompanyApprovalModel.approvalDate = Timestamp.now();

    await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(JOINCOMPANYAPPROVAL).doc(joinCompanyApprovalModel.documentId).update(joinCompanyApprovalModel.toJson());
  }
}

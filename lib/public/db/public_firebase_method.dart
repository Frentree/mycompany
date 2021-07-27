import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mycompany/expense/model/expense_model.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/fcm/alarmModel.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/word/database_name.dart';
import 'package:mycompany/schedule/model/work_model.dart';

class PublicFirebaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateFormatCustom _dateFormatCustom = DateFormatCustom();

  PublicFirebaseMethods.settings(
      {persistenceEnabled: true, cacheSizeBytes: -1});

  Future<List<String>> getTokensFromUsers(UserModel user, String? companyCode,
      List users) async {
    List<String> _tokens = [];

    users.forEach((_user) async {
      var _userModel;
      _userModel = await _firestore
          .collection("company")
          .doc(companyCode)
          .collection("user")
          .doc(_user)
          .get();

      try {
        print(_userModel);
        print(_userModel.data());
        print(_userModel.data()["token"]);
        if (_userModel.data() != null) _tokens.add(_userModel.data()["token"]);
      } catch (e) {
        print("[ERROR] public firebase method : getTokensFromUsers");
        print(e.toString());
      }
    });

    return _tokens;
  }

  Future<void> saveAlarmDataFromUsersThenSend(UserModel user,
      String? companyCode, List users, var payload) async {
    HttpsCallable callFcm =
    FirebaseFunctions.instance.httpsCallable('sendFcmNew');

    users.forEach((_userMail) async {
      print("user mail : $_userMail");
      int _alarmId = DateTime
          .now()
          .hashCode;

      /// 알람 데이터 저장
      var _docRef = _firestore
          .collection("company")
          .doc(companyCode)
          .collection("user")
          .doc(user.mail)
          .collection("alarm")
          .doc();

      AlarmModel _model = AlarmModel(
        id: _docRef.id,
        alarmId: int.parse(_alarmId.toString()),
        title: payload["title"],
        createName: user.name,
        createMail: user.mail,
        collectionName: "Deprecated",
        alarmContents: payload["message"],
        read: false,
        alarmDate: Timestamp.now(),
        route: payload["route"],
      );

      try {
        _firestore
            .collection("company")
            .doc(companyCode)
            .collection("user")
            .doc(_userMail)
            .collection("alarm")
            .doc(_docRef.id)
            .set(_model.toJson());
      } catch (e) {
        print(
            "[ERROR] public firebase method : saveAlarmDataFromUsersThenSend");
        print(e.toString());
      }

      /// 알람 전송
      var _user = await _firestore.collection("user").doc(_userMail).get();

      var _payload = <String, dynamic>{
        "tokens": (_user.data() as dynamic)["token"],
        "title": payload["title"],
        "message": payload["message"],
        "route": payload["route"],
        "alarmId": _alarmId.toString(),
      };
      print('payload is $_payload');

      try {
        await callFcm.call(_payload);
      } catch (e) {
        print(
            "[ERROR] public firebase method : saveAlarmDataFromUsersThenSend");
        print(e.toString());
      }
    });
  }

  Future<void> setAlarmReadToTrue(String? companyCode, String? mail,
      String alarmId) async {
    try {
      _firestore
          .collection("company")
          .doc(companyCode)
          .collection("user")
          .doc(mail)
          .collection("alarm")
          .doc(alarmId)
          .set({"read": true});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<double> usedVacationWithDuration(String? companyCode, String? mail,
      DateTime start, DateTime end) async {
    double result = 0.0;

    Timestamp _start = _dateFormatCustom.changeDateTimeToTimestamp(
        dateTime: start);
    Timestamp _end = _dateFormatCustom.changeDateTimeToTimestamp(dateTime: end);

    late QuerySnapshot _querySnapshots;

    try {
      _querySnapshots = await _firestore
          .collection("company")
          .doc(companyCode)
          .collection("work")
          .where("createUid", isEqualTo: mail)
          .where("startTime", isLessThanOrEqualTo: _end)
          .where("startTime", isGreaterThanOrEqualTo: _start)
          .where("type", whereIn: ['연차', '반차'])
          .orderBy("startTime", descending: false)
          .get();

      _querySnapshots.docs.forEach((element) {
        WorkModel workModel = WorkModel.fromMap(mapData: element.data() as dynamic, reference: element.reference);
        if(workModel.type == "연차"){
          result += _dateFormatCustom.changeTimestampToDateTime(timestamp: workModel.endTime!).add(Duration(hours: 9))
              .difference(_dateFormatCustom.changeTimestampToDateTime(timestamp: workModel.startTime)).inDays + 1;
        } else {
          result += 0.5;
        }
        /*result += (element.data() as dynamic)['type'] == '연차'? 1 : 0.5;*/
      });
    } catch (e) {
      print(e.toString());
    }

    return result;
  }

  Stream<QuerySnapshot> getCompanyUsers(UserModel loginUser){
    return _firestore.collection(COMPANY).doc(loginUser.companyCode!).collection(USER).snapshots();
  }

  Stream<QuerySnapshot> getCompanyTeamUsers(UserModel loginUser, String teamName){
    return _firestore.collection(COMPANY).doc(loginUser.companyCode!).collection(USER).where("team", isEqualTo: teamName).snapshots();
  }

  Stream<QuerySnapshot> getLoginUser(UserModel loginUser){
    return _firestore.collection(COMPANY).doc(loginUser.companyCode!).collection(USER).where("mail", isEqualTo: loginUser.mail).snapshots();
  }

  Stream<QuerySnapshot> usedVacation(UserModel loginUser,DateTime time) {
    Timestamp _start = _dateFormatCustom.changeDateTimeToTimestamp(
        dateTime: DateTime(time.year, 1, 1, 00, 00, 01));
    Timestamp _end = _dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime(time.year, 12, 31, 23, 59, 59));

    return _firestore.collection(COMPANY).doc(loginUser.companyCode!)
        .collection(WORK)
        .where("createUid", isEqualTo: loginUser.mail)
        .where("startTime", isLessThanOrEqualTo: _end)
        .where("startTime", isGreaterThanOrEqualTo: _start)
        .where("type", whereIn: ['연차', '반차'])
        .orderBy("startTime", descending: false)
        .snapshots();
  }


  Future<bool> createTeam(String companyCode, TeamModel team) async {
    bool result = false;

    await _firestore.collection(COMPANY).doc(companyCode).collection(TEAM).add(team.toJson()).whenComplete(() => result = true);

    return result;
  }

  Future<bool> createPosition(String companyCode, PositionModel position) async {
    bool result = false;

    await _firestore.collection(COMPANY).doc(companyCode).collection(POSITION).add(position.toJson()).whenComplete(() => result = true);

    return result;
  }

  Future<CompanyModel> getVacation(String companyCode) async {
    dynamic doc = await _firestore.collection(COMPANY).doc(companyCode).get();

    CompanyModel model = CompanyModel.fromMap(mapData: doc.data());

    return model;
  }

  Stream<DocumentSnapshot> getCompany(String companyCode) {

    return _firestore.collection(COMPANY).doc(companyCode).snapshots();
  }

  Stream<DocumentSnapshot> getUserVacation(UserModel loginUser) {

    return _firestore.collection(COMPANY).doc(loginUser.companyCode).collection(USER).doc(loginUser.mail).snapshots();
  }

  Stream<EmployeeModel> getEmployeeUser(UserModel loginUser) {
    return _firestore.collection(COMPANY)
        .doc(loginUser.companyCode)
        .collection(USER)
        .doc(loginUser.mail)
        .snapshots()
        .map((snapshot) => EmployeeModel.fromMap(mapData: snapshot.data() as dynamic, reference: snapshot.reference));
  }

  Stream<List<EmployeeModel>> getEmployeeUsers(UserModel loginUser) {
    return _firestore.collection(COMPANY)
        .doc(loginUser.companyCode)
        .collection(USER)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((document) => EmployeeModel.fromMap(mapData: document.data() as dynamic, reference: document.reference))
        .toList());
  }

  Stream<QuerySnapshot> getColleagueAttendance(UserModel loginUser) {
    DateTime now = DateTime.now();

    Timestamp _start = _dateFormatCustom.changeDateTimeToTimestamp(
        dateTime: DateTime(now.year, now.month, now.day, 00, 00, 00));
    Timestamp _end = _dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime(now.year, now.month, now.day, 23, 59, 59));

    return _firestore.collection(COMPANY).doc(loginUser.companyCode).collection(ATTENDANCE)
        .where("createDate", isLessThanOrEqualTo: _end)
        .where("createDate", isGreaterThanOrEqualTo: _start)
        .snapshots();
  }

  Future<WorkModel> getOutWorkLocation(UserModel loginUser, String mail) async {
    DateTime now = DateTime.now();
    late WorkModel model;

    Timestamp _now = _dateFormatCustom.changeDateTimeToTimestamp(
        dateTime: now);

    print("현재시간 : ${_now}");

    await _firestore.collection(COMPANY)
        .doc(loginUser.companyCode!)
        .collection(WORK)
        .where("createUid", isEqualTo: mail)
        .where("endTime", isGreaterThanOrEqualTo: _now)
        .get().then((value) => value.docs.map((e) {
          WorkModel models = WorkModel.fromMap(mapData: e.data());
          if(models.startTime.seconds <= _now.seconds){
            model = WorkModel.fromMap(mapData: e.data());
          }

    }).toList());

    return model;
  }

  Stream<List<ExpenseModel>> getExpense(UserModel loginUser) {
    return _firestore.collection(COMPANY)
        .doc(loginUser.companyCode)
        .collection(USER)
        .doc(loginUser.mail)
        .collection(EXPENSE)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((document) => ExpenseModel.fromMap(mapData: document.data() as dynamic, reference: document.reference))
        .toList());
  }

  Future<void> addExpense(UserModel loginUser, ExpenseModel model) async {
    await _firestore.collection(COMPANY)
        .doc(loginUser.companyCode)
        .collection(USER)
        .doc(loginUser.mail)
        .collection(EXPENSE)
        .add(model.toJson());
  }

}

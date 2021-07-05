import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/fcm/alarmModel.dart';
import 'package:mycompany/public/word/database_name.dart';

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
        result += (element.data() as dynamic)['type'] == '연차'? 1 : 0.5;
      });
    } catch (e) {
      print(e.toString());
    }

    return result;
  }

  Stream<QuerySnapshot> getCompanyUsers(UserModel loginUser){
    return _firestore.collection(COMPANY).doc(loginUser.companyCode!).collection(USER).snapshots();
  }
}

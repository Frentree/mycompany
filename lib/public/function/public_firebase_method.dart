import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/fcm/alarmModel.dart';

class PublicFirebaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PublicFirebaseMethods.settings({persistenceEnabled: true});

  Future<List<String>> getTokensFromUsers(
      UserModel user, String? companyCode, List users) async {
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

  Future<void> saveAlarmDataFromUsersThenSend(
      UserModel user, String? companyCode, List users, var payload) async {

    HttpsCallable callFcm = FirebaseFunctions.instance.httpsCallable('sendFcm');

    users.forEach((_userMail) async {

      int _alarmId = DateTime.now().hashCode;

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
        print("[ERROR] public firebase method : saveAlarmDataFromUsersThenSend");
        print(e.toString());
      }

      /// 알람 전송
      var _user = await _firestore.collection("user").doc(_userMail).get();

      var _payload = <String, dynamic> {
        "tokens": (_user.data() as dynamic)["token"],
        "title": payload["title"],
        "message": payload["message"],
        "route": payload["route"],
        "alarmId": _alarmId.toString(),
      };

      try {
        print(_payload);
        print(_payload["token"].runtimeType);
        await callFcm.call(_payload);
      } catch(e) {
        print("[ERROR] public firebase method : saveAlarmDataFromUsersThenSend");
        print(e.toString());
      }

    });
  }
}

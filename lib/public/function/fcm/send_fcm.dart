// cuND2SpJRb22zxQqkqQO-l:APA91bEOw2Bd8DuHI_OBKmVDeU65DIOL1DnV4i09A_yNIIAhKMmuKdlAGzumGfyDh1pryv9pKhL0aVqggSj5oMqEdhiI6eqx2EiVxOuE84YtJnuXCUhfM-QQzVoFBzGToakkMbcx7bNX

import 'package:cloud_functions/cloud_functions.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/fcm/alarmModel.dart';
import 'package:mycompany/public/function/public_firebase_repository.dart';

Future<void> sendFcmWithTokens(
    UserModel? currentUser, List users, String title, String message, String route) async {

  PublicFirebaseRepository _repository = PublicFirebaseRepository();

  List<String> _tokens;
  String? _companyCode = currentUser!.companyCode;

  /// Method to get user's tokens from firebase for use of FCM
  // _tokens = await _repository.getTokensFromUsers(currentUser, _companyCode, users);

  var payload = <String, dynamic>{
    "title": title,
    "message": message,
    "route": route,
  };

  /// TODO Method to write alarm data to firebase
  _repository.saveAlarmDataFromUsersThenSend(currentUser, _companyCode, users, payload);


  //
  // try {
  //   print(_tokens);
  //   print(title);
  //   print(message);
  //   print(route);
  //   await callFcm.call(payload);
  // } catch (e) {
  //   print("[ERROR] send fcm : sendFcmWithTokens");
  //   print(e.toString());
  // }
}

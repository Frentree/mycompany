
// cuND2SpJRb22zxQqkqQO-l:APA91bEOw2Bd8DuHI_OBKmVDeU65DIOL1DnV4i09A_yNIIAhKMmuKdlAGzumGfyDh1pryv9pKhL0aVqggSj5oMqEdhiI6eqx2EiVxOuE84YtJnuXCUhfM-QQzVoFBzGToakkMbcx7bNX


import 'package:cloud_functions/cloud_functions.dart';

Future<void> sendFcmWithTokens(
    List tokens, String title, String message, String route) async {
  HttpsCallable callFcm = FirebaseFunctions.instance.httpsCallable('sendFcm');

  String alarmId = "alarmId";

  var payload = <String, dynamic>{
    "tokens": tokens,
    "title": title,
    "message": message,
    "alarmId": alarmId,
    "route": route,
  };
  print("send FCM with Tokens");
  print(payload);
  print(payload["title"]);
  print(payload["message"]);

  try {
    await callFcm.call(payload);
  } catch(exception) {
    print(exception.toString());
  }
}



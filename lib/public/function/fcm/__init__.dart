import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/// Enroll mipmap/ic_launcher icon to message icon
AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: null, macOS: null);



void FcmInit() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    Future selectNotification(String? payload) async {
      print('select notification function started');
      print(payload);
    }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

void OnMessage() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("message is : $message");
    print(message.notification);
    print(message.notification!.android);
    print(message.data);
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    print(android?.clickAction);
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: '@mipmap/ic_launcher',
            styleInformation: DefaultStyleInformation(true, true),
            importance: Importance.max,
          ),
        ),
        payload: message.data['alarmId'].toString(),
      );
    }
  });
}



void OnMessageOpenedDo(RemoteMessage message) {
  print('On Message Opened Do function has been started');
  print(message);
  print(message.data);
}

void OnMessageOpenedIos() {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    OnMessageOpenedDo(message);
    // TODO add a proper navigation router here, for bypass to the destination
  });
}

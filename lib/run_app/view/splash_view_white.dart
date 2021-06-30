import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/fcm/__init__.dart';
import 'package:mycompany/public/function/public_firebase_repository.dart';
import 'dart:async';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:provider/provider.dart';
import 'package:mycompany/run_app/view/auth_view.dart';

class SplashViewWhite extends StatefulWidget {
  @override
  SplashViewWhiteState createState() => SplashViewWhiteState();
}

class SplashViewWhiteState extends State<SplashViewWhite> {
  PublicFirebaseRepository _firestore = PublicFirebaseRepository();
  String? _deviceToken;
  bool _requested = false;
  bool _fetching = false;
  late NotificationSettings _settings;
  late UserModel? _user;

  Future<void> requestPermissions() async {
    setState(() {
      _fetching = true;
    });

    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    setState(() {
      _requested = true;
      _fetching = false;
      _settings = settings;
    });
  }

  void setToken(String? token) {
    print('FCM Token: $token');
    setState(() {
      _deviceToken = token;
    });
  }

  @override
  void initState() {
    super.initState();


    /// Get and set device token
    FirebaseMessaging.instance
            .getToken(
            vapidKey:
            'BD93gpQXenmF_dTiN2tcVyf7zKxMxHDkhLAj50jYI6ZI0FDxvPG5jH8xmH0PIagfT3g-HaVdk8wHkM5Rdyf5s5E')
            .then(setToken);

    /// Start firebase messaging service
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("Init State in Splash View White");
        print(message);
        print(message.runtimeType);
        print(message.data);
        _firestore.setAlarmReadToTrue(_user!.companyCode, _user!.mail, message.data["alarmId"]);
        // TODO add a proper navigator here after finish architecture.
      }
    });
    OnMessage();
    OnMessageOpenedIos();
    requestPermissions();

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   print('splash view white');
    //   print(message.notification!.body);
    //   // TODO add a proper navigation router here, for bypass to the destination
    // });

    Timer(Duration(seconds: 3), () => pageMoveAndRemoveBackPage(context: context, pageName: AuthView(deviceToken: _deviceToken,)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    userInfoProvider.loadUserDataToPhone();
    _user = userInfoProvider.getUserData();


    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 105.7.w,
              vertical: 340.7.h,
            ),
            child: SizedBox(
              width: 148.5.w,
              height: 74.53.h,
              child: SvgPicture.asset(
                'assets/images/logo_blue.svg',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

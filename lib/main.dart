import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/run_app/view/splash_view_white.dart';
import 'package:mycompany/run_app/view/splash_view_blue.dart';
import 'package:mycompany/login/view/sign_in_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ko'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 756),
      builder: () => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'NotoSansKR',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        home: SplashViewBlue(),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:mycompany/public/function/fcm/fcm_init.dart';
import 'package:mycompany/run_app/view/permission_request_view.dart';
import 'package:mycompany/run_app/view/splash_view_white.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/run_app/function/permission_function.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black.withOpacity(0),
    statusBarIconBrightness: Brightness.dark,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  bool a = await checkPermissionFunction();

  ///Initialize configurations for Firebase Cloud Messagings
  FcmInit();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ko'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: a ? YesPermission() : NoPermission(),
    )
  );
}

class NoPermission extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserInfoProvider>(
          create: (_) => UserInfoProvider(),
        ),
        ChangeNotifierProvider<EmployeeInfoProvider>(
          create: (_) => EmployeeInfoProvider(),
        )
      ],
      child: ScreenUtilInit(
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

          home: PermissionRequestView(),
        ),
      ),
    );
  }
}

class YesPermission extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserInfoProvider>(
          create: (_) => UserInfoProvider(),
        ),
        ChangeNotifierProvider<EmployeeInfoProvider>(
          create: (_) => EmployeeInfoProvider(),
        )
      ],
      child: ScreenUtilInit(
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

          home: SplashViewWhite(),
        ),
      ),
    );
  }
}


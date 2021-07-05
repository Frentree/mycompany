import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as loc;
import 'package:mycompany/public/provider/device_Info_provider.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/run_app/view/permission_request_view.dart';
import 'package:mycompany/run_app/view/splash_view_white.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/run_app/function/permission_function.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black.withOpacity(0),
    statusBarIconBrightness: Brightness.dark,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: '6LcchGkbAAAAADBFLdIS3DsYbfgLW7ifJUNMlY9v');


  bool isPermissionGranted = await checkPermissionFunction();




  // print('getting network information started');
  // var wifiBSSID = await (NetworkInfo().getWifiBSSID());
  // var wifiIP = await (NetworkInfo().getWifiIP());
  // var wifiName = await (NetworkInfo().getWifiName());
  //
  // sleep(const Duration(seconds:3));
  //
  // print('print information');
  // print(wifiBSSID);
  // print(wifiIP);
  // print(wifiName);
  //
  // print('request permission for location');
  // await Permission.location.request();
  // print(Permission.location);
  // print(await Permission.location.status);
  // await Permission.locationAlways.request();
  // await Permission.locationWhenInUse.request();
  // await Permission.camera.request();






  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ko'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(isPermissionGranted: isPermissionGranted,),
    )
  );
}

class MyApp extends StatelessWidget {
  bool isPermissionGranted;

  MyApp({required this.isPermissionGranted});
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
        ),
        ChangeNotifierProvider<DeviceInfoProvider>(
          create: (_) => DeviceInfoProvider(),
        ),
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

          home: isPermissionGranted ? SplashViewWhite() : PermissionRequestView(),
        ),
      ),
    );
  }
}
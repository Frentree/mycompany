import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public//style/color.dart';
import 'package:mycompany/run_app/view/splash_view_white.dart';

class SplashViewBlue extends StatefulWidget {
  @override
  SplashViewBlueState createState() => SplashViewBlueState();
}

class SplashViewBlueState extends State<SplashViewBlue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color> [
              gradientStartColor,
              gradientEndColor,
            ]
          )
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 105.7.w,
                vertical: 340.7.h,
              ),
              child: GestureDetector(
                child: SizedBox(
                  width: 148.5.w,
                  height: 74.53.h,
                  child: Image.asset('assets/images/logo_white.png'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SplashViewWhite()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
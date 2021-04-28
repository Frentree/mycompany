import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/view/sign_in_view.dart';

class SplashViewWhite extends StatefulWidget {
  @override
  SplashViewWhiteState createState() => SplashViewWhiteState();
}

class SplashViewWhiteState extends State<SplashViewWhite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                child: Image.asset('assets/images/logo_blue.png'),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignInView()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
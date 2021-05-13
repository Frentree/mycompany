import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/view/sign_in_view.dart';
import 'package:mycompany/login/view/sign_up_view.dart';

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
              child: SvgPicture.asset(
                'assets/images/logo_blue.svg',
                width: 148.5.w,
                height: 74.53.h,
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpView()));
              },
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/public/style/color.dart';

Widget getProfileImage({String? ImageUri, required double size}) {
  return ClipOval(
    child: Container(
      color: cirecularLineColor,
      width: (size+1).w,
      height: (size+1).w,
      child: Center(
        child: ClipOval(
          child: Container(
            width: (size).w,
            height: (size).w,
            color: whiteColor,
            child: Center(
              child: ClipOval(
                child: SizedBox(
                  width: size.w,
                  height: size.w,
                  child: ImageUri != '' ?
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/images/logo_blue.png',
                    image: ImageUri!,
                  ) : SvgPicture.asset(
                    'assets/icons/personal.svg',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
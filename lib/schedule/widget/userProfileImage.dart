import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/public/style/color.dart';
import 'dart:io';


Widget getProfileImage({String? ImageUri, required double size}) {
  return ClipOval(
    child: Container(
      color: cirecularLineColor,
      width: (size+1).h,
      height: (size+1).h,
      child: Center(
        child: ClipOval(
          child: Container(
            width: (size).h,
            height: (size).h,
            color: whiteColor,
            child: Center(
              child: ClipOval(
                child: SizedBox(
                  width: size.h,
                  height: size.h,
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

Widget showTempProfileImage({required String imageUri, required double size}) {
  return ClipOval(
    child: Container(
      color: cirecularLineColor,
      width: (size+1).h,
      height: (size+1).h,
      child: Center(
        child: ClipOval(
          child: Container(
            width: (size).h,
            height: (size).h,
            color: whiteColor,
            child: Center(
              child: ClipOval(
                child: SizedBox(
                  width: size.h,
                  height: size.h,
                  child: imageUri == "" ? SvgPicture.asset(
                    'assets/icons/personal.svg',
                  ) : Image.file(File(imageUri)),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
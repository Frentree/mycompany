
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/schedule/model/testcompany_model.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

getClipOverProfile({required BuildContext context, required String ImageUri, String? name, String? mail, required bool isChks, required getDataSource}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        child: Column(
          children: [
            ClipOval(
              child: SizedBox(
                width: 50.0.w,
                height: 50.0.h,
                child: Container(
                  color: isChks ? checkColor : cirecularLineColor,
                  child: Center(
                    child: ClipOval(
                      child: SizedBox(
                        width: 46.0.w,
                        height: 46.0.h,
                        child: Container(
                          color: whiteColor,
                          child: Center(
                            child: ClipOval(
                              child: SizedBox(
                                width: 42.0.w,
                                height: 42.0.h,
                                child: ImageUri != '' ?
                                FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/logo_blue.png',
                                  image: ImageUri,
                                  height: 50.0.h,

                                )
                                : SvgPicture.asset(
                                  'assets/icons/personal.svg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              name!,
              style: TextStyle(
                fontSize: 12.sp,
                color: isChks ? checkColor : textColor,
              ),
            )
          ],
        ),
        onTap: () {
          isChks = !isChks;
          if(isChks){
            if(!mailChkList.contains(mail)){
              mailChkList.add(mail!);
            }
          }else {
            mailChkList.remove(mail!);
          }
          getDataSource();
          setState((){});
        },
      );
    },
  );
}

getTeamProfile({required BuildContext context, String? teamName, required bool isChks, required getDataSource, required List<CompanyUserModel> user}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        child: Column(
          children: [
            ClipOval(
              child: SizedBox(
                width: 50.0.w,
                height: 50.0.h,
                child: Container(
                  color: isChks ? checkColor : cirecularLineColor,
                  child: Center(
                    child: ClipOval(
                      child: SizedBox(
                        width: 46.0.w,
                        height: 46.0.h,
                        child: Container(
                          color: whiteColor,
                          child: Center(
                            child: ClipOval(
                              child: SizedBox(
                                width: 42.0.w,
                                height: 42.0.h,
                                child: SvgPicture.asset(
                                  'assets/icons/icon_team.svg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              teamName!.toString(),
              style: TextStyle(
                fontSize: 12.sp,
                color: isChks ? checkColor : textColor,
              ),
            )
          ],
        ),
        onTap: () {
          isChks = !isChks;
          if(isChks){
            if(!teamChkList.contains(teamName)){
              teamChkList.add(teamName);
            }
            for(var mail in user){
              if(teamName == mail.team){
                if(!mailChkList.contains(mail.mail)){
                  mailChkList.add(mail.mail);
                }
              }else {
                continue;
              }
            }
          }else {
            teamChkList.remove(teamName);
            for(var mail in user){
              if(teamName == mail.team){
                if(mailChkList.contains(mail.mail)){
                  mailChkList.remove(mail.mail);
                }
              }else {
              }
            }
          }
          getDataSource();
          setState((){});
        },
      );
    },
  );
}
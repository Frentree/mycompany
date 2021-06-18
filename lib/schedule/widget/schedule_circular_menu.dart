
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/schedule/model/company_user_model.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

getClipOverProfile({required BuildContext context, required String ImageUri, EmployeeModel? user, required bool isChks, required getDataSource}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        child: Column(
          children: [
            ClipOval(
              child: Container(
                color: isChks ? checkColor : cirecularLineColor,
                width: 50.0.h,
                height: 50.0.h,
                child: Center(
                  child: ClipOval(
                    child: Container(
                      color: whiteColor,
                      width: 46.0.h,
                      height: 46.0.h,
                      child: Center(
                        child: ClipOval(
                          child: SizedBox(
                            width: 42.0.h,
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
            Text(
              user!.name.toString(),
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
            if(!mailChkList.contains(user)){
              mailChkList.add(user);
            }
          }else {
            mailChkList.remove(user);
            if(teamChkList.contains(user)){
              teamChkList.remove(user);
            }
          }
          getDataSource();
          setState((){});
        },
      );
    },
  );
}

getTeamProfile({required BuildContext context, String? teamName, required bool isChks, required getDataSource, required List<EmployeeModel> user}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        child: Column(
          children: [
            ClipOval(
              child: SizedBox(
                width: 50.0.h,
                height: 50.0.h,
                child: Container(
                  color: isChks ? checkColor : cirecularLineColor,
                  child: Center(
                    child: ClipOval(
                      child: SizedBox(
                        width: 46.0.h,
                        height: 46.0.h,
                        child: Container(
                          color: whiteColor,
                          child: Center(
                            child: ClipOval(
                              child: SizedBox(
                                width: 42.0.h,
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
                if(!mailChkList.contains(mail)){
                  mailChkList.add(mail);
                }
              }else {
                continue;
              }
            }
          }else {
            teamChkList.remove(teamName);
            for(var mail in user){
              if(teamName == mail.team){
                if(mailChkList.contains(mail)){
                  mailChkList.remove(mail);
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
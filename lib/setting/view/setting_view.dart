import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/setting/function/setting_function.dart';
import 'package:mycompany/setting/view/setting_team_view.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  PublicFunctionRepository _publicFunctionRepository = PublicFunctionRepository();

  List<String> gridList = ["내정보 수정", "팀 설정", "직급 설정"];

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
        onWillPop: () => _publicFunctionRepository.onScheduleBackPressed(context: context),
        child: Scaffold(
          body: Container(
            width: double.infinity,
            color: whiteColor,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 72.0.h + statusBarHeight,
                width: double.infinity,
                color: whiteColor,
                padding: EdgeInsets.only(top: statusBarHeight, left: 26.0.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        color: whiteColor,
                        width: 20.0.w,
                        height: 30.0.h,
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Container(
                              width: 14.9.w,
                              height: 14.9.h,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: workInsertColor,
                              )),
                        ),
                      ),
                      onTap: () => _publicFunctionRepository.onBackPressed(context: context),
                    ),
                    Text("setting".tr(), style: getNotoSantRegular(fontSize: 18.0, color: textColor)),
                  ],
                ),
              ),
              Expanded(
                child: GridView.custom(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: (1),
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  childrenDelegate: SliverChildListDelegate(
                    getSettingMenu(context: context).map((data) => GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(0.5),
                              color: calendarLineColor.withOpacity(0.1),
                              child: Center(
                                child: Container(
                                  width: 180.0.w,
                                  color: whiteColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      data.menuIcon,
                                      SizedBox(height: 3.0.h,),
                                      Text(data.munuName, style: getNotoSantMedium(fontSize: 12, color: blackColor))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => data.widget!))
                          ),
                        ).toList(),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}

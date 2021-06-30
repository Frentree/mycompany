import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingUnomplementedScreen extends StatefulWidget {
  @override
  _SettingUnomplementedScreenState createState() => _SettingUnomplementedScreenState();
}

class _SettingUnomplementedScreenState extends State<SettingUnomplementedScreen> {

  PublicFunctionRepository _publicFunctionReprository = PublicFunctionRepository();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      //floatingActionButton: getMainCircularMenu(context: context, navigator: 'schedule'),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 72.0.h + statusBarHeight,
              width: double.infinity,
              color: workInsertColor,
              padding: EdgeInsets.only(
                  top: statusBarHeight,
                  left: 26.0.w
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          color: workInsertColor,
                          width: 20.0.w,
                          height: 30.0.h,
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            child: Container(
                                width: 14.9.w,
                                height: 14.9.h,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: whiteColor,
                                )
                            ),
                          ),
                        ),
                        onTap: () => _publicFunctionReprository.onBackPressed(context: context),
                      ),
                      Text(
                          "미구현 화면",
                          style: getNotoSantRegular(
                              fontSize: 18.0,
                              color: whiteColor
                          )
                      ),
                    ],
                  ),
                  Container(

                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    top: 21.0.h,
                    left: 26.0.w,
                    right: 21.0.w
                ),
                child: Text("미구현 화면입니다. 이전페이지로 돌아가주세요")
              ),
            ),
          ],
        ),
      ),
    );
  }
}

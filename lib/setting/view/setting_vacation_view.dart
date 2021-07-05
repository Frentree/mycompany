import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/text_style.dart';

class SettingVacationView extends StatefulWidget {
  @override
  _SettingVacationViewState createState() => _SettingVacationViewState();
}

class _SettingVacationViewState extends State<SettingVacationView> {

  late UserModel loginUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginUser = PublicFunction().getUserProviderSetting(context);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
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
              color: whiteColor,
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
                          color: whiteColor.withOpacity(0),
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
                                )
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      Text(
                          "setting_menu_9".tr(),
                          style: getNotoSantRegular(
                              fontSize: 18.0,
                              color: textColor
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
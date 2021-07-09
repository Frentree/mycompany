import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/function/sign_out_function.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/setting/function/setting_function.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  PublicFunctionRepository _publicFunctionRepository = PublicFunctionRepository();

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    UserModel loginUser = userInfoProvider.getUserData()!;

    return WillPopScope(
        onWillPop: () => _publicFunctionRepository.onScheduleBackPressed(context: context),
        child: Scaffold(
          body: Container(
            width: double.infinity,
            color: whiteColor,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 98.0.h,
                padding: EdgeInsets.only(
                  right: 27.5.w,
                  left: 27.5.w,
                  top: 33.0.h,
                ),
                decoration: BoxDecoration(
                    color: Colors.white, boxShadow: [BoxShadow(color: Color(0xff000000).withOpacity(0.16), blurRadius: 3.0.h, offset: Offset(0.0, 1.0))]),
                child: SizedBox(
                  height: 55.0.h,
                  child: Row(
                    children: [
                      IconButton(
                        constraints: BoxConstraints(),
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                        ),
                        iconSize: 24.0.h,
                        splashRadius: 24.0.r,
                        onPressed: () =>  _publicFunctionRepository.onBackPressed(context: context),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        color: Color(0xff2093F0),
                      ),
                      SizedBox(
                        width: 14.7.w,
                      ),
                      Text(
                        "setting".tr(),
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          fontWeight: fontWeight['Medium'],
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0.h,),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: PublicFirebaseRepository().getLoginUser(loginUser: loginUser),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return Container();
                    }
                    late EmployeeModel employeeModel;

                    List<DocumentSnapshot> docs = snapshot.data!.docs;
                    docs.map((doc) => employeeModel = EmployeeModel.fromMap(mapData: (doc.data() as dynamic))).toList();

                    return GridView.custom(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: (1),
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      childrenDelegate: SliverChildListDelegate(
                        getSettingMenu(context: context, employeeModel: employeeModel).map((data) =>
                           GestureDetector(
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
                              onTap: () async {
                                var result = false;
                                if(data.widget != null) Navigator.push(context, MaterialPageRoute(builder: (context) => data.widget!));
                                else await SignOutFunction().signOutFunction(context: context);
                              }
                          ),
                        ).toList(),
                      ),
                    );
                  }
                ),
              ),
            ]),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/function/join_company_function.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/view/find_company_view.dart';
import 'package:mycompany/login/view/wait_join_company_approval_view.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/login/widget/login_text_form_widget.dart';
import 'package:mycompany/run_app/function/permission_function.dart';
import 'package:mycompany/run_app/view/splash_view_white.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestView extends StatefulWidget {
  @override
  PermissionRequestViewState createState() => PermissionRequestViewState();
}

class PermissionRequestViewState extends State<PermissionRequestView> with WidgetsBindingObserver {
  late AppLifecycleState _notification;

  CompanyModel selectCompany = CompanyModel(companyCode: "", companyName: "", companyAddr: "");

  ValueNotifier<bool> isSelected = ValueNotifier<bool>(false);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    setState(() {
      _notification = state;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*Container(
            padding: EdgeInsets.only(
              left: 27.5.w,
              right: 27.5.w,
              top: 68.0.h,
            ),
            child: SizedBox(
              height: 26.0.h,
              child: Text(
                "MYCOMPANY 이용 안내",
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          ),*/
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 250.0.h,
            ),
            child: SizedBox(
                child: Text(
                  "MYCOMPANY 이용 안내",
                  style: TextStyle(
                    fontSize: 22.0.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                )
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 8.0.h,
            ),
            child: SizedBox(
                child: Text(
                  "MYCOMPANY를 이용하려면\n아래의 권한을 허용해 주세요",
                  style: TextStyle(
                    fontSize: 13.0.sp,
                    fontWeight: fontWeight['Medium'],
                    color: hintTextColor,
                  ),
                  textAlign: TextAlign.center,
                )
            ),
          ),
          ValueListenableBuilder(
            valueListenable: isSelected,
            builder: (BuildContext context, bool value, Widget? child) {
              return Container(
                padding: EdgeInsets.only(
                  left: 27.5.w,
                  right: 27.5.w,
                  top: 44.0.h,
                ),
                child: TextField(
                  onTap: (){
                    isSelected.value = !isSelected.value;
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    helperText: value == false ? null : "회사의 WIFI를 이용해 자동으로 출근처리하기 위하여\n위치 권한 허용이 필요합니다.",
                    hintText: "위치",
                    hintStyle: TextStyle(
                      fontSize: 14.0.sp,
                      color: textColor,
                    ),
                    suffixIcon: Icon(
                      value == false ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_up_outlined,
                      color: textColor,
                    ),
                    suffixIconConstraints: BoxConstraints(),
                  ),
                ),
              );
            },
          ),

          loginElevatedButton(
            topPadding: 45.0.h,
            buttonName: "허용하기",
            buttonAction: () async {
              String k = await requestPermissionFunction();
              print("=========================>>>>> K : $k");
              if(k=="NO"){
                await openAppSettings();
              }
              if(k=="OK"){
                pageMoveAndRemoveBackPage(context: context, pageName: SplashViewWhite());
              }
            }
          ),
        ],
      ),
    );
  }
}
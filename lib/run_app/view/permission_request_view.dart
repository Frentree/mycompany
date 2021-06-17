import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/run_app/function/permission_function.dart';
import 'package:mycompany/run_app/view/splash_view_white.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestView extends StatefulWidget {
  @override
  PermissionRequestViewState createState() => PermissionRequestViewState();
}

class PermissionRequestViewState extends State<PermissionRequestView> with WidgetsBindingObserver {
  late AppLifecycleState _appLifecycleState;

  CompanyModel selectCompany = CompanyModel(companyCode: "", companyName: "", companyAddr: "");

  ValueNotifier<bool> isSelected = ValueNotifier<bool>(false);

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    setState(() {
      _appLifecycleState = state;
    });

    if(_appLifecycleState == AppLifecycleState.resumed){
      bool isPermissionGranted = await checkPermissionFunction();
      if(isPermissionGranted == true){
        pageMoveAndRemoveBackPage(context: context, pageName: SplashViewWhite());
      }
    }
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
              bool isPermissionGranted = await requestPermissionFunction();
              if(isPermissionGranted == false){
                await openAppSettings();
              }
            }
          ),
        ],
      ),
    );
  }
}
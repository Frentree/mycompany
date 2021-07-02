import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/setting/model/wifi_model.dart';
import 'package:provider/provider.dart';
import 'package:network_info_plus/network_info_plus.dart';

class SettingWifiView extends StatefulWidget {
  @override
  SettingWifiViewState createState() => SettingWifiViewState();
}

class SettingWifiViewState extends State<SettingWifiView> {
  PublicFunctionRepository _publicFunctionRepository = PublicFunctionRepository();
  LoginFirestoreRepository _loginFirestoreRepository = LoginFirestoreRepository();

  ValueNotifier<bool> isEdit = ValueNotifier<bool>(false);
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  ValueNotifier<List<WifiModel>> registeredWifiList = ValueNotifier<List<WifiModel>>([]);
  ValueNotifier<List<WifiModel>> registerAbleWifiList = ValueNotifier<List<WifiModel>>([]);

  String? connectedWifiName;

  @override
  Widget build(BuildContext context) {
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);
    EmployeeModel loginEmployeeData = employeeInfoProvider.getEmployeeData()!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 98.0.h,
            padding: EdgeInsets.only(
              right: 27.5.w,
              left: 27.5.w,
              top: 33.0.h,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color(0xff000000).withOpacity(0.16),
                      blurRadius: 3.0.h,
                      offset: Offset(0.0, 1.0)
                  )
                ]
            ),
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
                    onPressed: () async {
                      _publicFunctionRepository.onBackPressed(context: context);
                    },
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    color: Color(0xff2093F0),
                  ),
                  SizedBox(
                    width: 14.7.w,
                  ),
                  Text(
                    "자동 출근 WIFI",
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
          FutureBuilder<List<WifiModel>>(
            future: _loginFirestoreRepository.readWifiData(companyId: loginEmployeeData.companyCode),
            builder: (context, snapshot) {
              if(snapshot.hasData == false || snapshot.data == null){
                return Container();
              }

              snapshot.data!.sort((a, b) => a.wifiName.compareTo(a.wifiName));

              registeredWifiList.value = snapshot.data!;

              return Container(
                padding: EdgeInsets.only(
                  top: 20.0.h,
                ),
                child: ValueListenableBuilder(
                  valueListenable: isEdit,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            right: 27.5.w,
                            left: 27.5.w,
                          ),
                          height: 45.0.h,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "등록된 WIFI",
                                style: getNotoSantBold(fontSize: 14.0.sp, color: textColor),
                              ),
                              IconButton(
                                splashRadius: 20.0.r,
                                icon: Icon(
                                  value == false ? Icons.mode_edit : Icons.check,
                                  color: Color(0xff2093F0),
                                ),
                                onPressed: () async {
                                  selectedIndex.value = 0;
                                  connectedWifiName = await NetworkInfo().getWifiName();

                                  if(connectedWifiName != null){
                                    List<String> _registeredWifiName = [];

                                    registeredWifiList.value.forEach((element) {
                                      _registeredWifiName.add(element.wifiName);
                                    });

                                    if(!_registeredWifiName.contains(connectedWifiName)){
                                      WifiModel connectedWifiModel = WifiModel(
                                        wifiName: connectedWifiName!,
                                        registrantMail: loginEmployeeData.mail,
                                        registrantName: loginEmployeeData.name,
                                      );

                                      registerAbleWifiList.value = List.from(registerAbleWifiList.value)..add(connectedWifiModel);
                                    }
                                  }

                                  isEdit.value = !isEdit.value;
                                },
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: registeredWifiList,
                          builder: (BuildContext context, List<WifiModel> registeredWifiValue, Widget? child) {
                            print(registeredWifiValue.length);
                            if(registeredWifiValue.length == 0){
                              return Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                  right: 27.5.w,
                                  left: 39.5.w,
                                  top: 9.0.h,
                                  bottom: 9.0.h,
                                ),
                                child: Text(
                                  "등록된 WIFI 없음",
                                  style: TextStyle(
                                    fontSize: 13.0.sp,
                                    color: Color(0xff9C9C9C),
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: registeredWifiValue.length,
                              itemBuilder: (context, index){
                                return ValueListenableBuilder(
                                  valueListenable: selectedIndex,
                                  builder: (BuildContext context, int selectedIndexValue, Widget? child) {
                                    return ElevatedButton(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          right: 27.5.w,
                                          left: 39.5.w,
                                          top: 9.0.h,
                                          bottom: 9.0.h,
                                        ),
                                        color: selectedIndexValue == (index + 1) ? Color(0xff2093F0).withOpacity(0.1) : null,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          registeredWifiValue[index].wifiName,
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                                          if (states.contains(MaterialState.disabled)) {
                                            return whiteColor;
                                          }
                                          else {
                                            return whiteColor;
                                          }
                                        }),
                                        elevation: MaterialStateProperty.all(
                                          0.0,
                                        ),
                                        padding: MaterialStateProperty.all(
                                          EdgeInsets.zero,
                                        ),
                                      ),
                                      onPressed: value == false ? null : (){
                                        if(selectedIndexValue == (index + 1)){
                                          selectedIndex.value = 0;
                                        }
                                        else{
                                          selectedIndex.value = (index + 1);
                                        }
                                      },
                                    );
                                  }
                                );
                              },
                            );
                          }
                        ),
                        Visibility(
                          visible: value,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  right: 27.5.w,
                                  left: 27.5.w,
                                ),
                                height: 45.0.h,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "등록가능한 WIFI",
                                  style: getNotoSantBold(fontSize: 14.0.sp, color: textColor),
                                ),
                              ),
                              ValueListenableBuilder(
                                  valueListenable: registerAbleWifiList,
                                  builder: (BuildContext context, List<WifiModel> registerAbleWifiValue, Widget? child) {
                                    print(registerAbleWifiValue.length);
                                    if(registerAbleWifiValue.length == 0){
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                          right: 27.5.w,
                                          left: 39.5.w,
                                          top: 9.0.h,
                                          bottom: 9.0.h,
                                        ),
                                        child: Text(
                                          "등록가능한 WIFI 없음",
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            color: Color(0xff9C9C9C),
                                          ),
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: registerAbleWifiValue.length,
                                      itemBuilder: (context, index){
                                        return ValueListenableBuilder(
                                            valueListenable: selectedIndex,
                                            builder: (BuildContext context, int selectedIndexValue, Widget? child) {
                                              return ElevatedButton(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                    right: 27.5.w,
                                                    left: 39.5.w,
                                                    top: 9.0.h,
                                                    bottom: 9.0.h,
                                                  ),
                                                  color: selectedIndexValue == (index - 1) ? Color(0xff2093F0).withOpacity(0.1) : null,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    registerAbleWifiValue[index].wifiName,
                                                    style: TextStyle(
                                                      fontSize: 13.0.sp,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                    if (states.contains(MaterialState.disabled)) {
                                                      return whiteColor;
                                                    }
                                                    else {
                                                      return whiteColor;
                                                    }
                                                  }),
                                                  elevation: MaterialStateProperty.all(
                                                    0.0,
                                                  ),
                                                  padding: MaterialStateProperty.all(
                                                    EdgeInsets.zero,
                                                  ),
                                                ),
                                                onPressed: value == false ? null : (){
                                                  if(selectedIndexValue == (index - 1)){
                                                    selectedIndex.value = 0;
                                                  }
                                                  else{
                                                    selectedIndex.value = (index - 1);
                                                  }
                                                },
                                              );
                                            }
                                        );
                                      },
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                ),
              );
            },
          ),
        ],
      ),
      bottomSheet: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (BuildContext context, int value, Widget? child){
          return value == 0 ? SizedBox() : BottomSheet(
            elevation: 0.0,
            onClosing: (){},
            builder: (BuildContext context){
              return Container(
                child: Row(
                  children: [
                    bottomSheetButton(
                      buttonName: "취소",
                      buttonNameColor: textColor,
                      buttonColor: Color(0xffF7F7F7),
                      buttonAction: (){
                        selectedIndex.value = 0;
                      }
                    ),
                    bottomSheetButton(
                      buttonName: selectedIndex.value > 0 ? "삭제" : "등록",
                      buttonNameColor: textColor,
                      buttonColor: Color(0xffF7F7F7),
                      buttonAction: selectedIndex.value > 0 ? (){
                        registerAbleWifiList.value = List.from(registeredWifiList.value)..add(registeredWifiList.value[selectedIndex.value]);
                        registeredWifiList.value = List.from(registeredWifiList.value)..removeAt(selectedIndex.value);
                        selectedIndex.value = 0;
                      } : (){},
                    ),
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }
  SizedBox bottomSheetButton({required String buttonName, required Color buttonNameColor, required Color buttonColor, VoidCallback? buttonAction,}){
    return SizedBox(
      width: 180.0.w,
      height: 57.0.h,
      child: ElevatedButton(
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: fontWeight["Medium"],
            color: buttonNameColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0.r)
          ),
        ),
        onPressed: buttonAction,
      ),
    );
  }
}

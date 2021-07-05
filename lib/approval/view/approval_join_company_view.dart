import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/approval/widget/approval_dialog_widget.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/join_company_approval_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:provider/provider.dart';

class ApprovalJoinCompanyView extends StatefulWidget {
  @override
  ApprovalJoinCompanyViewState createState() => ApprovalJoinCompanyViewState();
}

class ApprovalJoinCompanyViewState extends State<ApprovalJoinCompanyView> {
  LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();
  DateFormatCustom dateFormatCustom = DateFormatCustom();

  ValueNotifier<int> selectedIndex = ValueNotifier<int>(-1);

  @override
  Widget build(BuildContext context) {
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);
    EmployeeModel loginEmployeeData = employeeInfoProvider.getEmployeeData()!;

    List<JoinCompanyApprovalModel> joinCompanyApprovalData = [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: loginFirestoreRepository.readJoinCompanyApprovalData(companyId: loginEmployeeData.companyCode),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null){
            return Container();
          }

          joinCompanyApprovalData = [];

          snapshot.data!.docs.forEach((element) {
            joinCompanyApprovalData.add(JoinCompanyApprovalModel.fromMap(mapData: element.data(),documentId: element.id));
          });

          joinCompanyApprovalData.sort((a, b) => a.requestDate.compareTo(b.requestDate));

          return Container(
            child: GridView.builder(
              padding: EdgeInsets.only(
                left: 27.5.w,
                right: 27.5.w,
                top: 20.0.h,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: joinCompanyApprovalData.length,
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: ValueListenableBuilder(
                    valueListenable: selectedIndex,
                    builder: (BuildContext context, int value, Widget? child) {
                      return GestureDetector(
                        onTap: (){
                          if(selectedIndex.value == index){
                            selectedIndex.value = -1;
                          }
                          else{
                            selectedIndex.value = index;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: value != index ? <BoxShadow>[
                              BoxShadow(
                                color: Color(0xff9C9C9C).withOpacity(0.3),
                                offset: Offset(1.0, 15.0),
                                blurRadius: 20.0,
                              ),
                            ] : null,
                            color: value == index ? Color(0xff2093F0).withOpacity(0.1) : whiteColor,
                            borderRadius: BorderRadius.circular(12.0.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0.w,
                                  vertical: 10.0.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff2093F0),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0.r),
                                    topRight: Radius.circular(12.0.r),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      joinCompanyApprovalData[index].name,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 13.0.sp,
                                        fontWeight: fontWeight['Medium'],
                                        color: whiteColor,
                                      ),
                                    ),
                                    Text(
                                      dateFormatCustom.dateStringFormatSeparatorDot(date: joinCompanyApprovalData[index].requestDate),
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Icon(
                                              Icons.cake,
                                              color: textColor,
                                              size: 15.0.w,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: Container(
                                              child: Text(
                                                joinCompanyApprovalData[index].birthday == "" ? "-" : dateFormatCustom.dateStringFormatSeparatorDot(date: dateFormatCustom.changeStringToDateTime(dateString: joinCompanyApprovalData[index].birthday!)),
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13.0.sp,
                                                  fontWeight: fontWeight['Medium'],
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Icon(
                                              Icons.phone,
                                              color: textColor,
                                              size: 15.0.w,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: Container(
                                              child: Text(
                                                joinCompanyApprovalData[index].phone == "" ? "-" : joinCompanyApprovalData[index].phone!,
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13.0.sp,
                                                  fontWeight: fontWeight['Medium'],
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomSheet: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (BuildContext context, int value, Widget? child){
          return value == -1 ? SizedBox() : BottomSheet(
            elevation: 0.0,
            onClosing: (){},
            builder: (BuildContext context){
              return Container(
                child: Row(
                  children: [
                    bottomSheetButton(
                      buttonName: "반려",
                      buttonNameColor: textColor,
                      buttonColor: Color(0xffF7F7F7),
                      buttonAction: (){
                        joinCompanyApprovalData[selectedIndex.value].state = 1;
                        joinCompanyApprovalData[selectedIndex.value].signUpApprover = loginEmployeeData.mail;
                        joinCompanyApprovalData[selectedIndex.value].approvalDate = Timestamp.now();

                        loginFirestoreRepository.updateJoinCompanyApprovalData(companyId: loginEmployeeData.companyCode, joinCompanyApprovalModel: joinCompanyApprovalData[selectedIndex.value]);
                        loginFirestoreRepository.updateUserJoinCompanyState(userMail: joinCompanyApprovalData[selectedIndex.value].mail, state: 3);

                        selectedIndex.value = -1;
                      }
                    ),
                    bottomSheetButton(
                      buttonName: "승인",
                      buttonNameColor: whiteColor,
                      buttonColor: Color(0xff2093F0),
                      buttonAction: () async {
                        List<TeamModel> teamList = await loginFirestoreRepository.readTeamData(companyId: loginEmployeeData.companyCode);
                        List<PositionModel> positionList = await loginFirestoreRepository.readPositionData(companyId: loginEmployeeData.companyCode);
                        EmployeeModel confirmUser = EmployeeModel(
                          mail: joinCompanyApprovalData[selectedIndex.value].mail,
                          name: joinCompanyApprovalData[selectedIndex.value].name,
                          phone: joinCompanyApprovalData[selectedIndex.value].phone,
                          birthday: joinCompanyApprovalData[selectedIndex.value].birthday,
                          companyCode: loginEmployeeData.companyCode,
                          createDate: Timestamp.now(),
                          lastModDate: Timestamp.now(),
                        );

                        confirmUser = await enterEmployeeInformationDialog(
                          context: context,
                          buttonName: "확인",
                          teamList: teamList,
                          positionList: positionList,
                          confirmUser: confirmUser,
                        );

                        if(confirmUser.enteredDate == "" || confirmUser.team == null || confirmUser.position == null){
                          await loginDialogWidget(
                            context: context,
                            message: "직원 정보 입력이 완료되지 않았습니다\n직원 정보 조회 페이지에서\n직원 정보를 수정해주세요.",
                            actions: [
                              loginDialogConfirmButton(
                                buttonName: 'dialogConfirm'.tr(),
                                buttonAction: (){
                                  backPage(context: context);
                                }
                              ),
                            ]
                          );
                        }

                        else{
                          await loginDialogWidget(
                              context: context,
                              message: "직원 정보 입력이 완료되었습니다",
                              actions: [
                                loginDialogConfirmButton(
                                    buttonName: 'dialogConfirm'.tr(),
                                    buttonAction: (){
                                      backPage(context: context);
                                    }
                                ),
                              ]
                          );
                        }

                        joinCompanyApprovalData[selectedIndex.value].state = 1;
                        joinCompanyApprovalData[selectedIndex.value].signUpApprover = loginEmployeeData.mail;
                        joinCompanyApprovalData[selectedIndex.value].approvalDate = Timestamp.now();

                        loginFirestoreRepository.updateJoinCompanyApprovalData(companyId: loginEmployeeData.companyCode, joinCompanyApprovalModel: joinCompanyApprovalData[selectedIndex.value]);
                        loginFirestoreRepository.createEmployeeData(employeeModel: confirmUser);
                        loginFirestoreRepository.updateUserJoinCompanyState(userMail: confirmUser.mail, companyId: confirmUser.companyCode);

                        selectedIndex.value = -1;
                      }
                    ),
                  ],
                ),
              );
            },
          );
        },
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

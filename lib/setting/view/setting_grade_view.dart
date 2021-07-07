import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/schedule/widget/userProfileImage.dart';
import 'package:mycompany/setting/model/grade_model.dart';
import 'package:mycompany/setting/widget/setting_dialog.dart';

class SettingGradeView extends StatefulWidget {
  @override
  _SettingGradeViewState createState() => _SettingGradeViewState();
}

class _SettingGradeViewState extends State<SettingGradeView> {
  late UserModel loginUser;

  List<GradeModel> gradeList = [];

  List<TeamModel> teamList = [];
  List<EmployeeModel> list = [];
  late ValueNotifier<List<EmployeeModel>> employeeList = ValueNotifier<List<EmployeeModel>>(list);

  TextEditingController teamNameContoller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginUser = PublicFunction().getUserProviderSetting(context);

    gradeList.add(GradeModel(gradeLevel: 9, gradeName: "super_admin".tr()));
    gradeList.add(GradeModel(gradeLevel: 8, gradeName: "application_admin".tr()));
    gradeList.add(GradeModel(gradeLevel: 6, gradeName: "work_admin".tr()));
    _getInitSetting();
  }

  _getInitSetting() async {
    List<EmployeeModel> employee = await ScheduleFunctionReprository().getEmployeeMy(companyCode: loginUser.companyCode);
    setState(() {
      employeeList.value = employee;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addTeamDialog(context, loginUser.companyCode!, teamNameContoller),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: whiteColor,
        child: Column(
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
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                    ),
                    SizedBox(
                      width: 14.7.w,
                    ),
                    Text(
                      "grade_setting".tr(),
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
            Expanded(
              child: ListView.builder(
                itemCount: gradeList.length,
                itemBuilder: (context, index) {
                  List<EmployeeModel> list = [];

                  employeeList.value.map((data) {
                    if(data.level!.contains(gradeList[index].gradeLevel)){
                      list.add(data);
                    }
                  }).toList();

                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 35.0.h,
                        padding: EdgeInsets.only(left: 23.0.w, right: 20.0.w),
                        color: calendarLineColor.withOpacity(0.1),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/icons/colleague.svg',
                                      width: 20.0.w,
                                      height: 20.0.h,
                                      color: workInsertColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.0.w,
                                  ),
                                  Text(
                                    gradeList[index].gradeName,
                                    style: getNotoSantBold(fontSize: 14.0.sp, color: textColor),
                                  )
                                ],
                              ),
                              PopupMenuButton<int>(
                                padding: EdgeInsets.all(0),
                                icon: Icon(Icons.settings),
                                itemBuilder: (context) =>
                                [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Text(
                                      "position_menu_2".tr(),
                                      style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      "position_menu_4".tr(),
                                      style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                                    ),
                                  ),
                                ],
                                onSelected: (value) async {
                                  print(value.toString());
                                  var result = false;
                                  switch (value) {
                                    case 0:
                                      result = await addGradeUserDialog(context, gradeList[index], employeeList.value, list);
                                      break;
                                    case 1:
                                      result = await deleteGradeUserDialog(context, list, gradeList[index]);
                                      break;
                                  }

                                  if (result) {
                                    _getInitSetting();
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0.h,
                      ),
                      Container(
                        height: list.length * 48.0.h,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Container(
                                width: double.infinity,
                                height: 48.0.h,
                                padding: EdgeInsets.symmetric(horizontal: 26.0.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        getProfileImage(
                                          size: 36,
                                          ImageUri: list[index].profilePhoto.toString(),
                                        ),
                                        SizedBox(
                                          width: 6.0.w,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              list[index].name,
                                              style: getNotoSantBold(fontSize: 14.0, color: textColor),
                                            ),
                                            Text(
                                              list[index].position!,
                                              style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

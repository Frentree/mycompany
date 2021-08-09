import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/function/vacation/vacation.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/db/schedule_firestore_repository.dart';
import 'package:mycompany/schedule/function/calender_method.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/schedule/model/work_model.dart';
import 'package:mycompany/schedule/widget/schedule_insert_widget.dart';
import 'package:provider/provider.dart';

class ScheduleRegisrationView extends StatefulWidget {
  DateTime? choiseDate;

  ScheduleRegisrationView({this.choiseDate});

  @override
  _ScheduleRegisrationViewState createState() => _ScheduleRegisrationViewState();
}

class _ScheduleRegisrationViewState extends State<ScheduleRegisrationView> {
  PublicFunctionRepository _publicFunctionReprository = PublicFunctionRepository();

  // 전체 팀
  List<TeamModel> teamList = <TeamModel>[];

  // 전체 직원
  List<EmployeeModel> employeeList = <EmployeeModel>[];

  // 선택된 직원
  List<EmployeeModel> workColleagueChkList = [];

  // 선택된 팀
  List<String> workTeamChkList = [];

  late UserModel loginUser;

  // 반차(오후&연차)
  ValueNotifier<bool> _isHalfway = ValueNotifier<bool>(false);

  // 연차 갯수(총연차, 사용연차, 회사 연차 설정상태)
  ValueNotifier<double> totalVacation = ValueNotifier<double>(0);
  ValueNotifier<double> useVacation = ValueNotifier<double>(0);
  ValueNotifier<bool> companyVacation = ValueNotifier<bool>(false);

  _getPersonalDataSource() async {
    List<TeamModel> team = await ScheduleFunctionReprository().getTeam(companyCode: loginUser.companyCode);
    List<EmployeeModel> employee = await ScheduleFunctionReprository().getEmployee(loginUser: loginUser);
    CompanyModel company = await PublicFirebaseRepository().getVacation(companyCode: loginUser.companyCode!);

    companyVacation.value = company.vacation!;

    setState(() {
      teamList = team;
      employeeList = employee;
    });
  }

  //settings
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  DateTime timeZone = DateTime.now();

  late DateTime startTime;
  late DateTime endTime;
  late ValueNotifier<DateTime> _startDateTime;
  late ValueNotifier<DateTime> _endDateTime;

  ValueNotifier<bool> _isAllDay = ValueNotifier<bool>(false);

  EmployeeModel defaultEmpUser = EmployeeModel(mail: "", name: "", companyCode: "", userSearch: [], createDate: Timestamp.now());

  // 결재자
  late ValueNotifier<EmployeeModel> approvalUser = ValueNotifier<EmployeeModel>(defaultEmpUser);

  List workNames = [
    "internal_work".tr(),
    "outside_work".tr(),
    "task_request".tr(),
    "home_job".tr(),
    "annual".tr(),
    //"외출",
    "meeting".tr(),
    "other".tr(),
  ];

  List works = [
    "내근",
    "외근",
    "요청",
    "재택",
    "연차",
    //"외출",
    "미팅",
    "기타",
  ];
  int workChkCount = 0;

  late ScrollController _scrollController;

  @override
  void initState() {
    if(widget.choiseDate != null) {
      startTime = DateTime(widget.choiseDate!.year, widget.choiseDate!.month, widget.choiseDate!.day, timeZone.hour + 1, 0, 0);
      endTime = DateTime(widget.choiseDate!.year, widget.choiseDate!.month, widget.choiseDate!.day, timeZone.hour + 2, 0, 0);
      _startDateTime = ValueNotifier<DateTime>(startTime);
      _endDateTime = ValueNotifier<DateTime>(endTime);
    } else {
      startTime = DateTime(timeZone.year, timeZone.month, timeZone.day, timeZone.hour + 1, 0, 0);
      endTime = DateTime(timeZone.year, timeZone.month, timeZone.day, timeZone.hour + 2, 0, 0);
      _startDateTime = ValueNotifier<DateTime>(startTime);
      _endDateTime = ValueNotifier<DateTime>(endTime);
    }

    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
    loginUser = PublicFunction().getUserProviderSetting(context);
    _getPersonalDataSource();

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isHalfway.dispose();
    _isAllDay.dispose();
    totalVacation.dispose();
    useVacation.dispose();
    companyVacation.dispose();
    _scrollController.dispose();
    titleController.dispose();
    noteController.dispose();
    locationController.dispose();
    _startDateTime.dispose();
    _endDateTime.dispose();
    approvalUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EmployeeModel loginEmployee = Provider.of<EmployeeModel>(context);

    totalVacation.value = TotalVacation(loginEmployee.enteredDate!, companyVacation.value, 0);

    return WillPopScope(
      onWillPop: () => _publicFunctionReprository.onBackPressed(context: context),
      child: Scaffold(
        //floatingActionButton: getMainCircularMenu(context: context, navigator: 'schedule'),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 98.0.h,
                  padding: EdgeInsets.only(
                    left: 27.5.w,
                    top: 33.0.h,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Color(0xff000000).withOpacity(0.16), blurRadius: 3.0.h, offset: Offset(0.0, 1.0))]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
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
                              onPressed: () => _publicFunctionReprository.onBackPressed(context: context),
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerLeft,
                              color: Color(0xff2093F0),
                            ),
                            SizedBox(
                              width: 14.7.w,
                            ),
                            Text(
                              "registering_a_schedule".tr(),
                              style: TextStyle(
                                fontSize: 18.0.sp,
                                fontWeight: fontWeight['Medium'],
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                          child: Container(
                            width: 50.0.w,
                            height: 20.0.h,
                            alignment: Alignment.centerRight,
                            color: whiteColor.withOpacity(0),
                            padding: EdgeInsets.only(right: 27.0.w),
                            child: SvgPicture.asset(
                              'assets/icons/check.svg',
                              width: 23.51.w,
                              height: 13.37.h,
                              color: Color(0xff2093F0),
                            ),
                          ),
                          onTap: () async {
                            List<Map<String, String>>? colleaguesList;

                            if (workColleagueChkList.length != 0) {
                              colleaguesList = [
                                {loginUser.mail: loginUser.name}
                              ];
                              workColleagueChkList.map((e) {
                                Map<String, String> map = {e.mail.toString(): e.name.toString()};
                                colleaguesList!.add(map);
                              }).toList();
                            }

                            if (loginEmployee.level!.contains(9) && works[workChkCount] != "요청") {
                              WorkModel workModel = WorkModel(
                                allDay: _isAllDay.value,
                                type: works[workChkCount],
                                title: titleController.text,
                                contents: noteController.text,
                                location: locationController.text,
                                startTime: Timestamp.fromDate(_startDateTime.value),
                                endTime: Timestamp.fromDate(_startDateTime.value),
                                colleagues: colleaguesList,
                                name: loginEmployee.name,
                                createUid: loginEmployee.mail,
                              );

                              ScheduleFirebaseReository().insertAdminSchedule(loginEmployee: loginEmployee, model: workModel);

                              _publicFunctionReprository.onBackPressed(context: context);
                            } else {
                              var result = await CalenderMethod().insertSchedule(
                                  allDay: _isAllDay.value,
                                  workName: works[workChkCount],
                                  title: titleController.text,
                                  content: noteController.text,
                                  startTime: _startDateTime.value,
                                  endTime: _endDateTime.value,
                                  colleaguesList: colleaguesList,
                                  isAllDay: _isAllDay.value,
                                  location: locationController.text,
                                  approvalUser: approvalUser.value,
                                  loginUser: loginUser);

                              if (result) {
                                _publicFunctionReprository.onBackPressed(context: context);
                              } else {
                                loginDialogWidget(context: context, message: "결재자를 선택해주세요.", actions: [
                                  confirmElevatedButton(
                                      topPadding: 81.0.h,
                                      buttonName: "dialogConfirm".tr(),
                                      buttonAction: () => Navigator.pop(context),
                                      customWidth: 200.0,
                                      customHeight: 40.0.h),
                                ]);
                              }
                            }
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 21.0.h, left: 26.0.w, right: 21.0.w),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 40.0.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              itemCount: workNames.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Container(
                                      height: 37.0.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(17.0.r)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            blurRadius: 0.r,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                                              if (workChkCount != index) {
                                                return whiteColor;
                                              } else {
                                                return workInsertColor;
                                              }
                                            }),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.0.r),
                                              ),
                                            ),
                                            shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                                            elevation: MaterialStateProperty.all(
                                              0.0,
                                            )),
                                        child: Text(workNames[index],
                                            style: getNotoSantMedium(fontSize: 13.0, color: workChkCount != index ? calendarLineColor : whiteColor)),
                                        onPressed: () {
                                          // 결재자
                                          approvalUser.value = defaultEmpUser;

                                          if (works[index] == "연차") {
                                            _isAllDay.value = true;
                                            _isHalfway.value = false;
                                            _startDateTime.value = DateTime(_startDateTime.value.year, _startDateTime.value.month, _startDateTime.value.day, 9, 0, 0);
                                            _endDateTime.value = DateTime(_endDateTime.value.year, _endDateTime.value.month, _endDateTime.value.day, 18, 0, 0);
                                          }
                                          /* else {
                                            _startDateTime.value = DateTime(timeZone.year, timeZone.month, timeZone.day, timeZone.hour + 1, 0, 0);
                                            _endDateTime.value = DateTime(timeZone.year, timeZone.month, timeZone.day, timeZone.hour + 2, 0, 0);
                                          }*/
                                          setState(() {
                                            workChkCount = index;
                                          });
                                        },
                                      ),
                                    ));
                              },
                            )),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              width: 309.0.w,
                              child: ScheduleInsertWidget(
                                loginEmployee: loginEmployee,
                                workName: works[workChkCount],
                                isAllDay: _isAllDay,
                                isHalfway: _isHalfway,
                                locationController: locationController,
                                titleController: titleController,
                                noteController: noteController,
                                startDateTime: _startDateTime,
                                endDateTime: _endDateTime,
                                employeeList: employeeList,
                                teamList: teamList,
                                workColleagueChkList: workColleagueChkList,
                                workTeamChkList: workTeamChkList,
                                approvalUser: approvalUser,
                                companyCode: loginUser.companyCode!,
                                companyVacation: companyVacation,
                                totalVacation: totalVacation,
                                useVacation: useVacation,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

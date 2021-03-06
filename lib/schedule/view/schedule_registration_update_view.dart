import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/function/calender_method.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/schedule/widget/schedule_insert_widget.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class ScheduleRegisrationUpdateView extends StatefulWidget {
  final String documentId;
  final Appointment appointment;

  ScheduleRegisrationUpdateView({required this.documentId,required this.appointment});

  @override
  _ScheduleRegisrationUpdateViewState createState() => _ScheduleRegisrationUpdateViewState();
}

class _ScheduleRegisrationUpdateViewState extends State<ScheduleRegisrationUpdateView> {
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
  late EmployeeModel loginEmployee;

  _getPersonalDataSource() async {
    List<TeamModel> team = await ScheduleFunctionReprository().getTeam(companyCode: loginUser.companyCode);
    List<EmployeeModel> employee = await ScheduleFunctionReprository().getEmployee(loginUser: loginUser);

    setState(() {
      teamList = team;
      employeeList = employee;

      if(widget.appointment.colleagues != null){
        widget.appointment.colleagues!.map((val) {
          employeeList.map((e) {
            if(e.mail == val){
              workColleagueChkList.add(e);
            }
          }).toList();
        }).toList();
      }
    });
  }

  //settings
  late TextEditingController titleController;
  late TextEditingController noteController;
  late TextEditingController locationController;

  DateTime timeZone = DateTime.now();

  late ValueNotifier<DateTime> _startDateTime;
  late ValueNotifier<DateTime> _endDateTime;
  late ValueNotifier<bool> _isAllDay;
  late ValueNotifier<bool> _isHalfway = ValueNotifier<bool>(false);


  EmployeeModel defaultEmpUser = EmployeeModel(mail: "", name: "", companyCode: "", userSearch: [], createDate: Timestamp.now());

  // 결재자
  late ValueNotifier<EmployeeModel> approvalUser = ValueNotifier<EmployeeModel>(defaultEmpUser);

  List workNames = [
    "internal_work".tr(),
    "outside_work".tr(),
    "task_request".tr(),
//    "home_job".tr(),
//    "annual".tr(),
    //"외출",
    "meeting".tr(),
    "other".tr(),
  ];

  List works = [
    "내근",
    "외근",
    "요청",
//    "재택",
//    "연차",
    //"외출",
    "미팅",
    "기타",
  ];
  int workChkCount = 0;

  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
    _getPersonalDataSource();

    loginUser = PublicFunction().getUserProviderSetting(context);
    loginEmployee= PublicFunction().getEmployeeProviderSetting(context);

    workChkCount = works.indexOf(widget.appointment.type.toString());
    _startDateTime = ValueNotifier<DateTime>(widget.appointment.startTime);
    _endDateTime = ValueNotifier<DateTime>(widget.appointment.endTime);
    _isAllDay = ValueNotifier<bool>(widget.appointment.isAllDay);
    titleController = TextEditingController();
    noteController = TextEditingController();
    locationController = TextEditingController();

    titleController.text = widget.appointment.title!;
    noteController.text = widget.appointment.content ?? "";
    locationController.text = widget.appointment.location ?? "";

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () => _publicFunctionReprository.onBackPressed(context: context),
      child: Scaffold(
        //floatingActionButton: getMainCircularMenu(context: context, navigator: 'schedule'),
        body: RefreshIndicator(
          onRefresh: () => _getPersonalDataSource(),
          child: Container(
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
                              "schedule_modification".tr(),
                              style: getNotoSantRegular(
                                  fontSize: 18.0,
                                  color: whiteColor
                              )
                          ),
                        ],
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
                            width: 16.51.w,
                            height: 11.37.h,
                            color: whiteColor,
                          ),
                        ),
                        onTap: () async {
                          var result = await CalenderMethod().updateSchedule(
                            documentId: widget.documentId,
                            companyCode: loginUser.companyCode.toString(),
                            allDay: _isAllDay.value,
                            workName: works[workChkCount],
                            title: titleController.text,
                            content: noteController.text,
                            startTime: _startDateTime.value,
                            endTime: _endDateTime.value,
                            workColleagueChkList: workColleagueChkList,
                            isAllDay: _isAllDay.value,
                            location: locationController.text,
                            approvalUser: approvalUser.value,
                            loginUser: loginUser
                          );

                          if(result){
                            _publicFunctionReprository.onBackPressed(context: context);
                          } else {
                            loginDialogWidget(
                                context: context,
                                message: "결재자를 선택해주세요.",
                                actions: [
                                  confirmElevatedButton(
                                      topPadding: 81.0.h,
                                      buttonName: "dialogConfirm".tr(),
                                      buttonAction: () => Navigator.pop(context),
                                      customWidth: 200.0,
                                      customHeight: 40.0.h
                                  ),
                                ]
                            );
                          }
                        }

                      ),
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
                                      //width: 58.0.w,
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
                                        child: Text(
                                          workNames[index],
                                          style: getNotoSantMedium(
                                              fontSize: 13.0,
                                              color: workChkCount != index ? calendarLineColor : whiteColor
                                          )
                                        ),
                                        onPressed: () {
                                          // 결재자
                                          approvalUser.value = defaultEmpUser;
                                          _isAllDay.value = false;
                                          _isHalfway.value = false;

                                          if(workNames[index] == "annual".tr()){
                                            _startDateTime.value = DateTime(timeZone.year, timeZone.month, timeZone.day, 9, 0, 0);
                                            _endDateTime.value = DateTime(timeZone.year, timeZone.month, timeZone.day, 18, 0, 0);
                                          } else {
                                            _startDateTime.value = DateTime(timeZone.year, timeZone.month, timeZone.day, timeZone.hour + 1, 0, 0);
                                            _endDateTime.value = DateTime(timeZone.year, timeZone.month, timeZone.day, timeZone.hour + 2, 0, 0);
                                          }
                                          setState(() {
                                            workChkCount = index;
                                          });
                                        },
                                      ),
                                    ));
                              },
                            )
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              width: 309.0.w,
                              child: ScheduleInsertWidget(
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

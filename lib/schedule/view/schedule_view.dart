import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/inquiry/view/inquiry_view.dart';
import 'package:mycompany/login/function/sign_out_function.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/public/widget/public_widget.dart';
import 'package:mycompany/schedule/function/calender_method.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/schedule/model/schedule_model.dart';
import 'package:mycompany/schedule/widget/cirecular_button_menu.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_picker_widget.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_theme.dart';
import 'package:mycompany/schedule/widget/schedule_calender_widget.dart';
import 'package:mycompany/schedule/widget/schedule_circular_menu.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class ScheduleView extends StatefulWidget {
  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {

  List<Appointment> scheduleList = <Appointment>[];
  List<TeamModel> teamList = <TeamModel>[];
  List<EmployeeModel> employeeList = <EmployeeModel>[];
  List<CalendarResource> resource = <CalendarResource>[];

  ValueNotifier<bool> isMenu = ValueNotifier<bool>(true);

  bool _isDatePopup = false;           // 스케줄 날자 선택 창
  bool _isColleague = false;           // 동료 선택 창
  bool _isColleagueChk = false;        // 동료 전체 선택
  bool _isTeamAndEmployeeChk = false;  // 부서 & 직원 선택
  bool isToggleChk = true;

  late CalendarController _controller;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late GlobalKey<CircularMenuState> _circularKey;

  String _headerText = '';
  DateTime _time = DateTime.now();

  late UserModel loginUser;
  late EmployeeModel loginEmployee;


  @override
  void initState() {
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _circularKey = GlobalKey<CircularMenuState>();
    _controller = CalendarController();

    super.initState();
    loginUser = PublicFunction().getUserProviderSetting(context);
    loginEmployee= PublicFunction().getEmployeeProviderSetting(context);

    if(loginUser != null){
      mailChkList.add(loginUser.mail);
    }

    _getInitSetting();
    setState(() {});
  }


  @override
  void dispose() {
    _controller.dispose();
    isMenu.dispose();
    super.dispose();
  }

  _getResetChose() {
    mailChkList = [];
  }


  _getInitSetting() async {
    List<EmployeeModel> employee = await ScheduleFunctionReprository().getEmployeeMy(companyCode: loginUser.companyCode);
    List<Appointment> schedules = await CalenderMethod().getSheduleData(companyCode: loginUser.companyCode.toString(), empList: employee);
    List<TeamModel> team = await ScheduleFunctionReprository().getTeam(companyCode: loginUser.companyCode);
    setState(() {
      scheduleList = schedules;
      employeeList = employee;
      teamList = team;
    });
  }

  _getDataSource() async {
    List<Appointment> schedules = await CalenderMethod().getSheduleData(companyCode: loginUser.companyCode.toString(), empList: employeeList);
    // await ScheduleFirebaseReository().workColleaguesUpdate(companyCode: loginUser!.companyCode.toString());

    setState(() {
      scheduleList = schedules;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () async {
        var result = await loginDialogWidget(
            context: context,
            message: "앱을 종료하시겠습니까?",
            actions: [
              confirmElevatedButton(
                  topPadding: 81.0.h,
                  buttonName: "dialogConfirm".tr(),
                  buttonAction: () => Navigator.pop(context, true),
                  customWidth: 80.0,
                  customHeight: 40.0
              ),
              confirmElevatedButton(
                  topPadding: 81.0.h,
                  buttonName: "dialogCancel".tr(),
                  buttonAction: () => Navigator.pop(context, false),
                  customWidth: 80.0,
                  customHeight: 40.0
              ),
            ]
        );

        if(result == true) {
          SystemNavigator.pop();
        }
        return result;
      },
      child: Scaffold(
        key: _scaffoldKey,
        //floatingActionButton: getMainCircularMenu(context: context, navigator: 'home', isToggleChk: false),
        drawer: Drawer(
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: (){
                SignOutFunction().signOutFunction(context: context);
              },
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => _getDataSource(),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: statusBarHeight + 10.0.h, left: 16.0.w, right: 16.0.w),
                color: whiteColor,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Container(
                      color: whiteColor,
                      width: double.infinity,
                      height: 52.0.h,
                      child: _isColleague ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Container(
                              color: whiteColor,
                              width: 60.0.w,
                              height: 30.0.h,
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                child: Container(
                                  child: SvgPicture.asset(
                                    'assets/icons/close.svg',
                                    width: 13.17.w,
                                    height: 13.17.h,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _isColleague = !_isColleague;
                              });
                            },
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                child: Text(
                                  _isColleagueChk ? "deselect".tr() : "select_all".tr(),
                                  style: TextStyle(
                                    color: _isColleagueChk ? checkColor : textColor,
                                    fontSize: 12.sp,
                                    /*fontWeight: FontWeight.w600*/
                                  ),
                                ),
                                onTap: () {
                                  _isColleagueChk = !_isColleagueChk;
                                  // 팀 선택일때
                                  if(!_isTeamAndEmployeeChk) {

                                    if(_isColleagueChk) {
                                      _getResetChose();
                                      for(var team in teamList){
                                        teamChkList.add(team.teamName.toString());
                                      }
                                      for(var emp in employeeList){
                                        if(!mailChkList.contains(emp.mail)){
                                          mailChkList.add(emp.mail);
                                        }
                                      }
                                    }else {
                                      teamChkList.clear();
                                      _getResetChose();
                                    }
                                  } else {   //직원 선택일떄
                                    if(_isColleagueChk) {
                                      for(var emp in employeeList){
                                        if(!mailChkList.contains(emp.mail)){
                                          mailChkList.add(emp.mail);
                                        }
                                      }
                                    }else {
                                      teamChkList.clear();
                                      _getResetChose();
                                    }
                                  }

                                  _getDataSource();
                                  setState(() {});
                                },
                              ),
                              SizedBox(
                                width: 18.0.w,
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50.0.h,
                                      child: SizedBox(
                                        width: 16.51.w,
                                        height: 11.37.h,
                                        child: SvgPicture.asset(
                                          'assets/icons/switch.svg',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.0.w,
                                    ),
                                    Text(
                                      _isTeamAndEmployeeChk ? "department".tr() : "employee".tr(),
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12.sp,
                                        /*fontWeight: FontWeight.w600*/
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _isTeamAndEmployeeChk = !_isTeamAndEmployeeChk;
                                    _isColleagueChk = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ) :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: SvgPicture.asset(
                              'assets/icons/menu_icon.svg',
                              width: 24.0.w,
                              height: 24.0.h,
                            ),
                            onTap: () => _scaffoldKey.currentState!.openDrawer(),
                          ),
                          GestureDetector(
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    _headerText,
                                    textAlign: TextAlign.center,
                                    style: getRobotoBold(
                                        fontSize: 21.0,
                                        color: checkColor
                                    ),
                                  ),
                                  Icon(
                                    _isDatePopup ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    color: checkColor,
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _isDatePopup = !_isDatePopup;
                              });
                            },
                          ),

                          Row(
                            children: [
                              GestureDetector(
                                child: SvgPicture.asset(
                                  'assets/icons/refresh.svg',
                                  width: 20.0.w,
                                  height: 20.0.h,
                                  color: workInsertColor,
                                ),
                                onTap: () {
                                  _getDataSource();
                                  setState(() {});
                                },
                              ),
                              SizedBox(width: 20.0.w,),
                              GestureDetector(
                                child: SvgPicture.asset(
                                  'assets/icons/user_add.svg',
                                  width: 27.8.w,
                                  height: 23.76.h,
                                ),
                                onTap: () {
                                  setState(() {
                                    _isColleague = !_isColleague;
                                    _isDatePopup = false;
                                  });
                                },
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20.0.h),
                            child: SfCalendar(
                              //allowViewNavigation: true,
                              controller: _controller,
                              showDatePickerButton: true,
                              showNavigationArrow: false,
                              dataSource: ScheduleModel(scheduleList),
                              view: CalendarView.month,
                              headerDateFormat: 'yyyy.MM',
                              headerHeight: 0.0.h,
                              //monthCellBuilder: (context, details) => ScheduleCalenderWidget().setMonthCellBuilder(context, details, _controller),
                              appointmentBuilder: (context, details) => ScheduleCalenderWidget().setAppointMentBuilder(context: context, details: details, selectTime: _time),
                              //cellBorderColor: whiteColor,
                              monthViewSettings: MonthViewSettings(
                                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                                appointmentDisplayCount: 5,
                                showTrailingAndLeadingDates: true,
                                /*monthCellStyle: MonthCellStyle(
                                    textStyle: TextStyle(fontSize: 9.sp, color: Colors.black87, fontFamily: 'Roboto'),
                                    trailingDatesTextStyle: TextStyle(fontSize: 9.sp, color: calenderLineColor.withOpacity(0.6), fontFamily: 'Roboto'),
                                    leadingDatesTextStyle: TextStyle(fontSize: 9.sp, color: calenderLineColor.withOpacity(0.6), fontFamily: 'Roboto'),
                                  ),*/
                              ),
                              onViewChanged: (viewChangedDetails) {
                                if (_controller.view == CalendarView.month) {
                                  _headerText =  DateFormat('yyyy.MM').format(viewChangedDetails.visibleDates[viewChangedDetails.visibleDates.length ~/ 2]).toString();
                                  _time = DateTime.parse(viewChangedDetails.visibleDates[viewChangedDetails.visibleDates.length ~/ 2].toString());
                                }
                                SchedulerBinding.instance!.addPostFrameCallback((duration) {
                                  setState(() {});
                                });
                              },
                              todayHighlightColor: checkColor,
                              onTap: (CalendarTapDetails details) => CalenderMethod().getScheduleDetail(details: details, context: context, employeeList: employeeList),
                            ),
                          ),
                          _isDatePopup ? Container(
                            height: 200.0.h,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: calendarLineColor.withOpacity(0.1),
                                        width: 0.5.w
                                    )
                                )
                            ),
                            child: DatePickerWidget(
                              dateFormat: "yyyy MM",
                              minDateTime: DateTime(1900),
                              maxDateTime: DateTime(3000),
                              onMonthChangeStartWithFirstDate: true,
                              pickerTheme: DateTimePickerTheme(
                                pickerHeight: 200.0.h,
                                showTitle: false,
                              ),
                              locale: DateTimePickerLocale.ko,
                              initialDateTime: _time,
                              onCancel: () {},
                              onConfirm: (dateTime, selectedIndex) {},
                              onChange: (dateTime, selectedIndex) {
                                _controller.displayDate = dateTime;
                              },
                            ),
                          )
                              : Container(),
                          _isColleague ? Container(
                              width: double.infinity,
                              height: 83.0.h,
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: calendarLineColor.withOpacity(0.1),
                                          width: 0.5.w
                                      )
                                  )
                              ),
                              child: _isTeamAndEmployeeChk ?
                              ListView(
                                scrollDirection: Axis.horizontal,
                                children: employeeList.map((data) => _buildColleague(
                                  context: context,
                                  data: data,
                                  getDataSource: _getDataSource,
                                  isTeamAndEmployeeChk: _isTeamAndEmployeeChk,
                                )).toList(),
                              ) : ListView(
                                scrollDirection: Axis.horizontal,
                                children: teamList.map((data) => _buildColleague(
                                    context: context,
                                    data: data,
                                    getDataSource: _getDataSource,
                                    isTeamAndEmployeeChk: _isTeamAndEmployeeChk,
                                    user: employeeList
                                )).toList(),
                              )
                          ) : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: ApprovalFirebaseRepository().getResponseApprovalDataCount(loginUser: loginUser),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Container();
                    }

                    List<DocumentSnapshot> docs = snapshot.data!.docs;

                    return Positioned(
                      right: 10.0.w,
                      bottom: 70.0.h,
                      child: (docs.length != 0) ? Stack(
                        children: [
                          FloatingActionButton(
                            backgroundColor: blackColor,
                            child: Icon(
                                Icons.mail
                            ),
                            onPressed: () => PublicFunctionRepository().mainNavigator(context: context, navigator: InquiryView(approvalChk: true,), isMove: false)),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: new Container(
                                padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 5.0.w),
                                constraints: BoxConstraints(
                                  minWidth: 4.0.w,
                                ),
                                decoration: BoxDecoration(
                                  color: errorTextColor,
                                  borderRadius: BorderRadius.circular(5.0.r),
                                ),
                                child: Text(
                                  docs.length.toString(),
                                  style: getNotoSantRegular(fontSize: 10, color: whiteColor),
                                  textAlign: TextAlign.center,
                                )
                            ),
                          ),
                        ],
                      ) : Container(),
                    );
                  }
              ),
              getMainCircularMenu(context: context, isMenu: isMenu, key: _circularKey),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> mailChkList = [];
List<String> teamChkList = [];

Widget _buildColleague({
  required BuildContext context,
  required data,
  required getDataSource,
  required bool isTeamAndEmployeeChk,
  List<EmployeeModel>? user
}) {
  return Row(
    /*mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,*/
    children: [
      isTeamAndEmployeeChk ? getClipOverProfile(
          context: context,
          ImageUri: data.profilePhoto ?? '',
          user: data,
          isChks: mailChkList.contains(data.mail),
          getDataSource: getDataSource
      ) : getTeamProfile(
          context: context,
          getDataSource: getDataSource,
          isChks: teamChkList.contains(data.teamName),
          teamName: data.teamName,
          user: user!
      ),
      SizedBox(width: 26.0.w,)
    ],
  );

}

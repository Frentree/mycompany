/*


import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/style/loing_style_repository.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/widget/main_menu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';

class ScheduleRegisrationView extends StatefulWidget {
  @override
  _ScheduleRegisrationViewState createState() => _ScheduleRegisrationViewState();
}

class _ScheduleRegisrationViewState extends State<ScheduleRegisrationView> {
  LoginStyleRepository _loginStyleRepository = LoginStyleRepository();
  PublicFunctionReprository _publicFunctionReprository = PublicFunctionReprository();

  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  List _works = [
    "내근",
    "외근",
    "재택",
    "외출",
    "휴가",
    "연차",
    "기타",
  ];
  int _chkButton = 0;
  bool _buttonTap = false;

  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    super.initState();
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
        floatingActionButton: getMainCircularMenu(context: context, navigator: 'schedule'),
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: statusBarHeight + 5.0.h,
            horizontal: 27.5.w,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "일정등록",
                style: TextStyle(
                  fontSize: 13.0.sp,
                  color: textColor,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: 21.0.h,
                ),
                child: SizedBox(
                  height: 40.0.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemCount: _works.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              if (_chkButton != index) {
                                return Color(0xff949494);
                              } else {
                                return Color(0xff2573D5);
                              }
                            }),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0.r),
                              ),
                            ),
                            elevation: MaterialStateProperty.all(
                              0.0,
                            )
                          ),
                          child: Text(
                            _works[index],
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: whiteColor,
                            ),
                          ),
                          onPressed: (){
                            setState(() {
                              _chkButton = index;
                            });
                          },
                        )
                      );
                    },
                  )
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: 21.0.h,
                ),
                child: SizedBox(
                  width: 305.0.w,
                  height: 40.0.h,
                  child: TextFormField(
                    decoration: _loginStyleRepository.textFormDecoration(hintText: 'titles'.tr()),
                    style: TextStyle(
                      fontSize: 13.0.sp,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: 21.0.h,
                ),
                child: SizedBox(
                  height: 40.0.h,
                  child: InkWell(
                    child: TextFormField(
                      controller: _startTimeController,
                      enabled: false,
                      decoration: _loginStyleRepository.textFormDecoration(hintText: "시작시간"),
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: textColor,
                      ),
                    ),
                    onTap: () async {
                      startTime = await ScheduleFunctionReprository().dateTimeSet(context: context, date: startTime);
                      setState(() {
                         _startTimeController.text = startTime.year.toString() + "년 " + startTime.month.toString() + "월 " + startTime.day.toString() + "일 " + startTime.hour.toString() + "시 "+ startTime.minute.toString() + "분";
                      });
                    },
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: 21.0.h,
                ),
                child: SizedBox(
                  height: 40.0.h,
                  child: InkWell(
                    child: TextFormField(
                      controller: _endTimeController,
                      enabled: false,
                      decoration: _loginStyleRepository.textFormDecoration(hintText: "종료  시간"),
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: textColor,
                      ),
                    ),
                    onTap: () async {
                      endTime = await ScheduleFunctionReprository().dateTimeSet(context: context, date: endTime);;
                      setState(() {
                        _endTimeController.text = endTime.year.toString() + "년 " + endTime.month.toString() + "월 " + endTime.day.toString() + "일 " + endTime.hour.toString() + "시 "+ endTime.minute.toString() + "분";
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

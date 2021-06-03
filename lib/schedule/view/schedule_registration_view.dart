import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/style/loing_style_repository.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/public/widget/main_menu.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/schedule/widget/schedule_insert_widget.dart';

class ScheduleRegisrationView extends StatefulWidget {
  @override
  _ScheduleRegisrationViewState createState() => _ScheduleRegisrationViewState();
}

class _ScheduleRegisrationViewState extends State<ScheduleRegisrationView> {
  LoginStyleRepository _loginStyleRepository = LoginStyleRepository();
  PublicFunctionReprository _publicFunctionReprository = PublicFunctionReprository();

  //settings
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  List<String> colleagueList = ["이윤혁"];

  DateTime timeZone = DateTime.now();

  late DateTime startTime = DateTime(timeZone.year, timeZone.month, timeZone.day, timeZone.hour, 0, 0);
  late DateTime endTime = DateTime(timeZone.year, timeZone.month, timeZone.day, timeZone.hour + 1, 0, 0);
  late ValueNotifier<DateTime> _startDateTime = ValueNotifier<DateTime>(endTime);
  late ValueNotifier<DateTime> _endDateTime = ValueNotifier<DateTime>(endTime);
  ValueNotifier<bool> _isAllDay = ValueNotifier<bool>(false);

  List _works = [
    "내근",
    "외근",
    "미팅",
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
        //floatingActionButton: getMainCircularMenu(context: context, navigator: 'schedule'),
        body: Container(
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
                      onTap: () {
                      },
                    ),
                    Text(
                      "일정등록",
                      style: getNotoSantRegular(
                          fontSize: 18.0,
                          color: whiteColor
                      )
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: SvgPicture.asset(
                          'assets/icons/check.svg',
                          width: 16.51.w,
                          height: 11.37.h,
                          color: whiteColor,
                        ),
                        onTap: () {
                        },
                      ),
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
                            itemCount: _works.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: Container(
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
                                            if (_chkButton != index) {
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
                                        _works[index],
                                        style: getNotoSantMedium(
                                            fontSize: 13.0,
                                            color: _chkButton != index ? calendarLineColor : whiteColor
                                        )
                                      ),
                                      onPressed: () {
                                        print(_startDateTime.value);
                                        setState(() {
                                          _chkButton = index;
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
                              context: context,
                              workName: _works[_chkButton],
                              colleagueList: colleagueList,
                              isAllDay: _isAllDay,
                              locationController: locationController,
                              titleController: titleController,
                              noteController: noteController,
                              startDateTime: _startDateTime,
                              endDateTime: _endDateTime,
                            ).scheduleNavigation(),
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
    );
  }
}

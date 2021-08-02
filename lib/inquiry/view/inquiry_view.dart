import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/approval/view/approval_join_company_view.dart';
import 'package:mycompany/approval/view/approval_main_view.dart';
import 'package:mycompany/inquiry/view/inquiry_employee_attendance_data_view.dart';
import 'package:mycompany/inquiry/view/inquiry_notice_view.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/setting/function/setting_function.dart';
import 'package:provider/provider.dart';

class InquiryView extends StatefulWidget {
  final bool? approvalChk;

  InquiryView({this.approvalChk});

  @override
  _InquiryViewState createState() => _InquiryViewState();
}

class _InquiryViewState extends State<InquiryView> {
  PublicFunctionRepository _publicFunctionRepository = PublicFunctionRepository();

  var typeList = ["approval".tr(), "notice".tr(), "직원 근태 조회"];

  late int typeChkCount;

  late List<Widget> pageList;

  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();

    super.initState();

    if(widget.approvalChk != null){
      typeChkCount = typeList.indexOf("approval".tr());
    }else {
      typeChkCount = 0;
    }

    pageList =[ApprovalMainView(approvalChk: widget.approvalChk), InquiryNoticeView(), EmployeeAttendanceDataView()];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);
    EmployeeModel? loginEmployeeData = employeeInfoProvider.getEmployeeData();

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
        onWillPop: () => _publicFunctionRepository.onScheduleBackPressed(context: context),
        child: Scaffold(
          body: Container(
            width: double.infinity,
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
                          onPressed: () => _publicFunctionRepository.onBackPressed(context: context),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          color: Color(0xff2093F0),
                        ),
                        SizedBox(
                          width: 14.7.w,
                        ),
                        Text(
                          "inquiry".tr(),
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
                SizedBox(height: 10.0.h,),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 26.0.w,
                          right: 21.0.w,
                          bottom: 15.0.h
                        ),
                        child: SizedBox(
                            height: 40.0.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              itemCount: getGradeChk(employeeModel: loginEmployeeData!, level: [8,9]) ? typeList.length : 2,
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
                                              if (typeChkCount != index) {
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
                                            typeList[index],
                                            style: getNotoSantMedium(
                                                fontSize: 13.0,
                                                color: typeChkCount != index ? calendarLineColor : whiteColor
                                            )
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            typeChkCount = index;
                                          });
                                        },
                                      ),
                                    ));
                              },
                            )
                        ),
                      ),
                      Expanded(
                        child: pageList[typeChkCount],
                      ),
                    ],
                  ),
                ),
            ]),
          ),
        ));
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/approval/view/approval_join_company_view.dart';
import 'package:mycompany/approval/view/approval_main_view.dart';
import 'package:mycompany/inquiry/view/inquiry_employee_attendance_data_view.dart';
import 'package:mycompany/inquiry/view/inquiry_notice_view.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';

class InquiryView extends StatefulWidget {
  final bool? approvalChk;

  InquiryView({this.approvalChk});

  @override
  _InquiryViewState createState() => _InquiryViewState();
}

class _InquiryViewState extends State<InquiryView> {
  PublicFunctionRepository _publicFunctionRepository = PublicFunctionRepository();

  var typeList = ["approval".tr(), "notice".tr(), "회사가입 신청", "직원 근태 조회"];

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

    pageList =[ApprovalMainView(approvalChk: widget.approvalChk, context: context,), InquiryNoticeView(), ApprovalJoinCompanyView(), EmployeeAttendanceDataView()];
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
        onWillPop: () => _publicFunctionRepository.onScheduleBackPressed(context: context),
        child: Scaffold(
          body: Container(
            width: double.infinity,
            color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 72.0.h + statusBarHeight,
                  width: double.infinity,
                  color: whiteColor,
                  padding: EdgeInsets.only(top: statusBarHeight, left: 26.0.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          color: whiteColor,
                          width: 20.0.w,
                          height: 30.0.h,
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            child: Container(
                                width: 14.9.w,
                                height: 14.9.h,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: workInsertColor,
                                )),
                          ),
                        ),
                        onTap: () => _publicFunctionRepository.onBackPressed(context: context),
                      ),
                      Text("inquiry".tr(), style: getNotoSantRegular(fontSize: 18.0, color: textColor)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 26.0.w,
                          right: 21.0.w,
                          bottom: 10.0.h
                        ),
                        child: SizedBox(
                            height: 40.0.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              itemCount: typeList.length,
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

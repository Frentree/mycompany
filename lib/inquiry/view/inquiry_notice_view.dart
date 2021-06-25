import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/inquiry/db/inquiry_firestore_repository.dart';
import 'package:mycompany/inquiry/model/notice_model.dart';
import 'package:mycompany/inquiry/view/inquiry_notice_detail_view.dart';
import 'package:mycompany/inquiry/view/inquiry_notice_registration_update_view.dart';
import 'package:mycompany/inquiry/view/inquiry_notice_registration_view.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/schedule/view/schedule_detail_view.dart';

class InquiryNoticeView extends StatefulWidget {
  @override
  _InquiryNoticeViewState createState() => _InquiryNoticeViewState();
}

class _InquiryNoticeViewState extends State<InquiryNoticeView> {
  // 전체 직원
  List<EmployeeModel> employeeList = <EmployeeModel>[];
  List<NoticeModel> noticeList = <NoticeModel>[];

  DateFormatCustom _format = DateFormatCustom();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNoticeData();
  }

  getNoticeData() async {
    List<EmployeeModel> employee = await ScheduleFunctionReprository().getEmployeeMy(companyCode: loginUser!.companyCode);
    List<NoticeModel> notice = await InquiryFirebaseRepository().getNoticeData(companyCode: loginUser!.companyCode);

    setState(() {
      employeeList = employee;
      noticeList = notice;
    });
  }

  getNoticeWidget({required BuildContext context, required List<NoticeModel> notice}) {
    var list = <Widget>[Container(width: 16.w)];

    if(notice.isEmpty){
      return list;
    }

    for(var data in notice){
      EmployeeModel employeeModel = employeeList.where((element) => element.mail == data.noticeUid).first;

      list.add(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 4.0.h),
            child: InkWell(
              child: Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 250.w,
                            child: Text(
                              data.noticeTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getRobotoBold(fontSize: 14.0, color: textColor),
                            ),
                          ),
                          Visibility(
                            visible: data.noticeUid == loginUser!.mail,
                            child: PopupMenuButton<int>(
                              padding: EdgeInsets.all(0),
                              icon: SvgPicture.asset(
                                'assets/icons/vertical_menu.svg',
                                width: 15.8.w,
                                height: 15.76.h,
                                color: blackColor,
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Text(
                                    "update".tr(),
                                    style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Text(
                                    "delete".tr(),
                                    style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                                  ),
                                ),
                              ],
                              onSelected: (value) async {
                                if(value== 1){
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => InquiryNoticeRegistrationUpdateView(model: data)));
                                }else {
                                  await loginDialogWidget(
                                      context: context,
                                      message: "notice_view_dialog_1".tr(),
                                      actions: [
                                        confirmElevatedButton(
                                            topPadding: 81.0.h,
                                            buttonName: "dialogConfirm".tr(),
                                            buttonAction: () async {
                                              await data.reference!.delete();
                                              Navigator.pop(context);
                                            },
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
                                }
                                setState(() {
                                  getNoticeData();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 250.w,
                            child: Text(
                              data.noticeContent,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: getRobotoMedium(fontSize: 12.0, color: hintTextColor),
                            ),
                          ),
                          /*InkWell(
                            child: ClipOval(
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                color: workInsertColor,
                                child: Center(
                                  child: Icon(
                                    Icons.message_sharp,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          )*/
                        ],
                      ),
                      SizedBox(height: 15.0.h,),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "${_format.dateTimeFormat(date: _format.changeTimeStampToDateTime(timestamp: data.noticeCreateDate!))}",
                          style: getNotoSantMedium(fontSize: 11.0, color: textColor),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "${employeeModel.team} ${employeeModel.name} ${employeeModel.position}",
                          style: getNotoSantMedium(fontSize: 11.0, color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InquiryNoticeDetailView(notice: data, employee: employeeModel, employeeList: employeeList,))),
            ),
          )
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => InquiryNoticeRegistrationView()));

          if(result) {
            setState(() {
              getNoticeData();
            });
          }
        },
      ),
      body: Container(
        color: whiteColor,
        child: ListView(
          children: getNoticeWidget(context: context, notice: noticeList),
        ),
      ),
    );
  }
}

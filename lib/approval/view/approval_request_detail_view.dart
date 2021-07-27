
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/approval/widget/approval_detail_widget.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/style/fontWeight.dart';

import 'package:mycompany/public/style/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:easy_localization/easy_localization.dart';

class ApprovalRequestDetailView extends StatefulWidget {

  final ApprovalModel model;

  ApprovalRequestDetailView({required this.model,});

  @override
  _ApprovalRequestDetailViewState createState() => _ApprovalRequestDetailViewState();
}

class _ApprovalRequestDetailViewState extends State<ApprovalRequestDetailView> {
  DateFormatCustom _format = DateFormatCustom();

  late UserModel loginUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginUser = PublicFunction().getUserProviderSetting(context);
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:() async {
        Navigator.pop(context, false);
        return true;
      },
      child: Scaffold(
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
                        onPressed: () => Navigator.pop(context, true),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        color: Color(0xff2093F0),
                      ),
                      SizedBox(
                        width: 14.7.w,
                      ),
                      Text(
                        "approval_detail".tr(),
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
                  child: ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: [
                      getDetailsContents(title: "titles", content: widget.model.title, size: 70),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      getDetailsScrollContents(title: "content", content: widget.model.requestContent, size: 150),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      getDetailsContents(title: "approval_type", content: widget.model.approvalType, size: 70),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      getDetailsContents(title: "target_date", content: "${_format.getDate(date: widget.model.requestStartDate.toDate())} - ${_format.getDate(date: widget.model.requestEndDate.toDate())}", size: 70),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      getDetailsContents(title: "location", content: widget.model.location, size: 70),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      getDetailsScrollContents(title: "approval_content", content: widget.model.approvalContent!, size: 150),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      getDetailsContents(title: "approver", content: widget.model.approvalUser, size: 70),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      getDetailsContents(title: "approval_request_date", content: "${_format.getDate(date: widget.model.createDate!.toDate())}", size: 70),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      getDetailsContents(title: "approval_status", content: widget.model.status, size: 70),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      getDetailsContents(title: "approval_completion_date", content: widget.model.status == "요청" ? "" :  _format.getDate(date: widget.model.approvalDate!.toDate()), size: 70),
                    ],
                  )
              ),
              Container(
                width: double.infinity,
                height: 57.0.h,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: calendarLineColor.withOpacity(0.1),
                        child: InkWell(
                          child: Center(
                            child: Text(
                              "dialogConfirm".tr(),
                              style: getNotoSantMedium(fontSize: 15.0, color: textColor),
                            ),
                          ),
                          onTap: () => Navigator.pop(context, false),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.model.status == "요청",
                      child: Expanded(
                        child: Container(
                          color: workInsertColor,
                          child: InkWell(
                            child: Center(
                              child: Text(
                                "request_cencel".tr(),
                                style: getNotoSantMedium(fontSize: 15.0, color: whiteColor),
                              ),
                            ),
                            onTap: () async {
                              var result = await loginDialogWidget(
                                  context: context,
                                  message: "cancel_the_approval_request".tr(),
                                  actions: [
                                    confirmElevatedButton(
                                        topPadding: 81.0.h,
                                        buttonName: "dialogConfirm".tr(),
                                        buttonAction: () async {
                                          Navigator.pop(context, await ApprovalFirebaseRepository().requestApprovalCencel(model: widget.model, companyCode: loginUser.companyCode.toString()));
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
                              if(result){
                                Navigator.pop(context,true);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
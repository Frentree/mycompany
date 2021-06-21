import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/approval/widget/approval_detail_widget.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/approval/model/approval_model.dart';

class ApprovalResponseDetailView extends StatefulWidget {
  Key? key;
  final ApprovalModel model;

  ApprovalResponseDetailView({
    key,
    required this.model,
  });

  @override
  _ApprovalResponseDetailViewState createState() => _ApprovalResponseDetailViewState();
}

class _ApprovalResponseDetailViewState extends State<ApprovalResponseDetailView> {
  DateFormatCustom _format = DateFormatCustom();
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () async {
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
                height: 72.0.h + statusBarHeight,
                width: double.infinity,
                color: whiteColor,
                padding: EdgeInsets.only(top: statusBarHeight, left: 26.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          onTap: () => Navigator.pop(context, true),
                        ),
                        Text("approval_detail".tr(), style: getNotoSantRegular(fontSize: 18.0, color: textColor)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: [
                      getContents(title: "titles", content: widget.model.title),
                      getContents(title: "content", content: widget.model.requestContent),
                      getContents(title: "approval_type", content: widget.model.approvalType),
                      getContents(title: "location", content: widget.model.location),
                      getContents(
                          title: "target_date",
                          content:
                              "${_format.getDate(date: widget.model.requestStartDate.toDate())} - ${_format.getDate(date: widget.model.requestEndDate.toDate())}"),
                      getContents(title: "requester", content: widget.model.user),
                      getContents(title: "approval_request_date", content: "${_format.getDate(date: widget.model.createDate!.toDate())}"),
                      getContents(title: "approval_status", content: widget.model.status),
                      getContents(title: "approval_completion_date", content: widget.model.status == "요청" ? "" :  _format.getDate(date: widget.model.approvalDate!.toDate())),
                      widget.model.status != "요청"
                          ? getContents(title: "approval_content", content: widget.model.approvalContent!)
                          : getApprovalContents(title: "approval_content", noteController: noteController),
                ],
              )),
              Container(
                width: double.infinity,
                height: 57.0.h,
                child: Row(
                  children: [
                    Visibility(
                      visible: widget.model.status != "요청",
                      child: Expanded(
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
                    ),
                    Visibility(
                      visible: widget.model.status == "요청",
                      child: Expanded(
                        child: Container(
                          color: calendarLineColor.withOpacity(0.1),
                          child: InkWell(
                            child: Center(
                              child: Text(
                                "return".tr(),
                                style: getNotoSantMedium(fontSize: 15.0, color: textColor),
                              ),
                            ),
                            onTap: () async {
                              var result = await loginDialogWidget(context: context, message: "return_the_approval_request".tr(), actions: [
                                confirmElevatedButton(
                                    topPadding: 81.0.h,
                                    buttonName: "dialogConfirm".tr(),
                                    buttonAction: () async {
                                      Navigator.pop(
                                          context,
                                          await ApprovalFirebaseRepository().updateWorkApproval(
                                              model: widget.model,
                                              companyCode: loginUser!.companyCode.toString(),
                                              approval: "반려",
                                              content: noteController.text));
                                    },
                                    customWidth: 80.0,
                                    customHeight: 40.0),
                                confirmElevatedButton(
                                    topPadding: 81.0.h,
                                    buttonName: "dialogCancel".tr(),
                                    buttonAction: () => Navigator.pop(context, false),
                                    customWidth: 80.0,
                                    customHeight: 40.0),
                              ]);
                              if (result) {
                                Navigator.pop(context, true);
                              }
                            },
                          ),
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
                                "consent".tr(),
                                style: getNotoSantMedium(fontSize: 15.0, color: whiteColor),
                              ),
                            ),
                            onTap: () async {
                              var result = await loginDialogWidget(context: context, message: "consent_the_approval_request".tr(), actions: [
                                confirmElevatedButton(
                                    topPadding: 81.0.h,
                                    buttonName: "dialogConfirm".tr(),
                                    buttonAction: () async {
                                      Navigator.pop(
                                          context,
                                          await ApprovalFirebaseRepository().updateWorkApproval(
                                              model: widget.model,
                                              companyCode: loginUser!.companyCode.toString(),
                                              approval: "승인",
                                              content: noteController.text));
                                    },
                                    customWidth: 80.0,
                                    customHeight: 40.0),
                                confirmElevatedButton(
                                    topPadding: 81.0.h,
                                    buttonName: "dialogCancel".tr(),
                                    buttonAction: () => Navigator.pop(context, false),
                                    customWidth: 80.0,
                                    customHeight: 40.0),
                              ]);
                              if (result) {
                                Navigator.pop(context, true);
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

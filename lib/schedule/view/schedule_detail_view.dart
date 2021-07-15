import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/model/public_comment_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/public/widget/public_widget.dart';
import 'package:mycompany/schedule/db/schedule_firestore_repository.dart';
import 'package:mycompany/schedule/function/calender_method.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ScheduleDetailView extends StatefulWidget {
  final Appointment appointment;
  final List<EmployeeModel> employeeList;

  ScheduleDetailView({required this.appointment, required this.employeeList});

  @override
  _ScheduleDetailViewState createState() => _ScheduleDetailViewState();
}

class _ScheduleDetailViewState extends State<ScheduleDetailView> {
  DateFormatCustom _formatCustom = DateFormatCustom();
  PublicFunctionRepository _publicFunctionReprository = PublicFunctionRepository();
  ScheduleFirebaseReository _scheduleFirebaseReository = ScheduleFirebaseReository();
  bool isArrowChk = false;

  late TextEditingController _commentTextController;

  ValueNotifier<CommentModel?> commentValue = ValueNotifier<CommentModel?>(null);

  late UserModel loginUser;
  late EmployeeModel loginEmployee;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentTextController = TextEditingController();
    loginUser = PublicFunction().getUserProviderSetting(context);
    loginEmployee= PublicFunction().getEmployeeProviderSetting(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        color: whiteColor,
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: [
            Container(
              height: 52.0.h,
              width: double.infinity,
              padding: EdgeInsets.only(left: 18.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      width: 30.0.w,
                      height: 30.0.h,
                      color: whiteColor.withOpacity(0.0),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/arrow_left.svg',
                          width: 15.8.w,
                          height: 15.76.h,
                          color: blackColor,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.appointment.userName.toString(),
                          style: getNotoSantBold(fontSize: 14.0, color: textColor),
                        ),
                        Text(
                          "${widget.appointment.position == "" ? "직급(미지정)" : widget.appointment.position} / ${widget.appointment.team == "" ? "팀(미지정)" : widget.appointment.team}",
                          style: getNotoSantMedium(fontSize: 10.0, color: textColor),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.appointment.profile == loginUser.mail,
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
                        var result = -1;
                        switch(value) {
                          case 1:   //수정
                            if(widget.appointment.organizerId != widget.appointment.userMail){
                              loginDialogWidget(
                                  context: context,
                                  message: "schedule_detail_view_dialog_7".tr(),
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
                              break;
                            }

                            result = await CalenderMethod().updateScheduleWork(
                                context: context,
                                companyCode: loginUser.companyCode.toString(),
                                documentId: widget.appointment.documentId.toString(),
                                appointment: widget.appointment);
                            break;
                          case 2:   //삭제
                            if(widget.appointment.profile != widget.appointment.organizerId){
                              result = await CalenderMethod().deleteColleagues(
                                  companyCode: loginUser.companyCode.toString(),
                                  appointment: widget.appointment
                              );
                              break;
                            }
                            result = await CalenderMethod().deleteSchedule(
                                companyCode: loginUser.companyCode.toString(),
                                documentId: widget.appointment.documentId.toString()
                            );
                            break;
                        }

                        switch(result) {
                          case 0: // 삭제 및 수정 성공
                            await loginDialogWidget(
                                context: context,
                                message: "schedule_detail_view_dialog_1".tr(),
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
                            _publicFunctionReprository.onScheduleBackPressed(context: context);
                            break;
                          case 400: // 결재 중인 항목이 있어서 삭제 실패
                            loginDialogWidget(
                                context: context,
                                message: "schedule_detail_view_dialog_2".tr(),
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
                            break;
                          case 404: // 결재 중인 항목이 있어서 삭제 실패
                            loginDialogWidget(
                              context: context,
                              message: "schedule_detail_view_dialog_3".tr(),
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
                            break;
                          case 405: // 스케줄 등록 실패
                            loginDialogWidget(
                                context: context,
                                message: "schedule_detail_view_dialog_4".tr(),
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
                            break;
                          case 406: // 결재 진행중 수정
                            loginDialogWidget(
                                context: context,
                                message: "schedule_detail_view_dialog_5".tr(),
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
                            break;
                          case 407: // 수정 오류
                            loginDialogWidget(
                                context: context,
                                message: "schedule_detail_view_dialog_6".tr(),
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
                            break;
                        }

                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          child: Card(
                            child: Container(
                              width: double.infinity,
                              height: isArrowChk? null : 100.0.h ,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _formatCustom.getDate(date:  widget.appointment.startTime),
                                        style: getRobotoBold(fontSize: 12.0, color: textColor),
                                      ),
                                      Text(
                                        " - " + _formatCustom.getDate(date:  widget.appointment.endTime),
                                        style: getRobotoBold(fontSize: 12.0, color: hintTextColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0.h,),
                                  Text(
                                    widget.appointment.title.toString(),
                                    style: getNotoSantBold(fontSize: 18.0, color: textColor),
                                  ),
                                  SizedBox(height: 10.0.h,),
                                  Visibility(
                                    visible: isArrowChk,
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.appointment.content.toString(),
                                          style: getNotoSantRegular(fontSize: 14.0, color: textColor),
                                        ),
                                        SizedBox(height: 10.0.h,),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 30.0.w,
                                    height: 30.0.h,
                                    color: whiteColor.withOpacity(0.0),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        isArrowChk ? 'assets/icons/arrow_up.svg' : 'assets/icons/arrow_down.svg',
                                        width: 20.8.w,
                                        height: 19.76.h,
                                        color: blackColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              isArrowChk = !isArrowChk;
                            });
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: _scheduleFirebaseReository.getScheduleComment(companyCode: loginUser.companyCode!, docId: widget.appointment.documentId!),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData) {
                              return Container();
                            }
                            List<DocumentSnapshot> docs = snapshot.data!.docs;

                            return Column(
                              children: getCommentsWidget(
                                context: context, docs: docs,
                                employeeList: widget.employeeList,
                                commentTextController: _commentTextController,
                                commentValue: commentValue
                              )
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: commentValue,
                    builder: (context, value, child) {
                      return Container(
                        alignment: Alignment.bottomCenter,
                        child: commentValue.value != null ? Container(
                          padding: EdgeInsets.symmetric(vertical: 2.0.h),
                          width: double.infinity,
                          height: 20.0.h,
                          color: workInsertColor.withOpacity(0.7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${commentValue.value!.uname} 님에게 답글 중입니다.",
                                style: getNotoSantBold(fontSize: 10.0, color: whiteColor),
                              ),
                              InkWell(
                                child: Container(
                                  width: 40.0.w,
                                  color: whiteColor.withOpacity(0),
                                  child: Text(
                                    "cencel".tr(),
                                    style: getNotoSantBold(fontSize: 10.0, color: whiteColor, decoration: TextDecoration.underline,),
                                  ),
                                ),
                                onTap: () {
                                  commentValue.value = null;
                                  _commentTextController.text = "";
                                  setState(() {

                                  });
                                },
                              ),
                            ],
                          ),
                        ) : Container(),

                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 55.0.h,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45.0.h,
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        controller: _commentTextController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.0.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0.r),
                            borderSide: BorderSide(
                                width: 2.0,
                                style: BorderStyle.none
                            ),
                          ),
                          hintText: "comment".tr(),
                          hintStyle: getNotoSantRegular(
                            fontSize: 14.0,
                            color: hintTextColor,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                    child: InkWell(
                        child: ClipOval(
                          child: Container(
                            width: 45.h,
                            height: 45.h,
                            color: workInsertColor,
                            child: Center(
                              child: Icon(
                                Icons.message_sharp,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          if(_commentTextController.text.trim() == ""){
                            return;
                          }

                          CalenderMethod().insertScheduleCommentMethod(
                              loginUser: loginUser,
                              model: commentValue.value,
                              noticeComment: _commentTextController,
                              mode: widget.appointment
                          );
                          setState(() {
                            commentValue.value = null;
                          });
                        }
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:easy_localization/easy_localization.dart';

Future<dynamic> applyOvertimeBottomSheet({required BuildContext context}) {
  int? overtime = 1;

  return showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4.0.r),
        topRight: Radius.circular(4.0.r),
      ),
    ),
    context: context,
    builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context, setState){
          return Container(
            padding: EdgeInsets.only(
              top: 10.0.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 27.0.w,
                  height: 6.0.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0.r),
                    ),
                    color: Color(0xffC4C4C4),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 10.0.h,
                    bottom: 17.0.h,
                  ),
                  child: Text(
                    "연장근무 시간 선택",
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      fontWeight: fontWeight["Medium"],
                      color: Color(0xff9C9C9C)
                    ),
                  ),
                ),
                bottomSheetRadioItem(
                  itemName: "1시간",
                  groupValue: overtime!,
                  value: 1,
                  onChanged: (int? value){
                    setState((){
                      overtime = value;
                    });
                  }
                ),
                bottomSheetRadioItem(
                  itemName: "2시간",
                  groupValue: overtime!,
                  value: 2,
                  onChanged: (int? value){
                    setState((){
                      overtime = value;
                    });
                  }
                ),
                bottomSheetRadioItem(
                  itemName: "3시간",
                  groupValue: overtime!,
                  value: 3,
                  onChanged: (int? value){
                    setState((){
                      overtime = value;
                    });
                  }
                ),
                bottomSheetRadioItem(
                  itemName: "4시간",
                  groupValue: overtime!,
                  value: 4,
                  onChanged: (int? value){
                    setState((){
                      overtime = value;
                    });
                  }
                ),
                Row(
                  children: [
                    attendanceBottomSheetButton(
                      buttonName: 'dialogCancel'.tr(),
                      buttonNameColor: textColor,
                      buttonColor: Color(0xffF7F7F7),
                      buttonAction: (){
                        backPage(context: context);
                      }
                    ),
                    attendanceBottomSheetButton(
                      buttonName: "결재자 지정",
                      buttonNameColor: whiteColor,
                      buttonColor: Color(0xff2093F0),
                      buttonAction: (){
                        backPage(context: context, returnValue: overtime);
                      }
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Container bottomSheetRadioItem(
    {required String itemName,
      required int groupValue,
      required int value,
      required ValueChanged<int?> onChanged}) {
  return Container(
    padding: EdgeInsets.only(
      left: 25.0.w,
      right: 25.0.w,
    ),
    color: groupValue == value ? Color(0xff2093F0).withOpacity(0.1) : null,
    child: RadioListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        itemName,
        style: TextStyle(
          fontSize: 13.0.sp,
          fontWeight: fontWeight["Medium"],
          color: textColor,
        ),
      ),
      value: value,
      onChanged: onChanged,
      groupValue: groupValue,
      controlAffinity: ListTileControlAffinity.trailing,
    ),
  );
}

Future<dynamic> selectOvertimeApprovalBottomSheet({required BuildContext context, required EmployeeModel employeeModel, required List<EmployeeModel> approvalList, required int overtime}) {
  ApprovalFirebaseRepository approvalFirebaseRepository = ApprovalFirebaseRepository();
  ValueNotifier<EmployeeModel?> selectApproval = ValueNotifier<EmployeeModel?>(null);

  return showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4.0.r),
        topRight: Radius.circular(4.0.r),
      ),
    ),
    context: context,
    builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context, setState){
          return Container(
            padding: EdgeInsets.only(
              top: 10.0.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 27.0.w,
                  height: 6.0.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0.r),
                    ),
                    color: Color(0xffC4C4C4),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 10.0.h,
                    bottom: 17.0.h,
                  ),
                  child: Text(
                    "결재자 선택",
                    style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: fontWeight["Medium"],
                        color: Color(0xff9C9C9C)
                    ),
                  ),
                ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: approvalList.length,
                  itemBuilder: (context, index){
                    EmployeeModel approval = approvalList.elementAt(index);
                    if((approval.mail == employeeModel.mail) || (!approval.level!.contains(6))){
                      return SizedBox();
                    }
                    return ValueListenableBuilder(
                        valueListenable: selectApproval,
                        builder: (BuildContext context, EmployeeModel? value, Widget? child) {
                          return Container(
                            padding: EdgeInsets.only(
                              left: 25.0.w,
                              right: 25.0.w,
                            ),
                            color: (value != null && value == approval) ? Color(0xff2093F0).withOpacity(0.1) : null,
                            child: RadioListTile<EmployeeModel?>(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 36.5.w,
                                      height: 36.5.h,
                                      color: hintTextColor,
                                      child: Center(
                                        child: ClipOval(
                                          child: Container(
                                            width: 36.5.w,
                                            height: 36.5.h,
                                            color: whiteColor,
                                            child: Center(
                                              child: ClipOval(
                                                child: SizedBox(
                                                  width: 36.0.w,
                                                  height: 36.0.h,
                                                  child: approval.profilePhoto != '' ?
                                                  FadeInImage.assetNetwork(
                                                    placeholder: 'assets/images/logo_blue.png',
                                                    image: approval.profilePhoto.toString(),
                                                    height: 36.0.h,
                                                  ): SvgPicture.asset(
                                                    'assets/icons/personal.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6.0.w,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        approval.name,
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          fontWeight: fontWeight["Medium"],
                                          color: textColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            approval.team == "" ? "기타팀" : approval.team!,
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              fontWeight: fontWeight["Medium"],
                                              color: hintTextColor,
                                            ),
                                          ),
                                          Text(
                                            approval.position == "" ? "" : "/${approval.team!}",
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              fontWeight: fontWeight["Medium"],
                                              color: hintTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              value: approval,
                              onChanged: (EmployeeModel? value){
                                selectApproval.value = value;
                              },
                              groupValue: selectApproval.value,
                              controlAffinity: ListTileControlAffinity.trailing,
                            ),
                          );
                        }
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    attendanceBottomSheetButton(
                        buttonName: 'dialogCancel'.tr(),
                        buttonNameColor: textColor,
                        buttonColor: Color(0xffF7F7F7),
                        buttonAction: (){
                          backPage(context: context, returnValue: false);
                        }
                    ),
                    ValueListenableBuilder(
                      valueListenable: selectApproval,
                      builder: (BuildContext context, EmployeeModel? value, Widget? child) {
                        return attendanceBottomSheetButton(
                          buttonName: "연장근무 신청",
                          buttonNameColor: value == null ? hintTextColor : whiteColor,
                          buttonColor: Color(0xff2093F0),
                          buttonAction: value == null ? null : () async {
                            ApprovalModel overtimeApprovalData = ApprovalModel(
                              allDay: false,
                              status: "요청",
                              location: "",
                              approvalUser: value.name,
                              approvalMail: value.mail,
                              approvalType: "연장",
                              title: "연장근무 신청_${employeeModel.name}",
                              requestContent: "${DateFormatCustom().todayStringFormat()} ${overtime}시간 연장근무 신청합니다.",
                              createDate: Timestamp.now(),
                              requestStartDate: Timestamp.now(),
                              requestEndDate: Timestamp.now(),
                              user: employeeModel.name,
                              userMail: employeeModel.mail,
                              overtime: overtime,
                            );

                            await approvalFirebaseRepository.createApprovalData(companyId: employeeModel.companyCode, approvalModelModel: overtimeApprovalData);
                            backPage(context: context, returnValue: true);
                          }
                        );
                      }
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


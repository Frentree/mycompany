import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/attendance/widget/attendance_bottom_sheet.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/expense/model/expense_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/fcm/send_fcm.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:mycompany/login/model/user_model.dart';

Future<dynamic> applyExpenseBottomSheet({required BuildContext context}) {
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


Future<dynamic> selectExpenseApprovalBottomSheet({required BuildContext context, required List<EmployeeModel> approvalList, required UserModel loginUser, required List<String> docId, required int totalPrice}) {
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
                      if((approval.mail == loginUser.mail) || (!approval.level!.contains(6) && !approval.level!.contains(9))){
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
                                                    child: approval.profilePhoto !=  "" ?
                                                    FadeInImage.assetNetwork(
                                                      placeholder: 'assets/images/log_blue.png',
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
                              buttonName: "경비 결재 신청",
                              buttonNameColor: value == null ? hintTextColor : whiteColor,
                              buttonColor: Color(0xff2093F0),
                              buttonAction: value == null ? null : () async {
                                ApprovalModel model = ApprovalModel(
                                  allDay: false,
                                  status: "대기",
                                  location: "",
                                  approvalUser: selectApproval.value!.name,
                                  approvalMail: selectApproval.value!.mail,
                                  approvalType: "경비",
                                  title: "[경비] ",
                                  requestContent: "",
                                  requestStartDate: Timestamp.now(),
                                  requestEndDate: Timestamp.now(),
                                  user: loginUser.name,
                                  userMail: loginUser.mail,
                                  docIds: docId
                                );
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
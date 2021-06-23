import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/inquiry/db/inquiry_firestore_repository.dart';
import 'package:mycompany/inquiry/method/notice_method.dart';
import 'package:mycompany/inquiry/model/notice_comment_model.dart';
import 'package:mycompany/inquiry/model/notice_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/schedule/widget/userProfileImage.dart';

class InquiryNoticeDetailView extends StatefulWidget {
  final NoticeModel notice;
  final EmployeeModel employee;
  final List<EmployeeModel> employeeList;

  InquiryNoticeDetailView({required this.notice,required this.employee,required this.employeeList});

  @override
  _InquiryNoticeDetailViewState createState() => _InquiryNoticeDetailViewState();
}

class _InquiryNoticeDetailViewState extends State<InquiryNoticeDetailView> {
  DateFormatCustom _formatCustom = DateFormatCustom();
  InquiryFirebaseRepository _inquiryFirebaseRepository = InquiryFirebaseRepository();
  bool isArrowChk = true;

  late TextEditingController _commentTextController;
  NoticeCommentModel? noticeCommentModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentTextController.dispose();
  }

  getNoticeComments(BuildContext context, List<DocumentSnapshot> docs){
    var list = <Widget>[Container(width: 16.w,)];

    docs.sort((a, b) => a.get("noticeCreateDate").compareTo(b.get("noticeCreateDate")));

    for(var doc in docs){
      final noticeComment = NoticeCommentModel.fromMap(mapData: (doc.data() as dynamic), reference: doc.reference);

      EmployeeModel user = widget.employeeList.where((element) => element.mail == noticeComment.noticeUid).first;
      if(noticeComment.level == 0) {
        list.add(
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 8.0.w),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getProfileImage(size: 35.0, ImageUri: user.profilePhoto),
                      SizedBox(width: 5.0.w,),
                      Container(
                        width: 55.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                            ),
                            Text(
                              "${user.position} / ${user.team}",
                              overflow: TextOverflow.ellipsis,
                              style: getNotoSantMedium(fontSize: 8.0, color: hintTextColor),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  width: 150.0.w,
                                  padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 5.0.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0.r),
                                    ),
                                    color: Color(0xffC4C4C4).withOpacity(0.5),
                                  ),
                                  child: Text(
                                    noticeComment.noticeComment,
                                    style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                  )
                              ),
                              SizedBox(width: 5.0.w,),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 3.0.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.0.r),
                                  ),
                                  color: workInsertColor,
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                        child: Icon(
                                          Icons.arrow_forward_outlined,
                                          color: whiteColor,
                                          size: 15.w,
                                        ),
                                        onTap: () {
                                          _commentTextController.text = "@" + noticeComment.noticeUname + " ";
                                          noticeCommentModel = noticeComment;
                                          setState(() {

                                          });
                                        }
                                    ),
                                    Visibility(
                                      visible: loginUser!.mail == user.mail,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 5.0.w,),
                                          InkWell(
                                              child: Icon(
                                                Icons.delete,
                                                color: whiteColor,
                                                size: 15.w,
                                              ),
                                              onTap: () => loginDialogWidget(
                                                  context: context,
                                                  message: "notice_detail_view_dialog_1".tr(),
                                                  actions: [
                                                    confirmElevatedButton(
                                                        topPadding: 81.0.h,
                                                        buttonName: "dialogConfirm".tr(),
                                                        buttonAction: () async {
                                                          await noticeComment.reference!.delete();
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
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )

                            ],
                          ),
                          Text(
                            "${_formatCustom.dateTimeFormat(date: _formatCustom.changeTimeStampToDateTime(timestamp: noticeComment.noticeCreateDate!))}",
                            style: getNotoSantMedium(fontSize: 8.0, color: hintTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
        );
      } else {
        list.add(
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 8.0.w),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getProfileImage(size: 35.0, ImageUri: user.profilePhoto),
                      SizedBox(width: 5.0.w,),
                      Container(
                        width: 55.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                            ),
                            Text(
                              "${user.position} / ${user.team}",
                              overflow: TextOverflow.ellipsis,
                              style: getNotoSantMedium(fontSize: 8.0, color: hintTextColor),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  width: 150.0.w,
                                  padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 5.0.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0.r),
                                    ),
                                    color: Color(0xffC4C4C4).withOpacity(0.5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${noticeComment.noticeUpUname} " + noticeComment.noticeUpComment!,
                                        maxLines: 4,
                                        style: getNotoSantRegular(fontSize: 9.0, color: textColor),
                                      ),
                                      SizedBox(height: 3.0.h,),
                                      Container(
                                        width: 150.w,
                                        height: 0.7.h,
                                        color: blackColor.withOpacity(0.3),
                                      ),
                                      SizedBox(height: 3.0.h,),
                                      Text(
                                        noticeComment.noticeComment,
                                        style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                      ),
                                    ],
                                  )
                              ),
                              SizedBox(width: 5.0.w,),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 3.0.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.0.r),
                                  ),
                                  color: workInsertColor,
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                        child: Icon(
                                          Icons.arrow_forward_outlined,
                                          color: whiteColor,
                                          size: 15.w,
                                        ),
                                        onTap: () {
                                          _commentTextController.text = "@" + noticeComment.noticeUname + " ";
                                          noticeCommentModel = noticeComment;
                                          setState(() {

                                          });
                                        }
                                    ),
                                    Visibility(
                                      visible: loginUser!.mail == user.mail,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 5.0.w,),
                                          InkWell(
                                              child: Icon(
                                                Icons.delete,
                                                color: whiteColor,
                                                size: 15.w,
                                              ),
                                              onTap: () => loginDialogWidget(
                                                  context: context,
                                                  message: "notice_detail_view_dialog_1".tr(),
                                                  actions: [
                                                    confirmElevatedButton(
                                                        topPadding: 81.0.h,
                                                        buttonName: "dialogConfirm".tr(),
                                                        buttonAction: () async {
                                                          await noticeComment.reference!.delete();
                                                          Navigator.pop(context);
                                                        },
                                                        customWidth: 80.0,
                                                        customHeight: 40.0
                                                    ),
                                                    confirmElevatedButton(
                                                        topPadding: 81.0.h,
                                                        buttonName: "dialogCancel".tr(),
                                                        buttonAction: () => Navigator.pop(context),
                                                        customWidth: 80.0,
                                                        customHeight: 40.0
                                                    ),
                                                  ]
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )

                            ],
                          ),
                          Text(
                            "${_formatCustom.dateTimeFormat(date: _formatCustom.changeTimeStampToDateTime(timestamp: noticeComment.noticeCreateDate!))}",
                            style: getNotoSantMedium(fontSize: 8.0, color: hintTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
        );
      }

    }

    return list;
    
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
                          widget.employee.name.toString(),
                          style: getNotoSantBold(fontSize: 14.0, color: textColor),
                        ),
                        Text(
                          widget.employee.position.toString() + " / " +  widget.employee.team.toString(),
                          style: getNotoSantMedium(fontSize: 10.0, color: textColor),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 50.0.w,
                    color: whiteColor.withOpacity(0),
                  )
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
                                  Text(
                                    _formatCustom.dateTimeFormat(date: _formatCustom.changeTimeStampToDateTime(timestamp: widget.notice.noticeCreateDate!)),
                                    style: getRobotoBold(fontSize: 12.0, color: textColor),
                                  ),
                                  SizedBox(height: 10.0.h,),
                                  Text(
                                    widget.notice.noticeTitle.toString(),
                                    style: getNotoSantBold(fontSize: 18.0, color: textColor),
                                  ),
                                  SizedBox(height: 10.0.h,),
                                  Visibility(
                                    visible: isArrowChk,
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.notice.noticeContent.toString(),
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
                          onTap: (){
                            setState(() {
                              isArrowChk = !isArrowChk;
                            });
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: _inquiryFirebaseRepository.getNoticeComment(companyCode: loginUser!.companyCode!, docId: widget.notice.reference!.id.toString()),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData) {
                              return Container();
                            }
                            List<DocumentSnapshot> docs = snapshot.data!.docs;

                            return Column(
                                children: getNoticeComments(context, docs)
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: noticeCommentModel != null ? Container(
                      padding: EdgeInsets.symmetric(vertical: 2.0.h),
                      width: double.infinity,
                      height: 20.0.h,
                      color: workInsertColor.withOpacity(0.7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${noticeCommentModel!.noticeUname} 님에게 답글 중입니다.",
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
                              noticeCommentModel = null;
                              _commentTextController.text = "";
                              setState(() {

                              });
                            },
                          ),
                        ],
                      ),
                    ) : Container(),

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

                        NoticeMethod().insertNoticeCommentMethod(
                          companyCode: loginUser!.companyCode!,
                          model: noticeCommentModel,
                          noticeComment: _commentTextController,
                          noticeMode: widget.notice
                        );
                        setState(() {
                          noticeCommentModel = null;
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


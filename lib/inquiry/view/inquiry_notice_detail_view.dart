import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/inquiry/db/inquiry_firestore_repository.dart';
import 'package:mycompany/inquiry/method/notice_method.dart';
import 'package:mycompany/inquiry/model/notice_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/model/public_comment_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/public/widget/public_widget.dart';

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

  ValueNotifier<CommentModel?> commentValue = ValueNotifier<CommentModel?>(null);

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

                        NoticeMethod().insertNoticeCommentMethod(
                          companyCode: loginUser!.companyCode!,
                          model: commentValue.value,
                          noticeComment: _commentTextController,
                          noticeMode: widget.notice
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


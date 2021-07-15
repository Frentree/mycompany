import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/inquiry/method/notice_method.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';

class InquiryNoticeRegistrationView extends StatefulWidget {
  @override
  _InquiryNoticeRegistrationViewState createState() => _InquiryNoticeRegistrationViewState();
}

class _InquiryNoticeRegistrationViewState extends State<InquiryNoticeRegistrationView> {

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  late UserModel loginUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginUser = PublicFunction().getUserProviderSetting(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: Scaffold(
        //floatingActionButton: getMainCircularMenu(context: context, navigator: 'schedule'),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
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
                            onPressed: () => Navigator.pop(context, false),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            color: Color(0xff2093F0),
                          ),
                          SizedBox(
                            width: 14.7.w,
                          ),
                          Text(
                            "registering_a_notice".tr(),
                            style: TextStyle(
                              fontSize: 18.0.sp,
                              fontWeight: fontWeight['Medium'],
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                        child: Container(
                          width: 50.0.w,
                          height: 20.0.h,
                          alignment: Alignment.centerRight,
                          color: whiteColor.withOpacity(0),
                          padding: EdgeInsets.only(right: 27.0.w),
                          child: SvgPicture.asset(
                            'assets/icons/check.svg',
                            width: 23.51.w,
                            height: 13.37.h,
                            color: Color(0xff2093F0),
                          ),
                        ),
                        onTap: () async {
                          if(titleController.text.trim() == ""){
                            await loginDialogWidget(
                                context: context,
                                message: "notice_input_dialog_1".tr(),
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
                            return;
                          }

                          if(noteController.text.trim() == ""){
                            await loginDialogWidget(
                                context: context,
                                message: "notice_input_dialog_2".tr(),
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
                            return;
                          }

                          var result = await NoticeMethod().insertNoticeMethod(loginUser: loginUser, title: titleController.text, content: noteController.text);

                          if(result == 0){
                            await loginDialogWidget(
                                context: context,
                                message: "notice_input_dialog_3".tr(),
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
                            Navigator.pop(context, true);
                          } else {
                            await loginDialogWidget(
                                context: context,
                                message: "notice_input_dialog_4".tr(),
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
                            Navigator.pop(context, false);
                          }

                        }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0.h,),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 21.0.h,
                      left: 26.0.w,
                      right: 21.0.w
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: "title_input".tr(),
                              hintStyle: getNotoSantRegular(
                                fontSize: 14.0,
                                color: hintTextColor,
                              ),
                            ),
                            style: getNotoSantRegular(
                                fontSize: 14.0,
                                color: textColor
                            )
                        ),
                        SizedBox(
                          height: 38.0.h,
                        ),
                        TextFormField(
                            controller: noteController,
                            autofocus: false,
                            minLines: 15,
                            maxLines: 20,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10.0.w),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0.r),
                                borderSide: BorderSide(
                                    width: 2.0,
                                    style: BorderStyle.none
                                ),
                              ),
                              hintText: "details".tr(),
                              hintStyle: getNotoSantRegular(
                                fontSize: 14.0,
                                color: hintTextColor,
                              ),
                            ),
                            style: getNotoSantRegular(
                                fontSize: 14.0,
                                color: textColor
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

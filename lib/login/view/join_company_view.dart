import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/view/find_company_view.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/login/widget/login_text_form_widget.dart';

class JoinCompanyView extends StatefulWidget {
  @override
  JoinCompanyViewState createState() => JoinCompanyViewState();
}

class JoinCompanyViewState extends State<JoinCompanyView> {
  TextEditingController _companyNameTextController = TextEditingController();

  CompanyModel selectCompany = CompanyModel(companyId: "", companyName: "", companyAddress: "");
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 27.5.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 68.0.h,
              ),
              child: SizedBox(
                height: 26.0.h,
                child: Row(
                  children: [
                    IconButton(
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                      iconSize: 24.0.h,
                      splashRadius: 24.0.r,
                      onPressed: () => backPage(context: context),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'joinCompanyViewName'.tr(),
                          style: TextStyle(
                            fontSize: 18.0.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 126.0.h,
              ),
              child: SizedBox(
                child: Text(
                  'joinCompanyViewMainMessage'.tr(),
                  style: TextStyle(
                    fontSize: 22.0.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                )
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 8.0.h,
              ),
              child: SizedBox(
                child: Text(
                  'joinCompanyViewHintMessage'.tr(),
                  style: TextStyle(
                    fontSize: 13.0.sp,
                    fontWeight: fontWeight['Medium'],
                    color: hintTextColor,
                  ),
                  textAlign: TextAlign.center,
                )
              ),
            ),
            companyViewTextFormField(
              topPadding: 44.0.h,
              textEditingController: _companyNameTextController,
              hintText: 'findCompany'.tr(),
              suffixIcon: textFormSearchButton(),
              readOnly: true,
              onTab: () async {
                CompanyModel _companyModel = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FindCompanyView(companyModel: selectCompany)
                  )
                );
                if(_companyModel.companyId != ""){
                  setState(() {
                    selectCompany = _companyModel;
                    _companyNameTextController.text = selectCompany.companyName;
                  });
                }
              } ,
            ),
            loginElevatedButton(
              topPadding: 45.0.h,
              buttonName: 'joinButton'.tr(),
              buttonAction: _companyNameTextController.text == "" ? null : () => {print("합류하기")}
            )
          ],
        ),
      ),
    );
  }
}
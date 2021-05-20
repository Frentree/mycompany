import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_text_form_widget.dart';

class FindCompanyView extends StatefulWidget {
  CompanyModel companyModel;

  FindCompanyView({Key? key, required this.companyModel}) : super(key: key);

  @override
  FindCompanyViewState createState() => FindCompanyViewState();
}

class FindCompanyViewState extends State<FindCompanyView> {
  TextEditingController _companyNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(_companyNameTextController.text == "" && widget.companyModel.companyId != ""){
      _companyNameTextController.text = widget.companyModel.companyName;
    }
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
                      onPressed: () => Navigator.pop(context, widget.companyModel),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'findCompany'.tr(),
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
            companyViewTextFormField(
              topPadding: 44.0.h,
              textEditingController: _companyNameTextController,
              hintText: 'searchByCompanyName'.tr(),
              suffixIcon: textFormSearchButton(),
            ),
            loginElevatedButton(
              topPadding: 45.0.h,
              buttonName: 'joinButton'.tr(),
              buttonAction: () {
                widget.companyModel = CompanyModel(companyId: "a", companyName: "a", companyAddress: "a");
                Navigator.pop(context, widget.companyModel);
              }
            )
          ],
        ),
      ),
    );
  }
}
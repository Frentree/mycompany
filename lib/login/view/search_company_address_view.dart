import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/function/search_company_address_function.dart';
import 'package:mycompany/login/model/road_address_model.dart';
import 'package:mycompany/login/style/decoration_style.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_text_form_widget.dart';

class SearchCompanyAddressView extends StatefulWidget {
  @override
  SearchCompanyAddressViewState createState() => SearchCompanyAddressViewState();
}

class SearchCompanyAddressViewState extends State<SearchCompanyAddressView> {
  TextEditingController _companyAddressTextController = TextEditingController();

  ValueNotifier<List<Juso>> jusoList = ValueNotifier<List<Juso>>([]);
  int pageNumber = 1;
  String errorMessage = "";

  void test({required String k, required int n}) async {
    print("a");
    List<Juso> i = jusoList.value;
    RoadAddressModel data = await SearchCompanyAddressFunction().searchCompanyAddress(keyWord: k, pageNumber: n);
    i.addAll(data.jusoList!);

    jusoList.value = i;
    setState(() {

    });
  }

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
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'searchAddress'.tr(),
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
              padding: EdgeInsets.only(
                top: 44.0.h,
              ),
              child: SizedBox(
                width: 305.0.w,
                height: 40.0.h,
                child: TextFormField(
                  controller: _companyAddressTextController,
                  decoration: loginTextFormUnderlineBorderDecoration(
                    hintText: "도로명주소",
                  ),
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    color: textColor,
                  ),
                  onFieldSubmitted: (text) async {
                    RoadAddressModel data = await SearchCompanyAddressFunction().searchCompanyAddress(keyWord: text, pageNumber: pageNumber);
                    print(data.common.errorMessage);
                    print(data.common.errorCode);
                    if(data.common.errorCode == "0"){
                      jusoList.value = data.jusoList!;
                    }
                    setState(() {
                      errorMessage = data.common.errorMessage;
                      print("eM : ${errorMessage}");
                    });
                  },
                ),
              ),
            ),
            errorMessage == "정상" ? ValueListenableBuilder(
              valueListenable: jusoList,
              builder: (BuildContext context, List<Juso> value, Widget? child){
                print("빌드");
                return Expanded(
                  child: value.length != 0 ? ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (BuildContext context, int index){
                      print("주소");
                      print(value.length);
                      print("indx ${index}");
                      if(index == value.length - 100) {
                        pageNumber = pageNumber + 1;
                        test(k: _companyAddressTextController.text, n: pageNumber);
                      }
                      return Center(child: Text(value[index].roadAddr),);


                    },
                  ) : Center(child: Text("검색 결과 없음"),)
                );
              },
            ) : Center(child: Text(errorMessage),)
          ],
        ),
      ),
    );
  }
}
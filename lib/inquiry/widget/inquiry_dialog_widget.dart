import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';

Future<dynamic> changeProfileDialog({required BuildContext context}) {

  int? selectOption = 0;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0.r),
            ),
            child: Container(
              width: 232.0.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0.w,
                      vertical: 10.0.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff2093F0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0.r),
                        topRight: Radius.circular(12.0.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "프로필 사진 변경",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13.0.sp,
                            fontWeight: fontWeight['Medium'],
                            color: whiteColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 13.0.w,
                            color: whiteColor,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () => backPage(context: context, returnValue: selectOption),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0.h),
                    child: dialogRadioItem(
                      itemName: "프로필 사진 삭제",
                      groupValue: selectOption!,
                      value: 1,
                      onChanged: (int? value) {
                        setState((){
                          selectOption = value;
                        });
                      },
                    ),
                  ),
                  dialogRadioItem(
                    itemName: "앨범에서 사진 선택",
                    groupValue: selectOption!,
                    value: 2,
                    onChanged: (int? value) {
                      setState((){
                        selectOption = value;
                      });
                    },
                  ),
                  dialogRadioItem(
                    itemName: "카메라로 사진 찍기",
                    groupValue: selectOption!,
                    value: 3,
                    onChanged: (int? value) {
                      setState((){
                        selectOption = value;
                      });
                    },
                  ),
                  attendanceDialogElevatedButton(
                    topPadding: 11.0.h,
                    buttonName: "확인",
                    buttonAction: selectOption == 0 ? null : (){
                      backPage(context: context, returnValue: selectOption,);
                    }
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Container dialogRadioItem(
    {required String itemName,
      required int groupValue,
      required int value,
      required ValueChanged<int?> onChanged}) {
  return Container(
    padding: EdgeInsets.only(
      left: 16.0.w,
      right: 16.0.w,
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

Future<dynamic> selectBankDialog({required BuildContext context}) {
  List<String> bankList = [
    "NH농협", "KB국민", "신한", "우리", "하나",
    "IBK기업", "SC제일", "씨티", "KDB산업", "SBI처축은행"
    "새마을", "대구", "광주", "우체국", "신협",
    "전북", "경남", "부산", "수협", "제주",
    "저축은행", "산림조합", "케이뱅크", "카카오뱅크", "HSBC",
    "중국공상", "JP모간", "도이치", "BNP파리바", "BOA",
    "중국건설", "토스증권", "키움", "KB증권", "미래에셋대우",
    "삼성", "NH투자", "유안타", "대신", "한국투자",
    "신한금융투자", "유진투자", "한화투자", "DB금융투자", "하나금융",
    "하이투자", "현대차증권", "신영", "이베스트", "교보",
    "메리츠증권", "KTB투자", "SK", "부국", "케이프투자",
    "한국포스증권", "카카오페이증권"
  ];

  return showDialog(
    context: context,
    builder: (BuildContext context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.r),
        ),
        child: Container(
          width: 232.0.w,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                  vertical: 10.0.h,
                ),
                decoration: BoxDecoration(
                  color: Color(0xff2093F0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0.r),
                    topRight: Radius.circular(12.0.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "은행 선택",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13.0.sp,
                        fontWeight: fontWeight['Medium'],
                        color: whiteColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 13.0.w,
                        color: whiteColor,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () => backPage(context: context, /*returnValue: selectOption*/),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(
                    left: 16.0.w,
                    right: 16.0.w,
                    top: 20.0.h,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: bankList.length,
                  itemBuilder: (BuildContext context, int index){
                    return GridTile(
                      child: GestureDetector(
                        onTap: (){
                          backPage(context: context, returnValue: bankList[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xff2093F0).withOpacity(0.1)
                            ),
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(12.0.r),
                          ),
                          child: Center(
                            child: Text(
                              bankList[index]
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    }
  );
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycompany/jh_test/jh_localDB/dateFormat.dart';
import 'package:mycompany/jh_test/jh_localDB/expenseModel.dart';
import 'package:mycompany/jh_test/jh_localDB/firebase.dart';
import 'package:sizer/sizer.dart';

class LocalDBMain extends StatefulWidget {
  // const LocalDBMain({Key? key}) : super(key: key);

  @override
  _LocalDBMainState createState() => _LocalDBMainState();
}

class _LocalDBMainState extends State<LocalDBMain> {
  FirebaseIORepository _repository = FirebaseIORepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: Scaffold(
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(padding: EdgeInsets.all(10.0)),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.25),
                  side: BorderSide(
                    width: 1,
                    color: Color(0xffeeeeeeee),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.0,
                    horizontal: 3.75,
                  ),
                  child: Container(
                    height: 5.0.h,
                    child: Row(children: [
                      Container(
                        width: 19.0.w,
                        alignment: Alignment.center,
                        child: Text(
                          "exDate()",
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontSize: 8.25.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff2F3A55),
                          ),
                        ),
                      ),
                      Container(width: 1.5.w),
                      Container(
                        width: 13.0.w,
                        alignment: Alignment.center,
                        child: Text(
                          "category",
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontSize: 8.25.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff2F3A55),
                          ),
                        ),
                      ),
                      Container(width: 1.5.w),
                      Container(
                        width: 13.0.w,
                        alignment: Alignment.center,
                        child: Text(
                          "amount()",
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontSize: 8.25.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff2F3A55),
                          ),
                        ),
                      ),
                      Container(width: 1.5.w),
                      Container(
                        width: 13.0.w,
                        alignment: Alignment.center,
                        child: Text(
                          "receipt()",
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontSize: 8.25.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff2F3A55),
                          ),
                        ),
                      ),
                      Container(width: 1.5.w),
                      Container(
                        width: 9.0.w,
                        alignment: Alignment.center,
                        child: Text(
                          "state()",
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontSize: 8.25.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff2F3A55),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              StreamBuilder(
                stream: _repository.getExpense("0S9YLBX", "gofyd135@naver.com"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var _expense = [];
                  snapshot.data.docs.forEach((element) {
                    _expense.add(element);
                  });

                  if (_expense.length == 0) {
                    return Expanded(
                        child: ListView(children: [
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.25),
                          side: BorderSide(
                            width: 1,
                            color: Color(0xffeeeeeeee),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            height: 5.0.h,
                            alignment: Alignment.center,
                            child: Text(
                              "word.categoryCon()",
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontSize: 8.25.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff2F3A55),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]));
                  } else {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: _expense.length,
                            itemBuilder: (context, index) {
                              dynamic _expenseData;
                              _expenseData = ExpenseModel.fromMap(
                                _expense[index].data(),
                                _expense[index].id,
                              );
                              return ExpenseCard(
                                  context,
                                  "0S9YLBX",
                                  _expenseData,
                                  "gofyd135@naver.com",
                                  _expense[index].id);
                            }));
                  }
                },
              ),
              Container(
                  height: 6.0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.amber,
                  ),
                  child: SizedBox(width: 50.0)),
              ElevatedButton(
                child: Text("Back"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ])),
      );
    });
  }
}


Card ExpenseCard(BuildContext context, String companyCode, ExpenseModel model,
    String uid, String id) {
  Format _format = Format();
  var returnString = NumberFormat("###,###", "en_US");

  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(2.25),
      side: BorderSide(
        width: 1,
        color: Color(0xffeeeeeeee),
      ),
    ),
    child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 3.75,
        ),
        child: Container(
            height: 5.0.h,
            child: Row(
              children: [
                Container(
                  width: 17.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    _format.dateFormatForExpenseCard(model.buyDate),
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2F3A55),
                    ),
                  ),
                ),
                Container(width: 1.5.w),
                Container(
                  width: 13.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    model.contentType == "석식비"
                        ? word.dinner()
                        : model.contentType == "중식비"
                            ? word.lunch()
                            : model.contentType == "교통비"
                                ? word.transportation()
                                : word.etc(),
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 8.25.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2F3A55),
                    ),
                  ),
                ),
                Container(width: 1.5.w),
                Container(
                  width: 13.0.w,
                  alignment: Alignment.centerRight,
                  child: Text(
                    returnString.format(model.cost),
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 8.25.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2F3A55),
                    ),
                  ),
                ),
                Container(width: 1.5.w),
                /*Container(
                  width:  13.0.w,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      ExpenseImageDialog(context, model.imageUrl);
                    },
                    child: model.imageUrl == ""
                        ? Container()
                        : Icon(
                      Icons.receipt_long_outlined,
                      size: SizerUtil.deviceType == DeviceType.Tablet
                          ? iconSizeTW.w
                          : iconSizeMW.w,
                    ),
                  ),
                ),*/
                Container(width: 1.5.w),
                Container(
                  width: 9.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    model.status.toString(),
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 8.25.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2F3A55),
                    ),
                  ),
                ),
                _popupMenu(context, companyCode, id, uid),
              ],
            ))),
  );
}

Container _popupMenu(BuildContext context, String companyCode, String id, String uid) {
  FirebaseIORepository _repository = FirebaseIORepository();

  return Container(
      width: 5.0.w,
      alignment: Alignment.center,
      child: PopupMenuButton(
          icon: Icon(
            Icons.arrow_forward_ios_sharp,
            size: 6.0.w,
          ),
          onSelected: (value) async {},
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              height: 7.0.h,
              value: 1,
              child: Row(
                children: [
                  Container(
                    child: Icon(
                      Icons.edit,
                      size: 5.25.w,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 2.0.w)),
                  Text(
                    word.update(),
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontSize: 8.25.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2F3A55),
                    ),
                  )
                ],
              ),
            ),
            PopupMenuItem(
              height: 7.0.h,
              value: 2,
              child: GestureDetector(
                onTap: () {
                  _repository.deleteExpense(companyCode, id, uid);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: 5.25.w,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 2.0.w)),
                    Text(
                      word.delete(),
                      style: TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontSize: 8.25.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff2F3A55),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]));
}

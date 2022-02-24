
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/schedule/view/schedule_registration_view.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PublicFunction {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void mainNavigator(BuildContext context, Widget navigator, bool isMove,
      UserModel loginUser, EmployeeModel employeeModel) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => StreamProvider<EmployeeModel>(
                create: (BuildContext context) => PublicFirebaseRepository()
                    .getEmployeeUser(loginUser: loginUser),
                initialData: employeeModel,
                child: navigator)),
        (route) => isMove);
  }

  Future<bool> onBackPressed(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduleView(),
        ));
    return true;
  }

  Future<bool> onScheduleBackPressed(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduleView(),
        ),
        (route) => false);
    return true;
  }

  UserModel getUserProviderSetting(BuildContext context) {
    UserInfoProvider userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);

    return userInfoProvider.getUserData()!;
  }

  UserModel getUserProviderListenSetting(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);

    return userInfoProvider.getUserData()!;
  }

  EmployeeModel getEmployeeProviderSetting(BuildContext context) {
    EmployeeInfoProvider employeeInfoProvider =
        Provider.of<EmployeeInfoProvider>(context, listen: false);

    return employeeInfoProvider.getEmployeeData()!;
  }

  /// Download receipts
  downloadReceipts(UserModel userModel) async {
    debugPrint("downloadReceipts has been executed");
    sleep(const Duration(seconds: 1));
    Directory _directory = await getApplicationDocumentsDirectory();

    var _documents;
    var _docIds = [];
    List<dynamic> _list = [];
    int _count = 0;
    int _imgCount = 0;
    var _expense;


    /// save image to gallery from url
    // _saveToGallery() async {
    //   var response = await Dio().get(
    //       "https://firebasestorage.googleapis.com/v0/b/app-dev-c912f.appspot.com/o/expenses%2F0S9YLBX%2Fbsc2079%40naver.com%2F2021-09-15%2016%3A15%3A26.823431?alt=media&token=d83fbb3d-432f-4b40-af31-3ffc035a4d00",
    //     options: Options(responseType: ResponseType.bytes));
    //   final result = await ImageGallerySaver.saveImage(
    //     Uint8List.fromList(response.data),
    //     quality: 60,
    //     name: "hello");
    //   print(result);
    // }

    _saveToLocal(Uri uri, List<String> list) async {
      // var response = await http.get(Uri.parse("https://firebasestorage.googleapis.com/v0/b/app-dev-c912f.appspot.com/o/expenses%2F0S9YLBX%2Fbsc2079%40naver.com%2F2021-09-15%2016%3A15%3A26.823431?alt=media&token=d83fbb3d-432f-4b40-af31-3ffc035a4d00"));
      // Directory _directory = await getApplicationDocumentsDirectory();
      // File _file = new File(join(_directory.path, '테스.png'));
      // _file.writeAsBytesSync(response.bodyBytes);
      var response = await http.get(uri);
      File _file = new File(join(_directory.path, list[0] + list[1] + list[2] + list[3] + list[4] + '.png'));
      _file.writeAsBytesSync(response.bodyBytes);
    }

    try {
      _documents = _firestore
          .collection("company")
          .doc(userModel.companyCode)
          .collection("workApproval")
          .where("approvalType", isEqualTo: "경비")
          .get()
          .then((QuerySnapshot querySnapshot) {
        print(querySnapshot.docs.length);
        querySnapshot.docs.forEach((doc) {
          //print(doc["title"] + doc["userMail"] + doc["createDate"].toString());
          _docIds = doc["docIds"];
          _docIds.forEach((element) {
            _firestore
                .collection("company")
                .doc(userModel.companyCode)
                .collection("user")
                .doc(doc["userMail"])
                .collection("expense")
                .doc(element)
                .get()
                .then((val) {
              _expense = val.data() as Map<String, dynamic>;

              if (_expense["imageUrl"] != "") {
                _imgCount++;
                /*print(doc["status"] +
                    "|" +
                    doc["approvalDate"].toDate().toString() +
                    "|" +
                    _expense["name"] +
                    "|" +
                    _expense["cost"].toString() +
                    "|" +
                    _expense["detailNote"] +
                    "|" +
                    _expense["imageUrl"]
                );*/
                // print(_imgCount);

                // Directory _directory;
                _saveToLocal(Uri.parse(_expense["imageUrl"]), [doc["status"], doc["approvalDate"].toDate().toString(), _expense["name"], _expense["cost"].toString(), _expense["detailNote"]]);
                // var response = () async {await http.get(Uri.parse(_expense["imageUrl"]));};
                // _directory = await getApplicationDocumentsDirectory();};
                //
                // File _file = new File(join(_directory.path, doc["title"] + " " + _expense["name"] + " " + '.png'));
                // _file.writeAsBytesSync(response.bodyBytes);
              }
            });

            /*if (_expense.data().docs.data["imageUrl"] != "") {
              _list.add([doc["title"], doc["userMail"], _expense["imageUrl"]]);
            }*/
            /*.then((QuerySnapshot snapshot) {
                  snapshot.docs.forEach((_doc) async {
                    if(_doc["imageUrl"] != "") {
                      _count++;
                      //print(_count.toString());
                      _list.add([doc["title"], doc["userMail"], _doc["imageUrl"]]);
                      //print(doc["title"] + doc["userMail"] + _doc["imageUrl"]);
                      // var response = await http.get(Uri.parse(_doc["imageUrl"]));
                      // Directory _directory = await getApplicationDocumentsDirectory();
                      // File _file = new File(join(_directory.path, doc["title"] + doc["userMail"] + '.png'));
                      // _file.writeAsBytesSync(response.bodyBytes);

                      //print(_doc["imageUrl"]);
                    } //else print("empty Url");
                      // sleep(const Duration(seconds: 1));
                  });
            }*/
          });
        });
      });
    } catch (e) {
      debugPrint("Error during downloadReceipts");
      debugPrint(e.toString());
    }

    try {
      debugPrint("Saving image started");

      // var response = await http.get(Uri.parse("https://firebasestorage.googleapis.com/v0/b/app-dev-c912f.appspot.com/o/expenses%2F0S9YLBX%2Fbsc2079%40naver.com%2F2021-09-15%2016%3A15%3A26.823431?alt=media&token=d83fbb3d-432f-4b40-af31-3ffc035a4d00"));
      // Directory _directory = await getApplicationDocumentsDirectory();
      // File _file = new File(join(_directory.path, '테스.png'));
      // _file.writeAsBytesSync(response.bodyBytes);





    } catch (e) {
      debugPrint("Error during save image from URL");
    }


    //sleep(const Duration(seconds: 5));
    print(_list.toString());
  }
}

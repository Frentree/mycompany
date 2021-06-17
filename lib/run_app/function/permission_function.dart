import 'package:flutter/material.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> requestPermissionFunction() async {
  bool i = false;

  Map<Permission, PermissionStatus> permissionStatus = await [
    Permission.location,
  ].request();

  if(permissionStatus.values.every((element) => element.isGranted)){
    return "OK";
  }


  /*else{
    await openAppSettings().whenComplete(() async {

      locationPermissionStatus = await Permission.location.status;
      print(locationPermissionStatus);

    });
  }*/
  /*else{
    await openAppSettings();
    var locationPermissionStatus = await Permission.location.status;
    if(locationPermissionStatus.isGranted){
      return "OK";
    }
  }*/

  return "NO";
}

Future<bool> checkPermissionFunction() async {
  print("권한확인");
  var locationPermissionStatus = await Permission.location.status;

  if(locationPermissionStatus.isGranted){
    return true;
  }

  else{
    return false;
  }
}

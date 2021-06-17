import 'package:flutter/material.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermissionFunction() async {
  Map<Permission, PermissionStatus> permissionStatus = await [
    Permission.location,
  ].request();

  if(permissionStatus.values.every((element) => element.isGranted)){
    return true;
  }

  return false;
}

Future<bool> checkPermissionFunction() async {
  var locationPermissionStatus = await Permission.location.status;

  if(locationPermissionStatus.isGranted){
    return true;
  }

  else{
    return false;
  }
}

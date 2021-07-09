import 'package:flutter/material.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:location/location.dart' as loc;

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
    if (foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS) {
      return checkIOSPermission();
    }
    return false;
  }
}

Future<bool> checkIOSPermission() async {
  print('TargetPlatform is iOS');
  loc.Location location = new loc.Location();

  bool _serviceEnabled;
  loc.PermissionStatus _permissionGranted;
  loc.LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      print('!_serviceEnabled');
      return false;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == loc.PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != loc.PermissionStatus.granted) {
      print('_permissionGranted != loc.PermissionStatus.granted');
      return false;
    }
  } else {
    print('This iOS device HAS PERMISSION');
    return true;
  }

  _locationData = await location.getLocation();
  print('_locationData = $_locationData');
  return false;
}
import 'package:flutter/material.dart';

String changeWorkTypeNumberToString({required int workTypeNumber}){
  String workTypeString = "";

  switch(workTypeNumber){
    case 0: workTypeString = "출근전";
    break;
    case 1: workTypeString = "내근";
    break;
    case 2: workTypeString = "외근";
    break;
    case 3: workTypeString = "직출";
    break;
    case 4: workTypeString = "재택";
    break;
    case 5: workTypeString = "연차";
    break;
    case 6: workTypeString = "퇴근";
    break;
  }

  return workTypeString;
}
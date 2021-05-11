import 'package:cloud_firestore/cloud_firestore.dart';

class DateFormat {
  DateTime changeTimeStampToDateTime({required Timestamp timestamp}) {
    DateTime dateTime = timestamp.toDate();

    return dateTime;
  }

  Timestamp changeDateTimeToTimeStamp({required DateTime dateTime}) {

    Timestamp timestamp = Timestamp.fromDate(dateTime);

    return timestamp;
  }

  String dateFormat({required DateTime date}){
    String dateText;

    dateText = date.year.toString() + "년 " + twoDigitsFormat(date.month) + "월 " + twoDigitsFormat(date.day) + "일";
    return dateText;
  }

  String dateTimeFormat({required DateTime date}){
    String dateText;

    dateText = date.year.toString() + "년 " + twoDigitsFormat(date.month) + "월 " + twoDigitsFormat(date.day) + "일 " + date.hour.toString() + "시 " + date.minute.toString() + "분";
    return dateText;
  }

  String twoDigitsFormat(int date) {
    String newDate = "";

    if (date < 10) {
      newDate = "0" + date.toString();
    }

    else {
      newDate = date.toString();
    }

    return newDate;
  }
}

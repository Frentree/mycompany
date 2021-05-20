import 'package:cloud_firestore/cloud_firestore.dart';

class DateFormat {
  DateTime changeTimeStampToDateTime({required Timestamp timestamp}) {
    DateTime dateTime = timestamp.toDate();

    return dateTime;
  }

  String cangeWeekDay({required DateTime date}){
    late String dateText;

    switch(date.weekday){
      case 1: dateText = "월";
        break;
      case 2: dateText = "화";
        break;
      case 3: dateText = "수";
        break;
      case 4: dateText = "목";
        break;
      case 5: dateText = "금";
        break;
      case 6: dateText = "토";
        break;
      case 7: dateText = "일";
        break;
    }

    return dateText;
  }

  Timestamp changeDateTimeToTimeStamp({required DateTime dateTime}) {

    Timestamp timestamp = Timestamp.fromDate(dateTime);

    return timestamp;
  }

  String dateFormat({required DateTime date}){
    String dateText;

    dateText = /*date.year.toString() + "년 " + */twoDigitsFormat(date.month) + "월 " + twoDigitsFormat(date.day) + "일 (" + cangeWeekDay(date: date) +")";
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

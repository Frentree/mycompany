import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateFormatCustom {
  String changeWeekDay({required DateTime date}){
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

  DateTime changeTimestampToDateTime({required Timestamp timestamp}) {
    DateTime dateTime = timestamp.toDate();

    return dateTime;
  }

  DateTime showDateTimeUpToMinutes({required DateTime dateTime}) {
    DateTime returnDatetime = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);

    return returnDatetime;
  }

  DateTime changeStringToDateTime({required String dateString}) {
    DateTime dateTime = DateTime.parse(dateString);

    return dateTime;
  }

  Timestamp changeDateTimeToTimestamp({required DateTime dateTime}) {

    Timestamp timestamp = Timestamp.fromDate(dateTime);

    return timestamp;
  }

  Timestamp showTimestampUpToMinutes({required Timestamp timestamp}) {
    DateTime changeDateTime = changeTimestampToDateTime(timestamp: timestamp);
    Timestamp returnTimestamp = changeDateTimeToTimestamp(dateTime: showDateTimeUpToMinutes(dateTime: changeDateTime));

    return returnTimestamp;
  }

  Timestamp changeStringToTimestamp({required String dateString}) {
    Timestamp timestamp = Timestamp.fromDate(
        changeStringToDateTime(dateString: dateString));

    return timestamp;
  }

  String todayStringFormat(){
    DateTime todayDateTime = DateTime.now();
    String today = "${todayDateTime.year}년 ${todayDateTime.month}월 ${todayDateTime.day}일 ${changeWeekDay(date: todayDateTime)}요일";

    return today;
  }

  String dateStringFormatSeparatorDot({required dynamic date, bool? isIncludeWeekday}){
    if(date.runtimeType == Timestamp){
      date = changeTimestampToDateTime(timestamp: date);
    }

    String returnString = (isIncludeWeekday != null && isIncludeWeekday == true)? "${date.year}.${twoDigitsFormat(date.month)}.${twoDigitsFormat(date.day)}(${changeWeekDay(date: date)})" : "${date.year}.${twoDigitsFormat(date.month)}.${twoDigitsFormat(date.day)}";

    return returnString;
  }

  String changeTimeToString({required dynamic time}){
    if(time.runtimeType == Timestamp){
      time = changeTimestampToDateTime(timestamp: time);
    }

    String returnString = "${time.hour}:${twoDigitsFormat(time.minute)}";

    return returnString;
  }

  String changeDateToString({required dynamic date, bool? isIncludeWeekday}){
    if(date.runtimeType == Timestamp){
      date = changeTimestampToDateTime(timestamp: date);
    }

    String returnString = (isIncludeWeekday != null && isIncludeWeekday == true)? "${date.month}/${date.day}(${changeWeekDay(date: date)})" : "${date.month}/${date.day}";

    return returnString;
  }


  String dateFormat({required DateTime date}){
    String dateText;

    dateText = /*date.year.toString() + "년 " + */twoDigitsFormat(date.month) + "월 " + twoDigitsFormat(date.day) + "일 (" + changeWeekDay(date: date) +")";
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

  String amAndPm(DateTime date){
    String dateText = "";

    if(0 < DateTime(date.year, date.month, date.day, 12, 00).difference(date).inHours){
      dateText = "AM";
    } else {
      dateText = "PM";
    }

    return dateText;

  }


  // ex) 09 : 05 AM
  String getTime({required DateTime date}){
    String dateText;

    dateText = twoDigitsFormat(date.hour).toString() + " : " + twoDigitsFormat(date.minute).toString() + " " + amAndPm(date);
    return dateText;
  }

  // ex) 2020.10.15(수)
  String getDate({required DateTime date}) {

    return date.year.toString() + "." +  twoDigitsFormat(date.month) + "." + twoDigitsFormat(date.day) + "(" + changeWeekDay(date: date) +")";
  }

  String getMonthAndDay({required DateTime date}) {

    return twoDigitsFormat(date.month) + "." + twoDigitsFormat(date.day) + "(" + changeWeekDay(date: date) +")";
  }
  
  // 연차 등록시 12시 변경
  Timestamp updateAttendance({required Timestamp date}){
    DateTime parseDate = date.toDate();
    parseDate = DateTime(parseDate.year, parseDate.month, parseDate.day, 12, 00, 00);

    Timestamp dateTime = Timestamp.fromDate(parseDate);
    return dateTime;
  }

}

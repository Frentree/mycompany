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

  DateTime changeStringToDateTime({required String dateString}) {
    DateTime dateTime = DateTime.parse(dateString);

    return dateTime;
  }

  Timestamp changeStringToTimeStamp({required String dateString}) {
    Timestamp timestamp = Timestamp.fromDate(changeStringToDateTime(dateString: dateString));

    return timestamp;
  }
}

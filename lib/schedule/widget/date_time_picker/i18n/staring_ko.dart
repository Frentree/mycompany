import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Korea (KO)
class StringsKo extends StringsI18n {
  const StringsKo();

  @override
  String getCancelText() {
    return '취소';
  }

  @override
  String getDoneText() {
    return '완료';
  }

  @override
  List<String> getMonths() {
    return [
      "1월",
      "2월",
      "3월",
      "4월",
      "5월",
      "6월",
      "7월",
      "8월",
      "9월",
      "10월",
      "11월",
      "12월"
    ];
  }

  @override
  List<String> getWeeksFull() {
    return [
      "월요일",
      "화요일",
      "수요일",
      "목요일",
      "금요일",
      "토요일",
      "일요일",
    ];
  }

  @override
  List<String> getWeeksShort() {
    return [
      "월",
      "화",
      "수",
      "목",
      "금",
      "토",
      "일",
    ];
  }

  @override
  List<String>? getMonthsShort() {
    // TODO: implement getMonthsShort
    return null;
  }
}

import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Arabic (ar)
class StringsAr extends StringsI18n {
  const StringsAr();

  @override
  String getCancelText() {
    return 'ألغاء';
  }

  @override
  String getDoneText() {
    return 'تم';
  }

  @override
  List<String> getMonths() {
    return [
      "كانون الثاني",
      "شباط",
      "آذار",
      "نيسان",
      "أيار",
      "حزيران",
      "تموز",
      "آب",
      "أيلول",
      "تشرين الأول",
      "تشرين الثاني",
      "كانون الأول"
    ];
  }

  @override
  List<String> getWeeksFull() {
    return [
      "الأثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعه",
      "السبت",
      "الأحد",
    ];
  }

  @override
  List<String>? getWeeksShort() {
    return null;
  }

  @override
  List<String>? getMonthsShort() {
    // TODO: implement getMonthsShort
    return null;
  }
}

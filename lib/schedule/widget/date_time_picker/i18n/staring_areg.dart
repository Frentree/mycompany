
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Arabic (ar) Egypt
class StringsArEg extends StringsI18n {
  const StringsArEg();

  @override
  String getCancelText() {
    return 'إلغاء';
  }

  @override
  String getDoneText() {
    return 'تم';
  }

  @override
  List<String> getMonths() {
    return [
      "يناير",
      "فبراير",
      "مارس",
      "أبريل",
      "مايو",
      "يونيو",
      "يوليو",
      "أغسطس",
      "سبتمبر",
      "أكتوبر",
      "نوفمبر",
      "ديسمبر"
    ];
  }

  @override
  List<String>? getMonthsShort() {
    return null;
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
  List<String> getWeeksShort() {
    return [
      "ن",
      "ث",
      "ر",
      "خ",
      "ج",
      "س",
      "ح",
    ];
  }
}

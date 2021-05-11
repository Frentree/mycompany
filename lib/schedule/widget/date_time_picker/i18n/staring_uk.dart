import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Ukraine (UK)
class StringsUk extends StringsI18n {
  const StringsUk();

  @override
  String getCancelText() {
    return 'Скасувати';
  }

  @override
  String getDoneText() {
    return 'Готово';
  }

  @override
  List<String> getMonths() {
    return [
      "Cічень",
      "Лютий",
      "Березень",
      "Квітень",
      "Травень",
      "Червень",
      "Липень",
      "Серпень",
      "Вересень",
      "Жовтень",
      "Листопад",
      "Грудень",
    ];
  }

  @override
  List<String>? getMonthsShort() {
    return null;
  }

  @override
  List<String> getWeeksFull() {
    return [
      "Понеділок",
      "Вівторок",
      "Середа",
      "Четвер",
      "П\'ятниця",
      "Субота",
      "Неділя",
    ];
  }

  @override
  List<String> getWeeksShort() {
    return [
      "пн",
      "вт",
      "ср",
      "чт",
      "пт",
      "сб",
      "нд",
    ];
  }
}

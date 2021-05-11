import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Russian (RU)
class StringsRu extends StringsI18n {
  const StringsRu();

  @override
  String getCancelText() {
    return 'Отмена';
  }

  @override
  String getDoneText() {
    return 'Готово';
  }

  @override
  List<String> getMonths() {
    return [
      "Январь",
      "Февраль",
      "Март",
      "Апрель",
      "Май",
      "Июнь",
      "Июль",
      "Август",
      "Сентябрь",
      "Октябрь",
      "Ноябрь",
      "Декабрь",
    ];
  }

  @override
  List<String> getWeeksFull() {
    return [
      "Понедельник",
      "Вторник",
      "Среда",
      "Четверг",
      "Пятница",
      "Суббота",
      "Воскресенье",
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
      "вс",
    ];
  }

  @override
  List<String>? getMonthsShort() {
    // TODO: implement getMonthsShort
    return null;
  }
}

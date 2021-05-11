import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// German (DE)
class StringsDe extends StringsI18n {
  const StringsDe();

  @override
  String getCancelText() {
    return 'Abbrechen';
  }

  @override
  String getDoneText() {
    return 'Fertig';
  }

  @override
  List<String> getMonths() {
    return [
      "Januar",
      "Februar",
      "März",
      "April",
      "Mai",
      "Juni",
      "Juli",
      "August",
      "September",
      "Oktober",
      "November",
      "Dezember",
    ];
  }

  @override
  List<String> getWeeksFull() {
    return [
      "Montag",
      "Dienstag",
      "Mittwoch",
      "Donnerstag",
      "Freitag",
      "Samstag",
      "Sonntag",
    ];
  }

  @override
  List<String> getWeeksShort() {
    return [
      "Mo",
      "Di",
      "Mi",
      "Do",
      "Fr",
      "Sa",
      "So",
    ];
  }

  @override
  List<String>? getMonthsShort() {
    // TODO: implement getMonthsShort
    return null;
  }
}

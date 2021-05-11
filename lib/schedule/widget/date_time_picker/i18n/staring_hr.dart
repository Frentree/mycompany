import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Croatian (HR)
class StringsHr extends StringsI18n {
  const StringsHr();

  @override
  String getCancelText() {
    return 'Otkaži';
  }

  @override
  String getDoneText() {
    return 'Završi';
  }

  @override
  List<String> getMonths() {
    return [
      "Siječanj",
      "Veljača",
      "Ožujak",
      "Travanj",
      "Svibanj",
      "Lipanj",
      "Srpanj",
      "Kolovoz",
      "Rujan",
      "Listopad",
      "Studeni",
      "Prosinac",
    ];
  }

  @override
  List<String>? getMonthsShort() {
    return null;
  }

  @override
  List<String> getWeeksFull() {
    return [
      "Ponedjeljak",
      "Utorak",
      "Srijeda",
      "Četvrtak",
      "Petak",
      "Subota",
      "Nedjelja",
    ];
  }

  @override
  List<String> getWeeksShort() {
    return [
      "Pon",
      "Uto",
      "Sri",
      "Čet",
      "Pet",
      "Sub",
      "Ned",
    ];
  }
}

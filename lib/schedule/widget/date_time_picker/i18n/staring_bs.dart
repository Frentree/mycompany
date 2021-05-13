import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Bosnian (BS)
class StringsBs extends StringsI18n {
  const StringsBs();

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
      "Januar",
      "Februar",
      "Mart",
      "April",
      "Maj",
      "Juni",
      "Juli",
      "August",
      "Septembar",
      "Oktobar",
      "Novembar",
      "Decembar",
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

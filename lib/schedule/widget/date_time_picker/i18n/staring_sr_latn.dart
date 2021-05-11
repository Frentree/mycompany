import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Serbia (sr) Latin
class StringsSrLatin extends StringsI18n {
  const StringsSrLatin();

  @override
  String getCancelText() {
    return 'Otkaži';
  }

  @override
  String getDoneText() {
    return 'Izaberi';
  }

  @override
  List<String> getMonths() {
    return [
      "Januar",
      "Februar",
      "Mart",
      "April",
      "Maj",
      "Jun",
      "Jul",
      "Avgust",
      "Septembar",
      "Octobar",
      "Novembar",
      "Decembar"
    ];
  }

  @override
  List<String>? getMonthsShort() {
    return null;
  }

  @override
  List<String> getWeeksFull() {
    return [
      "Ponedeljak",
      "Utorak",
      "Sreda",
      "Četvrtak",
      "Petak",
      "Subota",
      "Nedelja",
    ];
  }

  @override
  List<String> getWeeksShort() {
    return [
      "Pon",
      "Uto",
      "Sre",
      "Čet",
      "Pet",
      "Sub",
      "Ned",
    ];
  }
}

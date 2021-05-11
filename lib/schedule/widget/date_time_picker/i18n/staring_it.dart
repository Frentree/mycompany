import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Italian (IT)
class StringsIt extends StringsI18n {
  const StringsIt();

  @override
  String getCancelText() {
    return 'Annulla';
  }

  @override
  String getDoneText() {
    return 'Salva';
  }

  @override
  List<String> getMonths() {
    return [
      "Gennaio",
      "Febbraio",
      "Marzo",
      "Aprile",
      "Maggio",
      "Giugno",
      "Luglio",
      "Agosto",
      "Settembre",
      "Ottobre",
      "Novembre",
      "Dicembre"
    ];
  }

  @override
  List<String> getWeeksFull() {
    return [
      "Lunedì",
      "Martedì",
      "Mercoledì",
      "Giovedì",
      "Venerdì",
      "Sabato",
      "Domenica",
    ];
  }

  @override
  List<String> getWeeksShort() {
    return [
      "Lu",
      "Ma",
      "Me",
      "Gi",
      "Ve",
      "Sa",
      "Do",
    ];
  }

  @override
  List<String>? getMonthsShort() {
    // TODO: implement getMonthsShort
    return null;
  }
}


import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// French (FR)
class StringsFr extends StringsI18n {
  const StringsFr();

  @override
  String getCancelText() {
    return 'Annuler';
  }

  @override
  String getDoneText() {
    return 'Accepter';
  }

  @override
  List<String> getMonths() {
    return [
      "Janvier",
      "Février",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Juillet",
      "Août",
      "Septembre",
      "Octobre",
      "Novembre",
      "Décembre",
    ];
  }

  @override
  List<String> getMonthsShort() {
    return [
      "Janv.",
      "Févr.",
      "Mars",
      "Avr.",
      "Mai",
      "Juin",
      "Juil.",
      "Août",
      "Sept.",
      "Oct.",
      "Nov.",
      "Déc."
    ];
  }

  @override
  List<String> getWeeksFull() {
    return [
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi",
      "Samedi",
      "Dimanche",
    ];
  }

  @override
  List<String> getWeeksShort() {
    return [
      "Lun.",
      "Mar.",
      "Mer.",
      "Jeu.",
      "Ven.",
      "Sam.",
      "Dim.",
    ];
  }
}

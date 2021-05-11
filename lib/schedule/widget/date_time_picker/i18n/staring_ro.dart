import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Romanian (RO)
class StringsRo extends StringsI18n {
  const StringsRo();

  @override
  String getCancelText() {
    return "Anulare";
  }

  @override
  String getDoneText() {
    return "Ok";
  }

  @override
  List<String> getMonths() {
    return ["Ianuarie", "Februarie", "Martie", "Aprilie", "Mai", "Iunie", "Iulie", "August", "Septembrie", "Octombrie", "Noiembrie", "Decembrie"];
  }

  @override
  List<String> getWeeksFull() {
    return ["Luni", "Marti", "Miercuri", "Joi", "Vineri", "Sambata", "Duminica"];
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

@override
List<String> getMonths() {
  return ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
}

@override
List<String> getMonthsShort() {
  return [
    "Jan.",
    "Feb.",
    "Mar.",
    "Apr.",
    "May",
    "Jun",
    "Jul.",
    "Aug.",
    "Sep.",
    "Oct.",
    "Nov.",
    "Dec.",
  ];
}

@override
List<String> getWeeksFull() {
  return [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
}

@override
List<String> getWeeksShort() {
  return [
    "Mon",
    "Tue",
    "Wed",
    "Thur",
    "Fri",
    "Sat",
    "Sun",
  ];
}

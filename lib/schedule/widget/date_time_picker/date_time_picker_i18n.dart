import 'dart:math';

import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_strings_de.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_ar.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_areg.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_bn.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_bs.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_enus.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_es.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_fr.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_hr.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_hu.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_id.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_it.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_jp.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_ko.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_nl.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_ptbr.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_ro.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_ru.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_sr_cyrl.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_sr_latn.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_tr.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_uk.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_vn.dart';
import 'package:mycompany/schedule/widget/date_time_picker/i18n/staring_zhcn.dart';

abstract class StringsI18n {
  const StringsI18n();

  /// Get the done widget text
  String getDoneText();

  /// Get the cancel widget text
  String getCancelText();

  /// Get the name of month
  List<String> getMonths();

  /// Get the short name of month
  List<String>? getMonthsShort();

  /// Get the full name of week
  List<String> getWeeksFull();

  /// Get the short name of week
  List<String>? getWeeksShort();
}

enum DateTimePickerLocale {
  /// English (EN) United States
  en_us,

  /// Chinese (ZH) Simplified
  zh_cn,

  /// Portuguese (PT) Brazil
  pt_br,

  /// Indonesia (ID)
  id,

  /// Spanish (ES)
  es,

  /// Turkish (TR)
  tr,

  /// French (FR)
  fr,

  /// Romanian (RO)
  ro,

  /// Bengali (BN)
  bn,

  /// Bosnian (BS)
  bs,

  /// Arabic (ar)
  ar,

  /// Arabic (ar) Egypt
  ar_eg,

  /// Japanese (JP)
  jp,

  /// Russian (RU)
  ru,

  /// German (DE)
  de,

  /// Korea (KO)
  ko,

  /// Italian (IT)
  it,

  /// Hungarian (HU)
  hu,

  /// Croatian (HR)
  hr,

  /// Ukrainian (UK)
  uk,

  /// Vietnamese (VN)
  vi,

  /// Serbia (sr) Cyrillic
  sr_cyrl,

  /// Serbia (sr) Latin
  sr_latn,

  /// Dutch (NL)
  nl,
}

/// Default value of date locale
const DateTimePickerLocale DATETIME_PICKER_LOCALE_DEFAULT =
    DateTimePickerLocale.en_us;

const Map<DateTimePickerLocale, StringsI18n> datePickerI18n = {
  DateTimePickerLocale.en_us: const StringsEnUs(),
  DateTimePickerLocale.zh_cn: const StringsZhCn(),
  DateTimePickerLocale.pt_br: const StringsPtBr(),
  DateTimePickerLocale.id: const StringsId(),
  DateTimePickerLocale.ar_eg: const StringsArEg(),
  DateTimePickerLocale.es: const StringsEs(),
  DateTimePickerLocale.fr: const StringsFr(),
  DateTimePickerLocale.ro: const StringsRo(),
  DateTimePickerLocale.bn: const StringsBn(),
  DateTimePickerLocale.bs: const StringsBs(),
  DateTimePickerLocale.ar: const StringsAr(),
  DateTimePickerLocale.jp: const StringsJp(),
  DateTimePickerLocale.ru: const StringsRu(),
  DateTimePickerLocale.de: const StringsDe(),
  DateTimePickerLocale.ko: const StringsKo(),
  DateTimePickerLocale.it: const StringsIt(),
  DateTimePickerLocale.hu: const StringsHu(),
  DateTimePickerLocale.hr: const StringsHr(),
  DateTimePickerLocale.uk: const StringsUk(),
  DateTimePickerLocale.tr: const StringsTr(),
  DateTimePickerLocale.vi: const StringsVn(),
  DateTimePickerLocale.sr_cyrl: const StringsSrCyrillic(),
  DateTimePickerLocale.sr_latn: const StringsSrLatin(),
  DateTimePickerLocale.nl: const StringsNl(),
};

class DatePickerI18n {
  /// Get done button text
  static String getLocaleDone(DateTimePickerLocale locale) {
    StringsI18n i18n = datePickerI18n[locale] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;
    return i18n.getDoneText() /*?? datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT].getDoneText()*/;
  }

  /// Get cancel button text
  static String getLocaleCancel(DateTimePickerLocale locale) {
    StringsI18n i18n = datePickerI18n[locale] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;
    return i18n.getCancelText() /*?? datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getCancelText()*/;
  }

  /// Get locale month array
  static List<String> getLocaleMonths(DateTimePickerLocale locale,
      [bool isFull = true]) {
    StringsI18n i18n = datePickerI18n[locale] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;

    if (isFull) {
      List<String> months = i18n.getMonths();
      if (months != null && months.isNotEmpty) {
        return months;
      }
      return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getMonths();
    }

    List<String> months = i18n.getMonthsShort()!;
    if (months != null && months.isNotEmpty && months.length == 12) {
      return months;
    }
    return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getMonthsShort()!;
  }

  /// Get locale week array
  static List<String> getLocaleWeeks(DateTimePickerLocale locale,
      [bool isFull = true]) {
    StringsI18n i18n = datePickerI18n[locale] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;
    if (isFull) {
      List<String> weeks = i18n.getWeeksFull();
      if (weeks != null && weeks.isNotEmpty) {
        return weeks;
      }
      return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getWeeksFull();
    }

    List<String> weeks = i18n.getWeeksShort()!;
    if (weeks != null && weeks.isNotEmpty) {
      return weeks;
    }

    List<String> fullWeeks = i18n.getWeeksFull();
    if (fullWeeks != null && fullWeeks.isNotEmpty) {
      return fullWeeks
          .map((item) => item.substring(0, min(3, item.length)))
          .toList();
    }
    return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getWeeksShort()!;
  }
}

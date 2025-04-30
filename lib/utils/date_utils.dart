import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getGreeting(BuildContext context) {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return AppLocalizations.of(context)!.goodMorning;
  } else if (hour < 18) {
    return AppLocalizations.of(context)!.goodAfternoon;
  } else {
    return AppLocalizations.of(context)!.goodEvening;
  }
}

String formatDateManual(BuildContext context, DateTime date) {
  final l10n = AppLocalizations.of(context)!;
  final List<String> months = [
    '',
    l10n.month1,
    l10n.month2,
    l10n.month3,
    l10n.month4,
    l10n.month5,
    l10n.month6,
    l10n.month7,
    l10n.month8,
    l10n.month9,
    l10n.month10,
    l10n.month11,
    l10n.month12
  ];
  return '${date.day} ${months[date.month]} ${date.year}';
}

String formatMonth(BuildContext context, DateTime date) {
  final l10n = AppLocalizations.of(context)!;
  final List<String> months = [
    '',
    l10n.month1,
    l10n.month2,
    l10n.month3,
    l10n.month4,
    l10n.month5,
    l10n.month6,
    l10n.month7,
    l10n.month8,
    l10n.month9,
    l10n.month10,
    l10n.month11,
    l10n.month12
  ];
  return "${months[date.month]} ${date.year}";
}

String formatDateOnly(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
}

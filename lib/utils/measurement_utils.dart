import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getTranslatedMeasurementName(BuildContext context, String measurementName) {
  switch (measurementName) {
    case 'Height':
      return AppLocalizations.of(context)!.height;
    case 'Weight':
      return AppLocalizations.of(context)!.weight;
    case 'Temperature':
      return AppLocalizations.of(context)!.temperature;
    default:
      return measurementName; 
  }
}

String formatCentimeters(String mmString) {
  final mm =
      double.tryParse(mmString.replaceAll(RegExp(r'[^0-9.]'), '').trim()) ?? 0;
  final centimeters = mm / 10;
  return centimeters.toStringAsFixed(1);
}

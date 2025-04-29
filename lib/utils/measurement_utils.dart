Map<String, String> measurementTranslations = {
  'Height': 'Lengte',
  'Weight': 'Gewicht',
  'Temperature': 'Temperatuur',
};

String getTranslatedMeasurementName(String measurementName) {
  return measurementTranslations[measurementName] ?? measurementName;
}
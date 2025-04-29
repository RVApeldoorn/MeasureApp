String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Goedemorgen';
  } else if (hour < 18) {
    return 'Goedemiddag';
  } else {
    return 'Goedenavond';
  }
}

String formatDateManual(DateTime date) {
  const List<String> months = [
    '', 'januari', 'februari', 'maart', 'april', 'mei', 'juni',
    'juli', 'augustus', 'september', 'oktober', 'november', 'december'
  ];
  return '${date.day} ${months[date.month]} ${date.year}';
}

String formatMonth(DateTime date) {
  const List<String> months = [
    '', 'januari', 'februari', 'maart', 'april', 'mei', 'juni',
    'juli', 'augustus', 'september', 'oktober', 'november', 'december'
  ];
  return "${months[date.month]} ${date.year}";
}

String formatDateOnly(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
}
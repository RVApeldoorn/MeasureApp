import 'package:flutter/material.dart';
import 'package:measureapp/screens/height_measurement_screen.dart';
import 'package:measureapp/screens/measurement_result_screen.dart';
import 'package:measureapp/screens/temperature_measurement_screen.dart';
import 'package:measureapp/screens/weight_measurement_screen.dart';
import 'package:measureapp/utils/date_utils.dart';
import 'package:measureapp/utils/measurement_utils.dart';
import 'package:measureapp/widgets/measurement_request.dart';

class SessionBlock extends StatelessWidget {
  final dynamic session;

  const SessionBlock({required this.session});

  Color getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference <= 0) {
      return Color(0xFFFF8A80);
    } else if (difference <= 2) {
      return Color(0xFFFFAB91);
    } else if (difference <= 7) {
      return Color(0xFFFFCC80);
    } else {
      return Color(0xFF1D53BF);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> requests = session['requests'] ?? [];
    int filledCount = requests.where((r) => (r['measurementValue'] as List?)?.isNotEmpty == true).length;
    bool allFilled = session['isCompleted'];

    DateTime dueDate = DateTime.tryParse(session['dueDate'] ?? '') ?? DateTime.now();
    Color dueDateColor = getDueDateColor(dueDate);

    String title = 'Meetverzoek ${formatMonth(dueDate)}';

    return Card(
      elevation: 0,
      color: Color(0xFFE8EDF8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '$filledCount/${requests.length} voldaan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            if (!allFilled)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Deadline: ',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: formatDateManual(dueDate),
                        style: TextStyle(
                          color: dueDateColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 16),
            ...requests.map((request) {
              String measurementName = request['measurementType']['name'];
              bool isFilled = (request['measurementValue'] as List?)?.isNotEmpty == true;

              return MeasurementRequest(
                title: getTranslatedMeasurementName(measurementName),
                isFilled: isFilled,
                onPressed: () {
                  if (isFilled) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeasurementResultScreen(
                          measurementName: measurementName,
                          measurementValue: request['measurementValue'],
                        ),
                      ),
                    );
                  } else {
                    switch (measurementName.toLowerCase()) {
                      case 'height':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeightMeasurementScreen(
                              sessionId: session['sessionId'],
                              requestId: request['requestId'],
                            ),
                          ),
                        );
                        break;
                      case 'weight':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeightMeasurementScreen(
                              sessionId: session['sessionId'],
                              requestId: request['requestId'],
                            ),
                          ),
                        );
                        break;
                      case 'temperature':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TemperatureMeasurementScreen(
                              sessionId: session['sessionId'],
                              requestId: request['requestId'],
                            ),
                          ),
                        );
                        break;
                      default:
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Metingstype niet geïmplementeerd')),
                        );
                    }
                  }
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
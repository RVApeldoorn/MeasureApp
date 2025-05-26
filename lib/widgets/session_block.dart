import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/measurement_result_screen.dart';
import 'package:measureapp/screens/measurement_screens/step_one.dart';
import 'package:measureapp/screens/relaxing_exercise/exercise_one.dart';
import 'package:measureapp/screens/temperature_measurement_screen.dart';
import 'package:measureapp/screens/weight_measurement_screen.dart';
import 'package:measureapp/utils/date_utils.dart';
import 'package:measureapp/utils/measurement_utils.dart';
import 'package:measureapp/widgets/measurement_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionBlock extends StatelessWidget {
  final dynamic session;

  const SessionBlock({required this.session});

  Color getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference <= 7) {
      return const Color.fromARGB(255, 255, 153, 0);
    } else {
      return const Color(0xFF1D53BF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    List<dynamic> requests = session['requests'] ?? [];
    int filledCount =
        requests
            .where((r) => (r['measurementValue'] as List?)?.isNotEmpty == true)
            .length;
    bool allFilled = session['isCompleted'];

    DateTime dueDate = DateTime.tryParse(session['dueDate'] ?? '') ?? DateTime.now();
    Color dueDateColor = getDueDateColor(dueDate);

    String title = localizations.session_title(formatMonth(context, dueDate));
    String status = localizations.session_fulfilled(
      filledCount.toString(),
      requests.length.toString(),
    );

    return Card(
      elevation: 0,
      color: const Color(0xFFE7EDF9),
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  status,
                  style: const TextStyle(
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
                    style: const TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                        text: localizations.session_deadline_label,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: formatDateManual(context, dueDate),
                        style: TextStyle(
                          color: dueDateColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ...requests.map((request) {
              String measurementName = request['measurementType']['name'];
              bool isFilled = (request['measurementValue'] as List?)?.isNotEmpty == true;

              return MeasurementRequest(
                title: getTranslatedMeasurementName(context, measurementName),
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
                              builder: (context) {
                                return FutureBuilder<SharedPreferences>(
                                  future: SharedPreferences.getInstance(),
                                  builder: (context, snapshot) {
                                    final prefs = snapshot.data;
                                    final isChildMode = prefs?.getBool('childMode') == true;
                                    if (!snapshot.hasData) {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                    if (isChildMode) {
                                      return ExerciseOne(
                                        sessionId: session['sessionId'],
                                        requestId: request['requestId'],
                                      );
                                    } else {
                                      return StepOne(
                                        sessionId: session['sessionId'],
                                        requestId: request['requestId'],
                                      );
                                    }
                                  },
                                );
                              },
                            )
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
                          SnackBar(
                            content: Text(
                              localizations.session_unimplemented_type,
                            ),
                          ),
                        );
                    }
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
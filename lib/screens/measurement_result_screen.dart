import 'package:flutter/material.dart';
import 'package:measureapp/utils/date_utils.dart';
import 'package:measureapp/utils/measurement_utils.dart';

class MeasurementResultScreen extends StatelessWidget {
  final String measurementName;
  final List<dynamic> measurementValue;

  const MeasurementResultScreen({required this.measurementName, required this.measurementValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measurement Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              measurementName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...measurementValue.map((value) {
              return Card(
                child: ListTile(
                  title: Text(
                    'Value: ${formatCentimeters(value['value'].toString())} cm',
                  ),
                  subtitle: Text(
                    'Date: ${value['takenAt'] != null ? formatDateOnly(value['takenAt']) : 'Onbekend'}',
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
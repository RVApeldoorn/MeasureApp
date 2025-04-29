import 'package:flutter/material.dart';

class TemperatureMeasurementScreen extends StatelessWidget {
  final int sessionId;
  final int requestId;

  const TemperatureMeasurementScreen({required this.sessionId, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measure Temperature'),
      ),
      body: Center(
        child: Text('Temperature Measurement Page\nSession ID: $sessionId\nRequest ID: $requestId'),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class WeightMeasurementScreen extends StatelessWidget {
  final int sessionId;
  final int requestId;

  const WeightMeasurementScreen({required this.sessionId, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measure Weight'),
      ),
      body: Center(
        child: Text('Weight Measurement Page\nSession ID: $sessionId\nRequest ID: $requestId'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HeightMeasurementScreen extends StatelessWidget {
  final int sessionId;
  final int requestId;

  const HeightMeasurementScreen({required this.sessionId, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measure Height'),
      ),
      body: Center(
        child: Text('Height Measurement Page\nSession ID: $sessionId\nRequest ID: $requestId'),
      ),
    );
  }
}
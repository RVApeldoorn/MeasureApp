import 'dart:async';
import 'dart:convert';
import 'package:measureapp/services/measurement_service.dart';

class MockMeasurementService implements MeasurementService {
  StreamController<List<int>>? _streamController;
  Stream<List<int>>? _sensorDataStream;
  int _measurementCount = 0;

  @override
  Stream<List<int>>? get sensorDataStream => _sensorDataStream;

  @override
  Future<void> scanAndConnect() async {
    _streamController = StreamController<List<int>>();
    _sensorDataStream = _streamController!.stream;
    _measurementCount = 0;
  }

  @override
  Future<void> sendMeasureCommand() async {
    if (_streamController == null) {
      throw Exception("Not connected to mock sensor");
    }
    _measurementCount++;
    String mockDistance;
    if (_measurementCount % 2 == 0) {
      mockDistance = "628";
    } else {
      mockDistance = "1985";
    }
    _streamController!.add(utf8.encode(mockDistance));
  }

  @override
  Future<void> disconnect() async {
    await _streamController?.close();
    _streamController = null;
    _sensorDataStream = null;
    _measurementCount = 0;
  }
}

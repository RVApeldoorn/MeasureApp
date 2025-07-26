import 'dart:async';

abstract class MeasurementService {
  Stream<List<int>>? get sensorDataStream;
  Future<void> scanAndConnect();
  Future<void> sendMeasureCommand();
  Future<void> disconnect();
}

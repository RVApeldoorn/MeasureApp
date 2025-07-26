import 'package:equatable/equatable.dart';

abstract class MeasurementEvent extends Equatable {
  const MeasurementEvent();

  @override
  List<Object?> get props => [];
}

class MeasurementScanAndConnect extends MeasurementEvent {}

class MeasurementSendMeasureCommand extends MeasurementEvent {}

class MeasurementWaitForNext extends MeasurementEvent {}

class MeasurementAverageRequested extends MeasurementEvent {}

class MeasurementSuccessEvent extends MeasurementEvent {
  final String distance;
  const MeasurementSuccessEvent(this.distance);

  @override
  List<Object?> get props => [distance];
}

class MeasurementTimeoutEvent extends MeasurementEvent {}

class MeasurementDataReceived extends MeasurementEvent {
  final String distance;
  const MeasurementDataReceived(this.distance);

  @override
  List<Object?> get props => [distance];
}

class MeasurementShowLast extends MeasurementEvent {}

class RequestMeasurement extends MeasurementEvent {}

class SaveReferenceMeasurement extends MeasurementEvent {
  final String measurement;
  const SaveReferenceMeasurement(this.measurement);

  @override
  List<Object?> get props => [measurement];
}

class SaveCurrentMeasurement extends MeasurementEvent {
  final String measurement;
  const SaveCurrentMeasurement(this.measurement);

  @override
  List<Object?> get props => [measurement];
}

class StartMeasurement extends MeasurementEvent {
  final int sessionId;
  final int requestId;

  const StartMeasurement(this.sessionId, this.requestId);

  @override
  List<Object?> get props => [sessionId, requestId];
}

class CancelMeasurement extends MeasurementEvent {
  const CancelMeasurement();
}

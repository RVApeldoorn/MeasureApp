import 'package:equatable/equatable.dart';

abstract class MeasurementState extends Equatable {
  final int? sessionId;
  final int? requestId;

  const MeasurementState({this.sessionId, this.requestId});

  @override
  List<Object?> get props => [sessionId, requestId];
}

class MeasurementInitial extends MeasurementState {
  const MeasurementInitial();
}

class MeasurementConnecting extends MeasurementState {
  const MeasurementConnecting({super.sessionId, super.requestId});
}

class MeasurementConnected extends MeasurementState {
  const MeasurementConnected({super.sessionId, super.requestId});
}

class MeasurementMeasuring extends MeasurementState {
  const MeasurementMeasuring({super.sessionId, super.requestId});
}

class MeasurementSuccess extends MeasurementState {
  final String distance;

  const MeasurementSuccess(this.distance, {super.sessionId, super.requestId});

  @override
  List<Object?> get props => [distance, sessionId, requestId];
}

class MeasurementError extends MeasurementState {
  final String message;

  const MeasurementError(this.message, {super.sessionId, super.requestId});

  @override
  List<Object?> get props => [message, sessionId, requestId];
}

class MeasurementDataState extends MeasurementState {
  final String? referenceMeasurement;
  final String? currentMeasurement;

  const MeasurementDataState({
    required super.sessionId,
    required super.requestId,
    this.referenceMeasurement,
    this.currentMeasurement,
  });

  MeasurementDataState copyWith({
    String? referenceMeasurement,
    String? currentMeasurement,
    int? sessionId,
    int? requestId,
  }) {
    return MeasurementDataState(
      referenceMeasurement: referenceMeasurement ?? this.referenceMeasurement,
      currentMeasurement: currentMeasurement ?? this.currentMeasurement,
      sessionId: sessionId ?? this.sessionId,
      requestId: requestId ?? this.requestId,
    );
  }

  @override
  List<Object?> get props => [
    referenceMeasurement,
    currentMeasurement,
    sessionId,
    requestId,
  ];
}

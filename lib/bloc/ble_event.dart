import 'package:equatable/equatable.dart';

abstract class BleEvent extends Equatable {
  const BleEvent();
}

class BleScanAndConnect extends BleEvent {
  @override
  List<Object?> get props => [];
}

class BleSendMeasureCommand extends BleEvent {
  @override
  List<Object?> get props => [];
}

class BleWaitForNextMeasurement extends BleEvent {
  @override
  List<Object?> get props => [];
}

class BleAverageMeasurementRequested extends BleEvent {
  @override
  List<Object?> get props => [];
}

class BleMeasurementSuccessEvent extends BleEvent {
  final String distance;
  const BleMeasurementSuccessEvent(this.distance);

  @override
  List<Object?> get props => [distance];
}

class BleMeasurementTimeoutEvent extends BleEvent {
  @override
  List<Object?> get props => [];
}

class BleDataReceived extends BleEvent {
  final String distance;
  const BleDataReceived(this.distance);

  @override
  List<Object?> get props => [distance];
}

class BleShowLastMeasurement extends BleEvent {
  const BleShowLastMeasurement();
  
  @override
  List<Object?> get props => [];
}
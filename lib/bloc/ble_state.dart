import 'package:equatable/equatable.dart';

abstract class BleState extends Equatable {
  const BleState();
}

class BleInitial extends BleState {
  @override
  List<Object?> get props => [];
}

class BleConnecting extends BleState {
  @override
  List<Object?> get props => [];
}

class BleConnected extends BleState {
  @override
  List<Object?> get props => [];
}

class BleMeasuring extends BleState {
  @override
  List<Object?> get props => [];
}

class BleMeasurementSuccess extends BleState {
  final String distance;

  const BleMeasurementSuccess(this.distance);

  @override
  List<Object?> get props => [distance];
}

class BleError extends BleState {
  final String message;

  const BleError(this.message);

  @override
  List<Object?> get props => [message];
}
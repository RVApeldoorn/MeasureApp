import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/services/ble_service.dart'; 
import 'ble_event.dart';
import 'ble_state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleService _bleService;
  StreamSubscription<List<int>>? _subscription;

  String? _lastDistance;

  BleBloc(this._bleService) : super(BleInitial()) {
    on<BleScanAndConnect>(_onScanAndConnect);
    on<BleSendMeasureCommand>(_onSendMeasure);
    on<BleMeasurementTimeoutEvent>((event, emit) {
      emit(BleError("Meten mislukt: tijdslimiet overschreden"));
    });
    on<BleMeasurementSuccessEvent>(_onMeasurementSuccess);
    on<BleWaitForNextMeasurement>(_onWaitForNextMeasurement);
    on<BleAverageMeasurementRequested>(_onAverageMeasurementRequested);
    on<BleDataReceived>(_onDataReceived);
    on<BleShowLastMeasurement>(_onShowLastMeasurement);
  }

  Future<void> _onScanAndConnect(BleScanAndConnect event, Emitter<BleState> emit) async {
    emit(BleConnecting());

    try {
      await _bleService.scanAndConnect();

      _subscription = _bleService.sensorDataStream?.listen(
  (data) {
    final message = utf8.decode(data);
    add(BleMeasurementSuccessEvent(message));
  },
  onError: (e) {
    print("Fout bij data stream: $e");
    // add(BleError("Fout bij ontvangen van data: $e"));
  },
  onDone: () {
    print("Data stream afgesloten");
    // add(BleError("Verbinding met sensor is verbroken"));
  },
);


      emit(BleConnected());
    } catch (e) {
      emit(BleError("Verbinding mislukt: $e"));
      print("Verbinding mislukt: $e");
    }
  }

  Future<void> _onSendMeasure(BleSendMeasureCommand event, Emitter<BleState> emit) async {
    emit(BleMeasuring());
    _bleService.sendMeasureCommand();
    }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _onWaitForNextMeasurement(
    BleWaitForNextMeasurement event,
    Emitter<BleState> emit,
  ) async {
  emit(BleMeasuring());

  try {
    final data = await _bleService.sensorDataStream!.first.timeout(const Duration(seconds: 5));
    final message = utf8.decode(data);
    emit(BleMeasurementSuccess(message));
  } catch (e) {
    emit(BleError("Meting mislukt: $e"));
  }
}

Future<void> _onAverageMeasurementRequested(
  BleAverageMeasurementRequested event,
  Emitter<BleState> emit,
) async {
  emit(BleMeasuring());

  try {
    final stream = _bleService.sensorDataStream;

    if (stream == null) {
      emit(BleError("Geen verbinding met sensor"));
      return;
    }

    final List<double> distances = [];

    await for (final data in stream) {
      try {
        final message = utf8.decode(data);
        final value = double.tryParse(message.replaceAll(" cm", ""));

        if (value != null) {
          distances.add(value);
        }

        if (distances.length >= 5) break;

      } catch (e) {
        print("❌ Fout bij verwerken data: $e");
        // Bij een fout in deze data item, gewoon verder met volgende
        continue;
      }
    }

    if (distances.isEmpty) {
      emit(BleError("Geen geldige metingen ontvangen"));
      return;
    }

    final avg = distances.reduce((a, b) => a + b) / distances.length;
    emit(BleMeasurementSuccess(avg.toStringAsFixed(1)));

  } catch (e) {
    print("❌ Fout bij data stream: $e");
    emit(BleError("Fout bij ontvangen van data: $e"));
  }
}

void _onDataReceived(BleDataReceived event, Emitter<BleState> emit) {
    // Sla op, maar update de UI niet
    _lastDistance = event.distance;
  }

void _onShowLastMeasurement(BleShowLastMeasurement event, Emitter<BleState> emit) {
    if (_lastDistance != null) {
      emit(BleMeasurementSuccess(_lastDistance!)); // Update UI alleen bij knopdruk
    } else {
      emit(BleError("Nog geen meting ontvangen"));
    }
  }

}

void _onMeasurementSuccess(BleMeasurementSuccessEvent event, Emitter<BleState> emit) {
  emit(BleMeasurementSuccess(event.distance));
}

class BleMeasurementSuccessEvent extends BleEvent {
  final String distance;
  const BleMeasurementSuccessEvent(this.distance);

  @override
  List<Object?> get props => [distance];
}


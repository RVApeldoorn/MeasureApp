import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/services/ble_service.dart'; 
import 'ble_event.dart';
import 'ble_state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleService _bleService;
  StreamSubscription<List<int>>? _subscription;
  String? _lastReferenceMeasurement;


  String? _lastDistance;
  Timer? _timeoutTimer;

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
    on<SaveReferenceMeasurement>(_onSaveReferenceMeasurement);
    on<SaveCurrentMeasurement>(_onSaveCurrentMeasurement);
    on<RequestMeasurement>(_onRequestMeasurement);
  }

  Future<void> _onScanAndConnect(BleScanAndConnect event, Emitter<BleState> emit) async {
    emit(BleConnecting());

    try {
      await _bleService.scanAndConnect();

      print("DEBUG: sensorDataStream na connect: ${_bleService.sensorDataStream}");

      _subscription = _bleService.sensorDataStream?.listen(
        (data) {
          final message = utf8.decode(data);
          print("DEBUG: Data ontvangen van sensor: $message");

          // Bij ontvangen data cancel timeout
          _timeoutTimer?.cancel();

          add(BleMeasurementSuccessEvent(message));
        },
        onError: (e) {
          print("Fout bij data stream: $e");
          // optioneel: add(BleError("Fout bij ontvangen van data: $e"));
        },
        onDone: () {
          print("Data stream afgesloten");
          // optioneel: add(BleError("Verbinding met sensor is verbroken"));
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

    // Start timeout timer (bijv. 5 sec)
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      add(BleMeasurementTimeoutEvent());
    });

    await _bleService.sendMeasureCommand();
  }

  Future<void> _onRequestMeasurement(RequestMeasurement event, Emitter<BleState> emit) async {
    // Dit event kan hetzelfde zijn als sendMeasure, of extra logica bevatten
    emit(BleMeasuring());

    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      add(BleMeasurementTimeoutEvent());
    });

    await _bleService.sendMeasureCommand();
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
      emit(BleMeasurementSuccess(_lastDistance!));
    } else {
      emit(BleError("Nog geen meting ontvangen"));
    }
  }

  void _onSaveReferenceMeasurement(SaveReferenceMeasurement event, Emitter<BleState> emit) {
  _lastReferenceMeasurement = event.measurement;
  if (state is BleMeasurementState) {
    final currentState = state as BleMeasurementState;
    emit(currentState.copyWith(referenceMeasurement: event.measurement));
  } else {
    emit(BleMeasurementState(referenceMeasurement: event.measurement));
  }
}

  void _onSaveCurrentMeasurement(SaveCurrentMeasurement event, Emitter<BleState> emit) {
    if (state is BleMeasurementState) {
      final currentState = state as BleMeasurementState;
      emit(currentState.copyWith(currentMeasurement: event.measurement));
    } else {
      emit(BleMeasurementState(currentMeasurement: event.measurement));
    }
  }

 void _onMeasurementSuccess(BleMeasurementSuccessEvent event, Emitter<BleState> emit) {
  print("Measurement success met waarde: ${event.distance}");

  if (state is BleMeasurementState) {
    final currentState = state as BleMeasurementState;
    emit(currentState.copyWith(currentMeasurement: event.distance));
  } else {
    emit(BleMeasurementState(
      referenceMeasurement: _lastReferenceMeasurement,
      currentMeasurement: event.distance,
    ));
  }
}



  @override
  Future<void> close() {
    _subscription?.cancel();
    _timeoutTimer?.cancel();
    return super.close();
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/services/measurement_service.dart';
import 'package:measureapp/bloc/measurement_event.dart';
import 'package:measureapp/bloc/measurement_state.dart';

class MeasurementBloc extends Bloc<MeasurementEvent, MeasurementState> {
  final MeasurementService _measurementService;
  StreamSubscription<List<int>>? _subscription;
  String? _lastReferenceMeasurement;
  String? _lastDistance;
  Timer? _timeoutTimer;
  int? _lastSessionId;
  int? _lastRequestId;

  MeasurementBloc(this._measurementService)
    : super(const MeasurementInitial()) {
    on<MeasurementScanAndConnect>(_onScanAndConnect);
    on<MeasurementSendMeasureCommand>(_onSendMeasure);
    on<MeasurementTimeoutEvent>(_onTimeout);
    on<MeasurementSuccessEvent>(_onMeasurementSuccess);
    on<MeasurementWaitForNext>(_onWaitForNextMeasurement);
    on<MeasurementAverageRequested>(_onAverageMeasurementRequested);
    on<MeasurementDataReceived>(_onDataReceived);
    on<MeasurementShowLast>(_onShowLastMeasurement);
    on<SaveReferenceMeasurement>(_onSaveReferenceMeasurement);
    on<SaveCurrentMeasurement>(_onSaveCurrentMeasurement);
    on<RequestMeasurement>(_onRequestMeasurement);
    on<StartMeasurement>(_onStartMeasurement);
    on<CancelMeasurement>(_onCancelMeasurement);
  }

  Future<void> _onStartMeasurement(
    StartMeasurement event,
    Emitter<MeasurementState> emit,
  ) async {
    _lastSessionId = event.sessionId;
    _lastRequestId = event.requestId;
    emit(
      MeasurementDataState(
        sessionId: event.sessionId,
        requestId: event.requestId,
        referenceMeasurement: null,
        currentMeasurement: null,
      ),
    );
    add(MeasurementScanAndConnect());
  }

  Future<void> _onScanAndConnect(
    MeasurementScanAndConnect event,
    Emitter<MeasurementState> emit,
  ) async {
    emit(
      MeasurementConnecting(
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
    try {
      await _measurementService.scanAndConnect();
      _subscription?.cancel();
      _subscription = _measurementService.sensorDataStream?.listen(
        (data) {
          final message = utf8.decode(data).trim();
          _timeoutTimer?.cancel();
          add(MeasurementSuccessEvent(message));
        },
        onError: (e) {
          emit(
            MeasurementError(
              "Fout bij ontvangen van data: $e",
              sessionId: _lastSessionId,
              requestId: _lastRequestId,
            ),
          );
        },
        onDone: () {
          emit(
            MeasurementError(
              "Verbinding met sensor is verbroken",
              sessionId: _lastSessionId,
              requestId: _lastRequestId,
            ),
          );
        },
      );

      emit(
        MeasurementConnected(
          sessionId: _lastSessionId,
          requestId: _lastRequestId,
        ),
      );
    } catch (e) {
      emit(
        MeasurementError(
          "Verbinding mislukt: $e",
          sessionId: _lastSessionId,
          requestId: _lastRequestId,
        ),
      );
    }
  }

  Future<void> _onSendMeasure(
    MeasurementSendMeasureCommand event,
    Emitter<MeasurementState> emit,
  ) async {
    emit(
      MeasurementMeasuring(
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      add(MeasurementTimeoutEvent());
    });
    await _measurementService.sendMeasureCommand();
  }

  Future<void> _onRequestMeasurement(
    RequestMeasurement event,
    Emitter<MeasurementState> emit,
  ) async {
    emit(
      MeasurementMeasuring(
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      add(MeasurementTimeoutEvent());
    });
    await _measurementService.sendMeasureCommand();
  }

  Future<void> _onWaitForNextMeasurement(
    MeasurementWaitForNext event,
    Emitter<MeasurementState> emit,
  ) async {
    emit(
      MeasurementMeasuring(
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
    try {
      final data = await _measurementService.sensorDataStream!.first.timeout(
        const Duration(seconds: 5),
      );
      final message = utf8.decode(data).trim();
      emit(
        MeasurementDataState(
          currentMeasurement: message,
          referenceMeasurement: _lastReferenceMeasurement,
          sessionId: _lastSessionId,
          requestId: _lastRequestId,
        ),
      );
    } catch (e) {
      emit(
        MeasurementError(
          "Meting mislukt: $e",
          sessionId: _lastSessionId,
          requestId: _lastRequestId,
        ),
      );
    }
  }

  Future<void> _onAverageMeasurementRequested(
    MeasurementAverageRequested event,
    Emitter<MeasurementState> emit,
  ) async {
    emit(
      MeasurementMeasuring(
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
    try {
      final stream = _measurementService.sensorDataStream;
      if (stream == null) {
        emit(
          MeasurementError(
            "Geen verbinding met sensor",
            sessionId: _lastSessionId,
            requestId: _lastRequestId,
          ),
        );
        return;
      }

      final List<double> distances = [];
      await for (final data in stream) {
        try {
          final message = utf8.decode(data).trim();
          final value = double.tryParse(message.replaceAll(" cm", ""));
          if (value != null) {
            distances.add(value);
          }
          if (distances.length >= 5) break;
        } catch (e) {
          continue;
        }
      }

      if (distances.isEmpty) {
        emit(
          MeasurementError(
            "Geen geldige metingen ontvangen",
            sessionId: _lastSessionId,
            requestId: _lastRequestId,
          ),
        );
        return;
      }

      final avg = distances.reduce((a, b) => a + b) / distances.length;
      emit(
        MeasurementDataState(
          currentMeasurement: avg.toStringAsFixed(1),
          referenceMeasurement: _lastReferenceMeasurement,
          sessionId: _lastSessionId,
          requestId: _lastRequestId,
        ),
      );
    } catch (e) {
      emit(
        MeasurementError(
          "Fout bij ontvangen van data: $e",
          sessionId: _lastSessionId,
          requestId: _lastRequestId,
        ),
      );
    }
  }

  void _onDataReceived(
    MeasurementDataReceived event,
    Emitter<MeasurementState> emit,
  ) {
    _lastDistance = event.distance;
    emit(
      MeasurementDataState(
        currentMeasurement: event.distance,
        referenceMeasurement: _lastReferenceMeasurement,
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
  }

  void _onShowLastMeasurement(
    MeasurementShowLast event,
    Emitter<MeasurementState> emit,
  ) {
    if (_lastDistance != null) {
      emit(
        MeasurementDataState(
          currentMeasurement: _lastDistance,
          referenceMeasurement: _lastReferenceMeasurement,
          sessionId: _lastSessionId,
          requestId: _lastRequestId,
        ),
      );
    } else {
      emit(
        MeasurementError(
          "Nog geen meting ontvangen",
          sessionId: _lastSessionId,
          requestId: _lastRequestId,
        ),
      );
    }
  }

  void _onSaveReferenceMeasurement(
    SaveReferenceMeasurement event,
    Emitter<MeasurementState> emit,
  ) {
    _lastReferenceMeasurement = event.measurement;
    emit(
      MeasurementDataState(
        referenceMeasurement: event.measurement,
        currentMeasurement: _lastDistance,
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
  }

  void _onSaveCurrentMeasurement(
    SaveCurrentMeasurement event,
    Emitter<MeasurementState> emit,
  ) {
    emit(
      MeasurementDataState(
        currentMeasurement: event.measurement,
        referenceMeasurement: _lastReferenceMeasurement,
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
  }

  void _onMeasurementSuccess(
    MeasurementSuccessEvent event,
    Emitter<MeasurementState> emit,
  ) {
    emit(
      MeasurementSuccess(
        event.distance,
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
    emit(
      MeasurementDataState(
        currentMeasurement: event.distance,
        referenceMeasurement: _lastReferenceMeasurement,
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
  }

  void _onTimeout(
    MeasurementTimeoutEvent event,
    Emitter<MeasurementState> emit,
  ) {
    emit(
      MeasurementError(
        "Meten mislukt: tijdslimiet overschreden",
        sessionId: _lastSessionId,
        requestId: _lastRequestId,
      ),
    );
  }

  void _onCancelMeasurement(
    CancelMeasurement event,
    Emitter<MeasurementState> emit,
  ) {
    _lastSessionId = null;
    _lastRequestId = null;
    _lastReferenceMeasurement = null;
    _lastDistance = null;
    _subscription?.cancel();
    _timeoutTimer?.cancel();
    _measurementService.disconnect();
    emit(const MeasurementInitial());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _timeoutTimer?.cancel();
    _measurementService.disconnect();
    return super.close();
  }
}

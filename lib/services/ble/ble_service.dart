import 'dart:convert';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import '../measurement_service.dart';

Future<void> requestPermissions() async {
  try {
    final status =
        await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.locationWhenInUse,
        ].request();

    if (status.values.any(
      (perm) => perm.isDenied || perm.isPermanentlyDenied,
    )) {
      if (status[Permission.bluetoothConnect]!.isPermanentlyDenied) {
        await openAppSettings();
      }
      throw Exception("Bluetooth permissions denied: $status");
    }
  } catch (e) {
    rethrow;
  }
}

class BleMeasurementService implements MeasurementService {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  StreamSubscription<List<int>>? _dataSubscription;
  final Uuid serviceUuid = Uuid.parse("12345678-1234-5678-1234-56789abcdef0");
  final Uuid characteristicUuid = Uuid.parse(
    "12345678-1234-5678-1234-56789abcdef1",
  );
  final Uuid commandCharacteristicUuid = Uuid.parse(
    "12345678-1234-5678-1234-56789abcdef2",
  );

  DiscoveredDevice? _device;
  StreamController<List<int>>? _streamController;
  Stream<List<int>>? _sensorDataStream;

  @override
  Stream<List<int>>? get sensorDataStream => _sensorDataStream;

  @override
  Future<void> scanAndConnect() async {
    try {
      await requestPermissions();

      final scanStream = _ble.scanForDevices(withServices: [serviceUuid]);
      await for (final device in scanStream.timeout(
        const Duration(seconds: 10),
        onTimeout: (sink) => sink.close(),
      )) {
        if (device.name == "ESP32-C6 Ultrasoon") {
          _device = device;
          break;
        }
      }

      if (_device == null) {
        throw Exception("ESP32-C6 Ultrasoon not found");
      }

      final completer = Completer<void>();
      _connectionSubscription = _ble
          .connectToDevice(id: _device!.id)
          .listen(
            (update) {
              if (update.connectionState == DeviceConnectionState.connected) {
                completer.complete();
              } else if (update.connectionState ==
                  DeviceConnectionState.disconnected) {
                if (!completer.isCompleted) {
                  completer.completeError(
                    "Disconnected before connection established",
                  );
                }
              }
            },
            onError: (e) {
              if (!completer.isCompleted) {
                completer.completeError(e);
              }
            },
          );

      await completer.future;

      final characteristic = QualifiedCharacteristic(
        serviceId: serviceUuid,
        characteristicId: characteristicUuid,
        deviceId: _device!.id,
      );

      _streamController = StreamController<List<int>>();
      _sensorDataStream = _streamController!.stream;
      _dataSubscription = _ble
          .subscribeToCharacteristic(characteristic)
          .listen(
            (data) {
              _streamController!.add(data);
            },
            onError: (e) {
              _streamController!.addError(e);
            },
            onDone: () {
              _streamController!.close();
            },
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendMeasureCommand() async {
    if (_device == null) {
      throw Exception("No device connected");
    }

    final commandCharacteristic = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: commandCharacteristicUuid,
      deviceId: _device!.id,
    );

    try {
      await _ble.writeCharacteristicWithResponse(
        commandCharacteristic,
        value: utf8.encode("start"),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    await _dataSubscription?.cancel();
    await _connectionSubscription?.cancel();
    _streamController?.close();
    _device = null;
    _sensorDataStream = null;
  }
}

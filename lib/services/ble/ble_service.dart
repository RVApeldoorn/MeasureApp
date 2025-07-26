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

    print("Permission status: $status");
    if (status.values.any(
      (perm) => perm.isDenied || perm.isPermanentlyDenied,
    )) {
      if (status[Permission.bluetoothConnect]!.isPermanentlyDenied) {
        print("BLUETOOTH_CONNECT permanently denied. Opening settings.");
        await openAppSettings();
      }
      throw Exception("Bluetooth permissions denied: $status");
    }
    print("All permissions granted");
  } catch (e) {
    print("Error requesting permissions: $e");
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

      // Scan for XiaoESP32
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
      print("Found device: ${_device!.name} (${_device!.id})");

      // Connect to device
      final completer = Completer<void>();
      _connectionSubscription = _ble
          .connectToDevice(id: _device!.id)
          .listen(
            (update) {
              print("Connection state: ${update.connectionState}");
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
              print("Connection error: $e");
              if (!completer.isCompleted) {
                completer.completeError(e);
              }
            },
          );

      await completer.future;

      // Subscribe to characteristic
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
              print("Data received: ${utf8.decode(data)}");
              _streamController!.add(data);
            },
            onError: (e) {
              print("Data stream error: $e");
              _streamController!.addError(e);
            },
            onDone: () {
              print("Data stream closed");
              _streamController!.close();
            },
          );

      print("Connected and subscribed to ${_device!.name}");
    } catch (e) {
      print("Scan and connect failed: $e");
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
      print("Sent start command");
    } catch (e) {
      print("Error sending start command: $e");
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _dataSubscription?.cancel();
      await _connectionSubscription?.cancel();
      _streamController?.close();
      _device = null;
      _sensorDataStream = null;
      print("Disconnected from device");
    } catch (e) {
      print("Error disconnecting: $e");
    }
  }
}

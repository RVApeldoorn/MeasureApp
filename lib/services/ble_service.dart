import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';


Future<void> requestPermissions() async {
  final status = await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.locationWhenInUse,
  ].request();

  if (status.values.any((perm) => perm.isDenied)) {
    throw Exception("Bluetooth permissions denied");
  }
}

class BleService {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;

  final Uuid serviceUuid = Uuid.parse("12345678-1234-5678-1234-56789abcdef0");
  final Uuid characteristicUuid = Uuid.parse("12345678-1234-5678-1234-56789abcdef1");
  final Uuid commandCharacteristicUuid = Uuid.parse("12345678-1234-5678-1234-56789abcdef2");

  DiscoveredDevice? _device;
  Stream<List<int>>? _sensorDataStream;

  Stream<List<int>>? get sensorDataStream => _sensorDataStream;

  Future<void> scanAndConnect() async {
  await requestPermissions();

  // Stap 1: Scan naar je ESP32
  final scanStream = _ble.scanForDevices(withServices: [serviceUuid]);
  await for (final device in scanStream.timeout(
    const Duration(seconds: 5),
    onTimeout: (sink) => sink.close(),
  )) {
    if (device.name == "ESP32-C6 Ultrasoon") {
      _device = device;
      break;
    }
  }

  if (_device == null) {
    throw Exception("ESP32 niet gevonden");
  }

  // Stap 2: Verbinden en wachten tot volledig verbonden
  final completer = Completer<void>();
  _connectionSubscription = _ble.connectToDevice(id: _device!.id).listen(
    (update) {
      print("Verbindingstatus: ${update.connectionState}");
      if (update.connectionState == DeviceConnectionState.connected) {
        print("Verbonden!");
        completer.complete(); // Ga pas door wanneer volledig verbonden
      } else if (update.connectionState == DeviceConnectionState.disconnected) {
        print("Verbinding verbroken");
        if (!completer.isCompleted) {
          completer.completeError("Verbinding verbroken vóór succesvol verbinden");
        }
      }
    },
    onError: (e) {
      print("Verbindingsfout: $e");
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    },
  );

  await completer.future; // Wacht tot verbinding compleet is

  // Stap 3: Pas nu subscriben op de characteristic
  final characteristic = QualifiedCharacteristic(
    serviceId: serviceUuid,
    characteristicId: characteristicUuid,
    deviceId: _device!.id,
  );

  _sensorDataStream = _ble.subscribeToCharacteristic(characteristic);
  
}


  Future<void> sendMeasureCommand() async {
  if (_device == null) return;

  final commandCharacteristic = QualifiedCharacteristic(
    serviceId: serviceUuid,
    characteristicId: commandCharacteristicUuid,
    deviceId: _device!.id,
  );

  try {
    // Check wat je ESP32 precies verwacht: string of bytes
    await _ble.writeCharacteristicWithResponse(
      commandCharacteristic,
      value: "start".codeUnits, // Of bijvoorbeeld: [0x01]
    );
  } catch (e) {
    print("Fout bij verzenden startcommando: $e");
    rethrow;
  }
}


}

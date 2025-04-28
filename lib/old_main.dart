import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';  

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BLEScanner(),
    );
  }
}

class BLEScanner extends StatefulWidget {
  const BLEScanner({super.key});

  @override
  _BLEScannerState createState() => _BLEScannerState();
}

class _BLEScannerState extends State<BLEScanner> {
  final flutterReactiveBle = FlutterReactiveBle();
  final String serviceUuid = "12345678-1234-5678-1234-56789abcdef0";
  final String characteristicUuid = "12345678-1234-5678-1234-56789abcdef1";

  DiscoveredDevice? esp32Device;
  bool isConnected = false;
  String distance = "Geen data";

  Future<void> requestPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }

    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }

    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
  }

  void startScan() async {
    await requestPermissions();

    setState(() => esp32Device = null);

    flutterReactiveBle.scanForDevices(withServices: [Uuid.parse(serviceUuid)]).listen((device) {
      if (device.name == "ESP32-C6 Ultrasoon") {
        setState(() => esp32Device = device);
      }
    });
  }

  void connectToDevice() {
    if (esp32Device == null) return;

    final device = esp32Device!;
    flutterReactiveBle.connectToDevice(id: device.id).listen((connectionState) {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        setState(() => isConnected = true);
        readSensorData(device.id);
      } else {
        setState(() => isConnected = false);
      }
    });
  }

  void readSensorData(String deviceId) {
    flutterReactiveBle.subscribeToCharacteristic(
      QualifiedCharacteristic(
        serviceId: Uuid.parse(serviceUuid),
        characteristicId: Uuid.parse(characteristicUuid),
        deviceId: deviceId,
      ),
    ).listen((data) {
      setState(() => distance = String.fromCharCodes(data));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ESP32 BLE Scanner")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Afstand: $distance", style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startScan,
              child: const Text("Scan naar ESP32"),
            ),
            if (esp32Device != null) ...[
              Text("Gevonden: ${esp32Device!.name}"),
              ElevatedButton(
                onPressed: connectToDevice,
                child: Text(isConnected ? "Verbonden" : "Verbinden"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:usb_serial/usb_serial.dart';
import 'dart:async';
import 'dart:convert';
import '../measurement_service.dart';

class SerialMeasurementService implements MeasurementService {
  UsbPort? _port;
  StreamController<List<int>>? _streamController;
  Stream<List<int>>? _sensorDataStream;

  @override
  Stream<List<int>>? get sensorDataStream => _sensorDataStream;

  @override
  Future<void> scanAndConnect() async {
    try {
      final devices = await UsbSerial.listDevices();

      UsbDevice? targetDevice;
      for (var device in devices) {
        if (device.vid == 0x2341 && device.pid == 0x0042) {
          targetDevice = device;
          break;
        }
      }

      if (targetDevice == null && devices.isNotEmpty) {
        targetDevice = devices.first;
      }

      if (targetDevice == null) {
        throw Exception(
          "No USB serial devices found. Ensure Arduino is connected via USB.",
        );
      }

      _port = await targetDevice.create();
      if (_port == null) {
        throw Exception("Failed to create USB port");
      }

      bool opened = await _port!.open();
      if (!opened) {
        throw Exception(
          "Failed to open serial port for device: ${targetDevice.deviceName}",
        );
      }

      await _port!.setPortParameters(9600, 8, 1, UsbPort.PARITY_NONE);

      _streamController = StreamController<List<int>>();
      _sensorDataStream = _streamController!.stream;

      final inputStream = _port!.inputStream;
      if (inputStream == null) {
        throw Exception(
          "Input stream is null for device: ${targetDevice.deviceName}",
        );
      }

      inputStream.listen(
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
      await disconnect();
      rethrow;
    }
  }

  @override
  Future<void> sendMeasureCommand() async {
    if (_port == null) {
      throw Exception("Not connected to Arduino");
    }
    try {
      await _port!.write(utf8.encode("start\n"));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    await _port?.close();
    await _streamController?.close();
    _port = null;
    _streamController = null;
    _sensorDataStream = null;
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> savePin(String pin) async {
    final hashedPin = _hashPin(pin);
    await _storage.write(key: 'pin_code', value: hashedPin);
  }

  static Future<String?> getPin() async {
    return await _storage.read(key: 'pin_code');
  }

  static Future<void> clearStorage() async {
    await _storage.deleteAll();
  }

  static String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

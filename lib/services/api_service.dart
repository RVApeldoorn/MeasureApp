import 'package:dio/dio.dart';
import 'package:measureapp/utils/secure_storage.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchSessions() async {
    try {
      String? token = await SecureStorage.getToken();

      if (token == null) {
        throw Exception('No token found');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.get(
        'http://localhost:5005/api/patient/sessions',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'Failed to load sessions: Status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching sessions: $e');
    }
  }

  Future<void> submitMeasurement({
    required int sessionId,
    required int measurementRequestId,
    required String value,
    String? note,
  }) async {
    try {
      String? token = await SecureStorage.getToken();

      if (token == null) {
        throw Exception('No token found');
      }

      final parsedValue = double.tryParse(
        value.replaceAll(RegExp(r'[^0-9.]'), ''),
      );
      if (parsedValue == null) {
        throw Exception('Invalid measurement value: $value');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';
      _dio.options.headers['Content-Type'] = 'application/json';

      final data = {
        "sessionId": sessionId,
        "values": [
          {
            "measurementRequestId": measurementRequestId,
            "value": parsedValue,
            "note": note ?? ''
          }
        ]
      };

      final response = await _dio.post(
        'http://localhost:5005/api/patient/submit',
        data: data,
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception(
          'Failed to submit measurement: Status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Submit error: $e');
    }
  }
}
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

      final response = await _dio.get('http://localhost:5005/api/patient/sessions');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
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

      _dio.options.headers['Authorization'] = 'Bearer $token';
      _dio.options.headers['Content-Type'] = 'application/json';

      final data = {
        "sessionId": sessionId,
        "values": [
          {
            "measurementRequestId": measurementRequestId,
            "value": value,
            "note": note ?? ''
          }
        ]
      };

      await _dio.post('http://localjoost:5005/api/patient/submit', data: data);
    } catch (e) {
      throw Exception('Submit error: $e');
    }
  }
}
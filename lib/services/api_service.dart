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
}
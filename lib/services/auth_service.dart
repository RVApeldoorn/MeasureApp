import 'package:measureapp/utils/secure_storage.dart';
import 'package:dio/dio.dart';

class AuthService {
  static Future<bool> authenticateWithSetupCode(String setupCode) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        'http://x.x.x.x:5005/api/auth/setup',
        data: {'setupCode': setupCode},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print('Token: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        if (token != null) {
          await SecureStorage.saveToken(token);
          return true;
        }
      }
      
      return false;
    } catch (e) {
      print('Error making request: $e');
      return false;
    }
  }
}


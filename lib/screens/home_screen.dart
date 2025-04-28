import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:measureapp/utils/secure_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Dio dio;
  String _sessionsData = 'Loading...';

  @override
  void initState() {
    super.initState();
    dio = Dio();
    _fetchSessionsData();
  }

  Future<void> _fetchSessionsData() async {
    try {
      String? token = await SecureStorage.getToken();

      if (token == null) {
        setState(() {
          _sessionsData = 'No token found';
        });
        return;
      }

      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get('http://x.x.x.x:5005/api/patient/sessions');

      if (response.statusCode == 200) {
        setState(() {
          _sessionsData = response.data.toString();
        });
      } else {
        setState(() {
          _sessionsData = 'Failed to load data';
        });
      }
    } catch (e) {
      setState(() {
        _sessionsData = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            _sessionsData,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:measureapp/screens/home_screen.dart';
import 'package:measureapp/screens/setup_screen.dart';
import 'package:measureapp/utils/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await SecureStorage.getToken();

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  MyApp({this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measure App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: token != null ? HomeScreen() : SetupScreen(),
    );
  }
}

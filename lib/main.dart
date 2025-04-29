import 'package:flutter/material.dart';
import 'package:measureapp/screens/home_screen.dart';
import 'package:measureapp/screens/setup_screen.dart';
import 'package:measureapp/screens/pin_screen.dart';
import 'package:measureapp/screens/pin_lock_screen.dart';
import 'package:measureapp/utils/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await SecureStorage.getToken();
  String? pin = await SecureStorage.getPin();

  runApp(MyApp(token: token, pin: pin));
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? pin;

  const MyApp({super.key, this.token, this.pin});

  @override
  Widget build(BuildContext context) {
    Widget startScreen;

    if (token == null) {
      startScreen = const SetupScreen(); 
    } else if (pin == null) {
      startScreen = const PinScreen(); 
    } else {
      startScreen = PinLockScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Measure App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: startScreen, 
    );
  }
}

import 'package:flutter/material.dart';
import 'package:measureapp/utils/secure_storage.dart';
import 'package:measureapp/screens/home_screen.dart';
import 'package:measureapp/screens/setup_screen.dart';
import 'package:measureapp/widgets/numpad_widget.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final _pinController = TextEditingController();

  void _onNumberPress(String number) {
    if (_pinController.text.length < 4) {
      setState(() {
        _pinController.text += number;
        if (_pinController.text.length == 4) {
          _verifyPin();
        }
      });
    }
  }

  void _onDeletePress() {
    if (_pinController.text.isNotEmpty) {
      setState(() {
        _pinController.text =
            _pinController.text.substring(0, _pinController.text.length - 1);
      });
    }
  }

  void _verifyPin() async {
    final enteredPin = SecureStorage.hashPin(_pinController.text.trim());
    final savedPin = await SecureStorage.getPin();

    if (enteredPin == savedPin) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ongeldige PIN')),
      );
      setState(() {
        _pinController.clear();
      });
    }
  }

  void _onForgotPin() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bevestiging'),
          content: const Text(
              'Weet je zeker dat je je PIN wilt resetten? De app zal opnieuw worden ingesteld.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuleren'),
            ),
            TextButton(
              onPressed: () async {
                await SecureStorage.clearStorage();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SetupScreen()),
                );
              },
              child: const Text('Bevestigen'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: index < _pinController.text.length
                ? const Color(0xFF1D53BF)
                : const Color(0xFFE6ECF6),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text(
              'Meting',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Voer uw pincode in',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 32),
            _buildPinDots(),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _onForgotPin,
              child: const Text(
                'Pincode vergeten',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                  color: Color(0xFF1D53BF),
                ),
              ),
            ),
            const Spacer(),
            NumpadWidget(
              onNumberPress: _onNumberPress,
              onDeletePress: _onDeletePress,
            ),
          ],
        ),
      ),
    );
  }
}

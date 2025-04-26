import 'package:flutter/material.dart';
import 'package:measureapp/services/auth_service.dart';
import 'package:measureapp/screens/pin_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _setupCodeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _submitSetupCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await AuthService.authenticateWithSetupCode(_setupCodeController.text);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PinScreen()),
      );
    } else {
      setState(() {
        _errorMessage = "Invalid setup code!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Setup Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _setupCodeController,
              decoration: const InputDecoration(
                labelText: 'Setup Code',
              ),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
            ],
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitSetupCode,
                    child: const Text('Authenticate'),
                  ),
          ],
        ),
      ),
    );
  }
}

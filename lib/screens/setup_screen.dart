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
        _errorMessage = "Ongeldig setup code!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Metingen',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D53BF),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Voer uw setup code in',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _setupCodeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Setup Code',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Uw setup code is verkrijgbaar bij uw zorgverlener.\nNeem contact op met test@test.nl bij vragen.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(height: 16),
              ],
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.blueAccent)
                  : ElevatedButton(
                      onPressed: _submitSetupCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1D53BF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Verifiëren',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:measureapp/services/auth_service.dart';
import 'package:measureapp/screens/pin_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        _errorMessage = AppLocalizations.of(context)!.invalid_setup_code;
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
              Text(
                AppLocalizations.of(context)!.app_title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D53BF),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.enter_setup_code,
                style: const TextStyle(
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
                  hintText: AppLocalizations.of(context)!.setup_code,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.setup_code_instructions,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                        backgroundColor: const Color(0xFF1D53BF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.verify,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

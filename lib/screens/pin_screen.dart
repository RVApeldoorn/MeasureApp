import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/utils/secure_storage.dart';
import 'package:measureapp/screens/pin_lock_screen.dart';
import 'package:measureapp/widgets/numpad_widget.dart';
import 'package:measureapp/widgets/pin_dots_widget.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _showConfirmField = false;

  void _onNumberPress(String number) {
    if (_pinController.text.length < 4 && !_showConfirmField) {
      setState(() {
        _pinController.text += number;
        if (_pinController.text.length == 4 && !_showConfirmField) {
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              setState(() {
                _showConfirmField = true;
              });
            }
          });
        }
      });
    } else if (_confirmPinController.text.length < 4 && _showConfirmField) {
      setState(() {
        _confirmPinController.text += number;
        if (_confirmPinController.text.length == 4) {
          _onNextOrSave();
        }
      });
    }
  }

  void _onDeletePress() {
    if (_showConfirmField && _confirmPinController.text.isNotEmpty) {
      setState(() {
        _confirmPinController.text = _confirmPinController.text.substring(
          0,
          _confirmPinController.text.length - 1,
        );
      });
    } else if (!_showConfirmField && _pinController.text.isNotEmpty) {
      setState(() {
        _pinController.text =
            _pinController.text.substring(0, _pinController.text.length - 1);
      });
    }
  }

  void _onNextOrSave() async {
    if (_showConfirmField && _confirmPinController.text.length == 4) {
      if (_pinController.text == _confirmPinController.text) {
        await SecureStorage.savePin(_pinController.text);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PinLockScreen()),
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 200));
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.pin_error)),
        );
        setState(() {
          _pinController.clear();
          _confirmPinController.clear();
          _showConfirmField = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              loc.app_title,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _showConfirmField ? loc.pin_confirm : loc.pin_set,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF2B59BA),
              ),
            ),
            const SizedBox(height: 32),
            PinDotsWidget(
              pinLength:
                  _showConfirmField ? _confirmPinController.text.length : _pinController.text.length,
              dotSize: 60,
              spacing: 12,
              borderRadius: 5,
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
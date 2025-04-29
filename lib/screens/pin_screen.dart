import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:measureapp/utils/secure_storage.dart';
import 'package:measureapp/screens/pin_lock_screen.dart';
import 'package:measureapp/widgets/numpad_widget.dart';

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
        _confirmPinController.text = _confirmPinController.text
            .substring(0, _confirmPinController.text.length - 1);
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
          const SnackBar(content: Text('PIN-codes komen niet overeen')),
        );
        setState(() {
          _pinController.clear();
          _confirmPinController.clear();
          _showConfirmField = false;
        });
      }
    }
  }

  Widget _buildPinDots(String pin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: index < pin.length
                ? const Color(0xFF1D53BF)
                : const Color(0xFFE6ECF6),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
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
            Text(
              _showConfirmField ? 'Bevestig uw PIN-code' : 'Stel uw PIN-code in',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height:32),
            _buildPinDots(_showConfirmField ? _confirmPinController.text : _pinController.text),
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
import 'package:flutter/material.dart';

class MeasurementRequest extends StatelessWidget {
  final String title;
  final bool isFilled;
  final VoidCallback? onPressed;

  const MeasurementRequest({
    Key? key,
    required this.title,
    required this.isFilled,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isFilled ? Colors.green[100] : Colors.white,
          foregroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Icon(
                isFilled ? Icons.check : Icons.add,
                color: const Color(0xFF1D53BF),
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
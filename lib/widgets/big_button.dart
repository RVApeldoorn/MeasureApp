import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget iconWidget;
  final VoidCallback onPressed;

  const BigButton({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconWidget,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Color(0xFFE7EDF9),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D53BF),
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ),
              Center(
                child: SizedBox(
                  width: 100,
                  height: 160,
                  child: iconWidget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
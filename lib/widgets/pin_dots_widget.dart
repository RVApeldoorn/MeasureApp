import 'package:flutter/material.dart';

class PinDotsWidget extends StatelessWidget {
  final int pinLength;
  final double dotSize;
  final double spacing;
  final Color activeColor;
  final Color inactiveColor;
  final double borderRadius;

  const PinDotsWidget({
    super.key,
    required this.pinLength,
    this.dotSize = 50,
    this.spacing = 12,
    this.activeColor = const Color(0xFF1D53BF),
    this.inactiveColor = const Color(0xFFE6ECF6),
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: index < pinLength ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      }),
    );
  }
}
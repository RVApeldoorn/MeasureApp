import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/step_two_measurement_screen.dart';
import 'package:measureapp/widgets/measurement_step_screen.dart';

class IntroStepOneScreen extends StatelessWidget {
  final int sessionId;
  final int requestId;

  const IntroStepOneScreen({required this.sessionId, required this.requestId});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MeasurementStepScreen(
      title: l10n.measurement,
      imagePath: 'assets/images/dick_schoof.jpg',
      stepTitle: l10n.heightMeasurement,
      description: l10n.blablabla,
      stepIndex: 0,
      totalSteps: 4,
      onNext: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => IntroStepTwoScreen()),
      ),
    );
  }
}
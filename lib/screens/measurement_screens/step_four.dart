import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/measurement_screens/step_five.dart';
import 'package:measureapp/widgets/measurement_step_screen.dart';

class StepFour extends StatelessWidget {
  final int sessionId;
  final int requestId;

  const StepFour({required this.sessionId, required this.requestId});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MeasurementStepScreen(
      title: l10n.measurement,
      imagePath: 'assets/images/instructions/step4.jpg',
      stepTitle: l10n.heightMeasurement,
      description: l10n.step4,
      stepIndex: 3,
      totalSteps: 5,
      onNext: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StepFive(sessionId: sessionId, requestId: requestId)),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/home_screen.dart';
import 'package:measureapp/widgets/measurement_step_screen.dart';

class StepFive extends StatelessWidget {
  final int sessionId;
  final int requestId;

  const StepFive({required this.sessionId, required this.requestId});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MeasurementStepScreen(
      title: l10n.measurement,
      imagePath: 'assets/images/instructions/step5.jpg',
      stepTitle: l10n.heightMeasurement,
      description: l10n.step4,
      stepIndex: 4,
      totalSteps: 5,
      onNext: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      ),
    );
  }
}
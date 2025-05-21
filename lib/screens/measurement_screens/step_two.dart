import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/measurement_screens/step_three.dart';
import 'package:measureapp/widgets/generic_step_screen.dart';

class StepTwo extends StatelessWidget {
  final int sessionId;
  final int requestId;

  const StepTwo({required this.sessionId, required this.requestId});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GenericStepScreen(
      title: l10n.measurement,
      imagePath: 'assets/images/instructions/step2.jpg',
      stepTitle: l10n.heightMeasurement,
      description: l10n.step2,
      stepIndex: 1,
      totalSteps: 5,
      onNext: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StepThree(sessionId: sessionId, requestId: requestId)),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/home_screen.dart';
import 'package:measureapp/screens/measurement_screens/step_one.dart';
import 'package:measureapp/widgets/generic_step_screen.dart';

class ExerciseTwo extends StatelessWidget {
  final int sessionId;
  final int requestId;

  const ExerciseTwo({required this.sessionId, required this.requestId});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GenericStepScreen(
      title: l10n.measurement,
      imagePath: 'assets/images/relaxingExercise/step2.jpg',
      stepTitle: l10n.heightMeasurement,
      description: l10n.exerciseFollow,
      stepIndex: 1,
      totalSteps: 2,
      onNext: () => Navigator.push(
        context,
        requestId == 0
            ? MaterialPageRoute(builder: (_) => HomeScreen())
            : MaterialPageRoute(builder: (_) => StepOne(sessionId: sessionId, requestId: requestId)),
      ),
    );
  }
}
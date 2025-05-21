import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/relaxing_exercise/exercise_two.dart';
import 'package:measureapp/widgets/generic_step_screen.dart';

class ExerciseOne extends StatelessWidget {
  final int sessionId;
  final int requestId;

  const ExerciseOne({required this.sessionId, required this.requestId});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GenericStepScreen(
      title: l10n.measurement,
      imagePath: 'assets/images/relaxingExercise/step1.jpg',
      stepTitle: l10n.heightMeasurement,
      description: l10n.exerciseFollow,
      stepIndex: 0,
      totalSteps: 2,
      onNext: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ExerciseTwo(sessionId: sessionId, requestId: requestId)),
      ),
    );
  }
}
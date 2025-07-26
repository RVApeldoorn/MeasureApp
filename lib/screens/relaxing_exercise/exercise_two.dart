import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/bloc/measurement_bloc.dart';
import 'package:measureapp/bloc/measurement_state.dart';
import 'package:measureapp/screens/home_screen.dart';
import 'package:measureapp/screens/measurement_screens/step_one.dart';
import 'package:measureapp/widgets/generic_step_screen.dart';

class ExerciseTwo extends StatelessWidget {
  const ExerciseTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<MeasurementBloc, MeasurementState>(
      builder: (context, state) {
        final sessionId = state.sessionId;
        final requestId = state.requestId;
        print(
          "DEBUG: ExerciseTwo accessed state - sessionId: $sessionId, requestId: $requestId, state: $state",
        );

        return GenericStepScreen(
          title: l10n.measurement,
          imagePath: 'assets/images/relaxingExercise/step2.jpg',
          stepTitle: l10n.relaxing_exercises,
          description: l10n.exerciseFollow,
          stepIndex: 1,
          totalSteps: 2,
          onNext:
              () => Navigator.push(
                context,
                sessionId == null || requestId == null
                    ? MaterialPageRoute(builder: (_) => const HomeScreen())
                    : MaterialPageRoute(builder: (_) => StepOne()),
              ),
          onSkip:
              () => Navigator.push(
                context,
                sessionId == null || requestId == null
                    ? MaterialPageRoute(builder: (_) => const HomeScreen())
                    : MaterialPageRoute(builder: (_) => StepOne()),
              ),
        );
      },
    );
  }
}
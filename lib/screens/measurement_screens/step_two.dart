import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/measurement_screens/step_three.dart';
import 'package:measureapp/widgets/generic_step_screen.dart';

class StepTwo extends StatelessWidget {
  const StepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GenericStepScreen(
      title: l10n.measurement,
      imagePath: 'assets/images/instructions/step2.jpg',
      stepTitle: l10n.posture_instructions,
      description: l10n.postureStep2,
      stepIndex: 1,
      totalSteps: 3,
      onNext: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StepThree()),
      ),
    );
  }
}
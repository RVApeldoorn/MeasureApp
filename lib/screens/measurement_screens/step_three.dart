import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/connect_screen.dart';
import 'package:measureapp/widgets/generic_step_screen.dart';

class StepThree extends StatelessWidget {
  const StepThree({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GenericStepScreen(
      title: l10n.measurement,
      imagePath: 'assets/images/instructions/step3.jpg',
      stepTitle: l10n.posture_instructions,
      description: l10n.postureStep3,
      stepIndex: 2,
      totalSteps: 3,
      onNext: () => Navigator.push(
        context,
            MaterialPageRoute(builder: (_) => const ConnectScreen()),
      ),
    );
  }
}

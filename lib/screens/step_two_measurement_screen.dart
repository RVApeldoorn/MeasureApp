import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/rendering.dart';
import 'package:measureapp/screens/step_three_measurement_screen.dart';
import 'package:measureapp/widgets/measurement_step_screen.dart';

class IntroStepTwoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MeasurementStepScreen(
      title: l10n.measurement,
      imagePath: 'assets/images/leoXIV.jpg',
      stepTitle: l10n.heightMeasurement,
      description: l10n.step2Elephant,
      stepIndex: 1,
      totalSteps: 4,
      onNext: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => IntroStepThreeScreen()),
      ),
    );
  }
}
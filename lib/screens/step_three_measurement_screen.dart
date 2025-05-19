import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:measureapp/screens/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/step_one_measurement_screen.dart';
import 'package:measureapp/widgets/measurement_step_screen.dart';
import 'distance_screen.dart';

class IntroStepThreeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MeasurementStepScreen(
      title: l10n.measurement,
      imagePath: 'assets/images/muis.jpg',
      stepTitle: l10n.heightMeasurement,
      description: l10n.relaxChild,
      stepIndex: 2,
      totalSteps: 4,
      onNext: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DistanceScreen()),
      ),
    );
  }
}

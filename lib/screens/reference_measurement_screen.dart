import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/measurement_bloc.dart';
import 'package:measureapp/bloc/measurement_event.dart';
import 'package:measureapp/bloc/measurement_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/widgets/generic_step_screen.dart';
import 'package:measureapp/screens/distance_screen.dart';
import 'package:measureapp/utils/measurement_utils.dart';

class ReferenceMeasurementScreen extends StatefulWidget {
  const ReferenceMeasurementScreen({super.key});

  @override
  State<ReferenceMeasurementScreen> createState() =>
      _ReferenceMeasurementScreenState();
}

class _ReferenceMeasurementScreenState
    extends State<ReferenceMeasurementScreen> {
  bool measurementDone = false;
  String? measurementValue;

  void _onMeasurePressed() {
    context.read<MeasurementBloc>().add(MeasurementSendMeasureCommand());
  }

  void _onNextPressed() {
    if (measurementDone && measurementValue != null) {
      context.read<MeasurementBloc>().add(
        SaveReferenceMeasurement(measurementValue!),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DistanceScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<MeasurementBloc>.value(
      value: context.read<MeasurementBloc>(),
      child: Scaffold(
        body: BlocListener<MeasurementBloc, MeasurementState>(
          listener: (context, state) {
            if (state is MeasurementDataState &&
                state.currentMeasurement != null) {
              setState(() {
                measurementDone = true;
                measurementValue = state.currentMeasurement;
              });
            } else if (state is MeasurementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: GenericStepScreen(
            title: l10n.measurement,
            imagePath: 'assets/images/reference.png',
            stepTitle: l10n.heightMeasurement,
            description:
                measurementDone && measurementValue != null
                    ? l10n.referenceResult(formatCentimeters(measurementValue!))
                    : l10n.referenceMeasurement,
            stepIndex: 1,
            totalSteps: 3,
            onNext: measurementDone ? _onNextPressed : _onMeasurePressed,
          ),
        ),
      ),
    );
  }
}

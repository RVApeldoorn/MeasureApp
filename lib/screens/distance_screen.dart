import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/measurement_bloc.dart';
import 'package:measureapp/bloc/measurement_event.dart';
import 'package:measureapp/bloc/measurement_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/widgets/generic_step_screen.dart';
import 'package:measureapp/screens/measurement_finished_screen.dart';
import 'package:measureapp/utils/measurement_utils.dart';

class DistanceScreen extends StatefulWidget {
  const DistanceScreen({super.key});

  @override
  State<DistanceScreen> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  bool measurementDone = false;
  String? measurementValue;

  void _onMeasurePressed() {
    context.read<MeasurementBloc>().add(MeasurementSendMeasureCommand());
  }

  void _onNextPressed() {
    final state = context.read<MeasurementBloc>().state;
    if (state is MeasurementDataState &&
        measurementDone &&
        measurementValue != null) {
      if (state.sessionId == null || state.requestId == null) {
        return;
      }
      context.read<MeasurementBloc>().add(
            SaveCurrentMeasurement(measurementValue!),
          );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MeasurementFinishedScreen()),
      );
    }
  }

  double? _parseDistance(String raw) {
    try {
      return double.parse(raw.replaceAll(RegExp(r'[^0-9.]'), '').trim());
    } catch (_) {
      return null;
    }
  }

  double? get parsedCurrent =>
      measurementValue != null ? _parseDistance(measurementValue!) : null;

  double? get parsedReference {
    final state = context.read<MeasurementBloc>().state;
    if (state is MeasurementDataState && state.referenceMeasurement != null) {
      return _parseDistance(state.referenceMeasurement!);
    }
    return null;
  }

  double? get verschil {
    if (parsedCurrent != null && parsedReference != null) {
      return parsedReference! - parsedCurrent!;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<MeasurementBloc, MeasurementState>(
      listener: (context, state) {
        if (state is MeasurementDataState && state.currentMeasurement != null) {
          setState(() {
            measurementDone = true;
            measurementValue = state.currentMeasurement;
          });
        }
      },
      child: BlocBuilder<MeasurementBloc, MeasurementState>(
        builder: (context, state) {
          String description = l10n.measureDescription;
          if (parsedReference != null &&
              parsedCurrent != null &&
              verschil != null) {
            description = l10n.heightResult(
              formatCentimeters(verschil!.toString()),
              formatCentimeters(parsedReference!.toString()),
              formatCentimeters(parsedCurrent!.toString()),
            );
          }
          return GenericStepScreen(
            title: l10n.measurement,
            imagePath: 'assets/images/distance.png',
            stepTitle: l10n.heightMeasurement,
            description: description,
            stepIndex: 2,
            totalSteps: 3,
            onNext: measurementDone ? _onNextPressed : _onMeasurePressed,
          );
        },
      ),
    );
  }
}
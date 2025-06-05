import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/ble_bloc.dart';
import 'package:measureapp/bloc/ble_event.dart';
import 'package:measureapp/bloc/ble_state.dart';
import 'package:measureapp/widgets/measurement_step_screen.dart'; 
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'distance_screen.dart'; 

class ReferenceMeasurementScreen extends StatefulWidget {
  const ReferenceMeasurementScreen({Key? key}) : super(key: key);

  @override
  State<ReferenceMeasurementScreen> createState() => _ReferenceMeasurementScreenState();
}

class _ReferenceMeasurementScreenState extends State<ReferenceMeasurementScreen> {
  bool measurementDone = false;
  String? measurementValue;

  void _onMeasurePressed() {
    context.read<BleBloc>().add(BleSendMeasureCommand());
  }

  void _onNextPressed() {
    if (measurementDone && measurementValue != null) {
      context.read<BleBloc>().add(SaveReferenceMeasurement(measurementValue!));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DistanceScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Voer eerst een meting uit")),
      );
    }
  }

  String _formatMeters(String mmString) {
  final mm = double.tryParse(mmString.replaceAll(" mm", "").trim()) ?? 0;
  final meters = mm / 1000;
  return meters.toStringAsFixed(2);
}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<BleBloc, BleState>(
    listener: (context, state) {
    if (state is BleMeasurementState && state.currentMeasurement != null) {
      setState(() {
        measurementDone = true;
        measurementValue = state.currentMeasurement;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Referentiemeting succesvol")),
      );
    } else if (state is BleError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
      child: MeasurementStepScreen(
        title: l10n.referenceTitle,
        imagePath: 'assets/images/reference.png',
        stepTitle: l10n.referenceTitle,
        description: measurementDone && measurementValue != null
          ? _formatMeters(measurementValue!)
          : l10n.hangLaser,
        stepIndex: 1,
        totalSteps: 8,
        isLoading: false,
        onNext: measurementDone ? _onNextPressed : _onMeasurePressed,
        customButtonText: measurementDone ? l10n.nextStep : l10n.saveReference,
      ),
    );
  }
}

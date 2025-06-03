import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/ble_bloc.dart';
import 'package:measureapp/bloc/ble_event.dart';
import 'package:measureapp/bloc/ble_state.dart';
import 'package:measureapp/widgets/measurement_step_screen.dart'; // jouw custom widget

class DistanceScreen extends StatefulWidget {
  const DistanceScreen({super.key});

  @override
  State<DistanceScreen> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  String? _currentMeasurement;

  void _onMeasurePressed() {
    context.read<BleBloc>().add(BleSendMeasureCommand());
  }

  double? _parseToDouble(String? value) {
    if (value == null) return null;
    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BleBloc, BleState>(
      listener: (context, state) {
        if (state is BleMeasurementSuccess) {
          setState(() {
            _currentMeasurement = state.distance;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Meting ontvangen")),
          );
        }
      },
      child: BlocBuilder<BleBloc, BleState>(
        builder: (context, state) {
          String description = "De meting wordt nu gedaan. Klik op Meet afstand om de meting af te ronden.";

          final reference = (state is BleMeasurementState) ? state.referenceMeasurement : null;
          final double? refValue = _parseToDouble(reference);
          final double? currentValue = _parseToDouble(_currentMeasurement);

          if (refValue != null && currentValue != null) {
            final verschil = (refValue - currentValue).toStringAsFixed(1);
            description = "Referentie: ${refValue.toStringAsFixed(1)} cm\n"
                          "Huidige meting: ${currentValue.toStringAsFixed(1)} cm\n"
                          "Verschil: $verschil cm";
          } else if (refValue != null) {
            description = "Referentiewaarde is ${refValue.toStringAsFixed(1)} cm.\n"
                          "Druk op meten om te vergelijken.";
          }

          return MeasurementStepScreen(
            title: "Lengtemeting",
            imagePath: 'assets/images/distance.png',
            stepTitle: "Stap 7",
            description: description,
            stepIndex: 7,
            totalSteps: 7,
            isLoading: state is BleMeasuring,
            onNext: _onMeasurePressed,
            customButtonText: 'Meet afstand',
          );
        },
      ),
    );
  }
}

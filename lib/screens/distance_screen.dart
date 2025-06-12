import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/ble_bloc.dart';
import 'package:measureapp/bloc/ble_event.dart';
import 'package:measureapp/bloc/ble_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/widgets/succes_screen.dart';
import 'package:measureapp/widgets/generic_step_screen.dart'; 
// import 'package:measureapp/widgets/measurement_step_screen.dart';

class DistanceScreen extends StatefulWidget {
  const DistanceScreen({Key? key}) : super(key: key);

  @override
  State<DistanceScreen> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  bool measurementDone = false;
  String? measurementValue;

  void _onMeasurePressed() {
    context.read<BleBloc>().add(BleSendMeasureCommand());
  }

  double? _parseDistance(String raw) {
    try {
      return double.parse(raw.replaceAll(RegExp(r'[^0-9.]'), '').trim());
    } catch (_) {
      return null;
    }
  }

  double? get parsedCurrent => measurementValue != null ? _parseDistance(measurementValue!) : null;

  double? get parsedReference {
    final state = context.read<BleBloc>().state;
    if (state is BleMeasurementState && state.referenceMeasurement != null) {
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
  return BlocListener<BleBloc, BleState>(
  listener: (context, state) {
    if (state is BleMeasurementState && state.currentMeasurement != null) {
      setState(() {
        measurementDone = true;
        measurementValue = state.currentMeasurement;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meting succesvol')),
      );
    } else if (state is BleMeasurementSuccess) {
      setState(() {
        measurementDone = true;
        measurementValue = state.distance;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meting succesvol')),
      );
    } else if (state is BleError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
    child: BlocBuilder<BleBloc, BleState>(
        builder: (context, state) {
          String description = l10n.measureDescription;

          if (parsedReference != null && parsedCurrent != null && verschil != null) {
            description = "Afstand: ${parsedCurrent!.toStringAsFixed(1)} cm\n"
                "Referentie: ${parsedReference!.toStringAsFixed(1)} cm\n"
                "Verschil: ${verschil!.toStringAsFixed(1)} cm";
          } else {
            description = "Zorg dat het object op de juiste afstand staat en druk op meten.";
          }

        return GenericStepScreen(
          title: l10n.measurement,
          imagePath: 'assets/images/distance.png',
          stepTitle: l10n.heightMeasurement,
          description: description,
          stepIndex: 2,
          totalSteps: 8,
          onNext: _onMeasurePressed,
          // customButtonText: measurementDone ? 'Opnieuw meten' : 'Meet afstand',
        );
      },
    ),
  );
}

}

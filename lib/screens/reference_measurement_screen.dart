import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/ble_bloc.dart';
import 'package:measureapp/bloc/ble_event.dart';
import 'package:measureapp/bloc/ble_state.dart';
import 'package:measureapp/widgets/generic_step_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'distance_screen.dart';

class ReferenceMeasurementScreen extends StatefulWidget {
  final int sessionId;
  final int requestId;

  const ReferenceMeasurementScreen({
    Key? key,
    required this.sessionId,
    required this.requestId,
  }) : super(key: key);

  @override
  State<ReferenceMeasurementScreen> createState() =>
      _ReferenceMeasurementScreenState();
}

class _ReferenceMeasurementScreenState
    extends State<ReferenceMeasurementScreen> {
  bool measurementDone = true;
  String? measurementValue;

  void _onMeasurePressed() {
    context.read<BleBloc>().add(BleSendMeasureCommand());

  }

  void _onNextPressed() {
    // if (measurementDone && measurementValue != null) {
    if (measurementDone) { // temp fix for test
      // context.read<BleBloc>().add(SaveReferenceMeasurement(measurementValue!));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DistanceScreen( 
          sessionId: widget.sessionId,
          requestId: widget.requestId,
        )),
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
        if (state is BleMeasurementSuccess) {
          setState(() {
            measurementDone = true;
            measurementValue = state.distance;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Referentiemeting succesvol")),
          );
        } else if (state is BleError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: GenericStepScreen(
        title: l10n.measurement,
        imagePath: 'assets/images/reference.png',
        stepTitle: l10n.heightMeasurement,
        description:
            measurementDone && measurementValue != null
                ? _formatMeters(measurementValue!)
                : l10n.hangLaser,
        stepIndex: 1,
        totalSteps: 3,
        // isLoading: false,
        onNext: _onNextPressed,
        // customButtonText: measurementDone ? l10n.nextStep : l10n.saveReference,
      ),
    );
  }
}

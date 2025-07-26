import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/measurement_bloc.dart';
import 'package:measureapp/bloc/measurement_event.dart';
import 'package:measureapp/bloc/measurement_state.dart';
import 'package:measureapp/screens/reference_measurement_screen.dart';
import 'package:measureapp/widgets/measurement_action_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<MeasurementBloc, MeasurementState>(
      builder: (context, state) {
        String imagePath = 'assets/images/neutral.png';
        String buttonText = l10n.connect;
        bool isLoading = false;
        VoidCallback onPressed = () {
          context.read<MeasurementBloc>().add(MeasurementScanAndConnect());
        };

        if (state is MeasurementConnecting) {
          imagePath = 'assets/images/neutral.png';
          isLoading = true;
          buttonText = l10n.connect;
        } else if (state is MeasurementConnected) {
          imagePath = 'assets/images/connected.png';
          buttonText = l10n.next;
          onPressed = () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferenceMeasurementScreen()));
          };
        } else if (state is MeasurementError) {
          imagePath = 'assets/images/not_connected.png';
          buttonText = l10n.retry;
        }

        return MeasurementActionScreen(
          title: l10n.measurement,
          imagePath: imagePath,
          stepTitle: l10n.heightMeasurement,
          description: l10n.deviceSetup,
          stepIndex: 0,
          totalSteps: 3,
          buttonText: buttonText,
          isLoading: isLoading,
          onPressed: onPressed,
        );
      },
    );
  }
}
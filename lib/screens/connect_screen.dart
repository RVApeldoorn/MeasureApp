import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/ble_bloc.dart';
import 'package:measureapp/bloc/ble_event.dart';
import 'package:measureapp/bloc/ble_state.dart';
import 'reference_measurement_screen.dart';
import 'package:measureapp/widgets/MeasurementActionScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectScreen extends StatelessWidget {
  final int sessionId;
  final int requestId;

  const ConnectScreen({super.key, required this.sessionId, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<BleBloc, BleState>(
      builder: (context, state) {
        String imagePath = 'assets/images/neutral.png';
        String buttonText = l10n.heightMeasurement;
        bool isLoading = false;
        VoidCallback onPressed = () {
          context.read<BleBloc>().add(BleScanAndConnect());
        };

        if (state is BleConnecting) {
          imagePath = 'assets/images/neutral.png';
          isLoading = true;
          buttonText = 'Verbinding maken...';
        } else if (state is BleConnected) {
          imagePath = 'assets/images/connected.png';
          buttonText = l10n.next;
          onPressed = () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ReferenceMeasurementScreen(
              sessionId: this.sessionId,
              requestId: this.requestId,
            )));
          };
        } else if (state is BleError) {
          imagePath = 'assets/images/not_connected.png';
          buttonText = 'Opnieuw proberen';
        }

        return MeasurementActionScreen(
          title: l10n.measurement,
          imagePath: imagePath,
          stepTitle: l10n.heightMeasurement,
          description: 'Zorg dat het apparaat aanstaat en dichtbij is.',
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/ble_bloc.dart';
import 'package:measureapp/bloc/ble_event.dart';
import 'package:measureapp/bloc/ble_state.dart';
import 'distance_screen.dart';
import 'ReferenceMeasurementScreen.dart';
import 'step_two_measurement_screen.dart';
import 'package:measureapp/widgets/MeasurementActionScreen.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BleBloc, BleState>(
      builder: (context, state) {
        String imagePath = 'assets/images/neutral.png';
        String buttonText = 'Verbinding maken';
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
          buttonText = 'Volgende';
          onPressed = () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferenceMeasurementScreen()));
          };
        } else if (state is BleError) {
          imagePath = 'assets/images/not_connected.png';
          buttonText = 'Opnieuw proberen';
        }

        return MeasurementActionScreen(
          title: 'Verbinding maken',
          imagePath: imagePath,
          stepTitle: 'Stap 1: Verbinden',
          description: 'Zorg dat het apparaat aanstaat en dichtbij is.',
          stepIndex: 0,
          totalSteps: 4,
          buttonText: buttonText,
          isLoading: isLoading,
          onPressed: onPressed,
        );
      },
    );
  }
}

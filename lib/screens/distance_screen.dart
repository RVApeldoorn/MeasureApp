import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/ble_bloc.dart';
import 'package:measureapp/bloc/ble_event.dart';
import 'package:measureapp/bloc/ble_state.dart';

class DistanceScreen extends StatelessWidget {
  const DistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Afstand meten")),
      body: Center(
        child: BlocBuilder<BleBloc, BleState>(
          builder: (context, state) {
            if (state is BleMeasurementSuccess) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Afstand: ${state.distance}", style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Toon opnieuw de laatste meting als je wilt (optioneel)
                      context.read<BleBloc>().add(BleShowLastMeasurement());
                    },
                    child: const Text("Ververs afstand"),
                  ),
                ],
              );
            } else if (state is BleError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Fout: ${state.message}", style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Probeer opnieuw data te tonen
                      context.read<BleBloc>().add(BleShowLastMeasurement());
                    },
                    child: const Text("Opnieuw proberen"),
                  ),
                ],
              );
            } else if (state is BleConnected) {
              return ElevatedButton(
                onPressed: () {
                  // Laat de laatst ontvangen waarde zien
                  context.read<BleBloc>().add(BleShowLastMeasurement());
                },
                child: const Text("Toon afstand"),
              );
            } else if (state is BleConnecting) {
              return const CircularProgressIndicator();
            } else {
              return ElevatedButton(
                onPressed: () {
                  // Start connectie en scannen
                  context.read<BleBloc>().add(BleScanAndConnect());
                },
                child: const Text("Verbind met sensor"),
              );
            }
          },
        ),
      ),
    );
  }
}
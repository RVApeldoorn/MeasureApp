import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/ble_bloc.dart';
import 'package:measureapp/bloc/ble_event.dart';
import 'package:measureapp/bloc/ble_state.dart';
import 'step_two_measurement_screen.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verbinding maken")),
      body: Center(
        child: BlocBuilder<BleBloc, BleState>(
          builder: (context, state){
            String imageAsset;
            if (state is BleConnected){
              imageAsset = 'assets/images/connected.png';
            } else if (state is BleError){
              imageAsset = 'assets/images/not_connected.png';
            } else {
              imageAsset = 'assets/images/neutral.png';
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imageAsset,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                if (state is BleInitial || state is BleError) ...[
                  ElevatedButton(
                    onPressed: () {
                      context.read<BleBloc>().add(BleScanAndConnect());
                    },
                    child: const Text("Verbinding maken"),
                  ),
                ]else if (state is BleConnecting) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text("Verbinding maken..."),
                ]else if (state is BleConnected) ...[
                  const Text("Verbonden!", style: TextStyle(fontSize: 18)),
                ],
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => IntroStepTwoScreen()),
                    );
                  },
                  child: const Text("Ga naar afstandsscherm"),
                ),
              ],
            );
          }
          ),
      ),
    );
  }
}

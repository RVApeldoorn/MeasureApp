import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/measurement_bloc.dart';
import 'package:measureapp/bloc/measurement_state.dart';
import 'package:measureapp/screens/growth_curve_screen.dart';
import 'package:measureapp/screens/home_screen.dart';
import 'package:measureapp/utils/measurement_utils.dart';
import 'package:measureapp/widgets/bottom_navigation_bar.dart';
import 'package:measureapp/widgets/top_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/services/api_service.dart';

class MeasurementFinishedScreen extends StatefulWidget {
  const MeasurementFinishedScreen({super.key});

  @override
  State<MeasurementFinishedScreen> createState() =>
      _MeasurementFinishedScreenState();
}

class _MeasurementFinishedScreenState extends State<MeasurementFinishedScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitMeasurement(
    int sessionId,
    int requestId,
    String height,
  ) async {
    final ApiService apiService = ApiService();
    await apiService.submitMeasurement(
      sessionId: sessionId,
      measurementRequestId: requestId,
      value: height,
      note: _noteController.text,
    );
    
  }

  double? _calculateHeight(MeasurementState state) {
    if (state is MeasurementDataState &&
        state.referenceMeasurement != null &&
        state.currentMeasurement != null) {
      final ref =
          double.tryParse(
            state.referenceMeasurement!.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          0;
      final curr =
          double.tryParse(
            state.currentMeasurement!.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          0;
      final height = ref - curr;
      return height;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<MeasurementBloc, MeasurementState>(
      builder: (context, state) {
        final height = _calculateHeight(state);
        final heightText =
            height != null
                ? "${formatCentimeters(height.toString())} cm"
                : l10n.noMeasurement;
        final sessionId =
            state is MeasurementDataState ? state.sessionId : null;
        final requestId =
            state is MeasurementDataState ? state.requestId : null;

        return Scaffold(
          backgroundColor: const Color(0xFFEFF3FB),
          appBar: TopBar(title: l10n.measurement),
          bottomNavigationBar: const BottomNavBar(
            currentIndex: 0,
            isChildModeEnabled: true,
            isOnHomeScreen: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.review_and_submit,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.insight,
                            style: const TextStyle(
                              color: Color(0xFF1D53BF),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.successful,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${l10n.height}: $heightText",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/growthCurve/example_curve.jpg',
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: double.infinity,
                                ),
                                ElevatedButton(
                                  onPressed:
                                      height != null &&
                                              sessionId != null &&
                                              requestId != null
                                          ? () async {
                                            await _submitMeasurement(
                                              sessionId,
                                              requestId,
                                              height.toStringAsFixed(1),
                                            );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        GrowthCurveScreen(),
                                              ),
                                            );
                                          }
                                          : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1D53BF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: const Size(120, 48),
                                  ),
                                  child: Text(
                                    l10n.view,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.questions,
                        style: const TextStyle(
                          color: Color(0xFF1D53BF),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.questionExpand,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        maxLines: 3,
                        controller: _noteController,
                        decoration: InputDecoration(
                          hintText: "...",
                          filled: true,
                          fillColor: const Color(0xFFDDE8FB),
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              height != null &&
                                      sessionId != null &&
                                      requestId != null
                                  ? () async {
                                    await _submitMeasurement(
                                      sessionId,
                                      requestId,
                                      height.toStringAsFixed(1),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ),
                                    );
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D53BF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size.fromHeight(56),
                          ),
                          child: Text(
                            l10n.submit,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

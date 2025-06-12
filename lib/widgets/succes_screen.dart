import 'package:flutter/material.dart';
import 'package:measureapp/screens/growth_curve_screen.dart';
import 'package:measureapp/screens/home_screen.dart';
import 'package:measureapp/widgets/bottom_navigation_bar.dart';
import 'package:measureapp/widgets/top_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/services/api_service.dart';

class MeasurementFinishedScreen extends StatefulWidget {
  // final int sessionId;
  // final int requestId;
  
  const MeasurementFinishedScreen({super.key, 
  // required this.sessionId, required this.requestId
  });

  @override
  State<MeasurementFinishedScreen> createState() => _MeasurementFinishedScreenState();
}

class _MeasurementFinishedScreenState extends State<MeasurementFinishedScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitMeasurement() async {
    try {
      final ApiService apiService = ApiService();
      // await apiService.submitMeasurement(
      //   sessionId: widget.sessionId,
      //   measurementRequestId: widget.requestId,
      //   value: '128.4',
      //   note: _noteController.text,
      // );
      print("Measurement submitted");
    } catch (e) {
      // Handle error
      print('Error submitting measurement: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FB),
      appBar: TopBar(title: l10n.measurement),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 0,
        isChildModeEnabled: true,
        isOnHomeScreen: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Titel
            Text(
              l10n.heightMeasurement,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            /// Inzicht kaart
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
                  const SizedBox(height: 16),

                  /// Afbeelding + knop (Stack)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/growthCurve/example_curve.jpg', // Zet hier je asset pad
                          fit: BoxFit.cover,
                          height: 120,
                          width: double.infinity,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            _submitMeasurement();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GrowthCurveScreen()));
                          },
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

            const SizedBox(height: 24),

            /// Vraagblok
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

                  /// Tekstveld
                  TextField(
                    maxLines: 4,
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
                      onPressed: () async {
                        _submitMeasurement();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
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
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:measureapp/widgets/bottom_navigation_bar.dart';
import 'package:measureapp/widgets/top_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MeasurementFinishedScreen extends StatelessWidget {
  const MeasurementFinishedScreen({super.key});

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
            // Titel
            Text(
              l10n.heightMeasurement,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                
              ),
            ),
            const SizedBox(height: 16),

            // Inzicht
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDE8FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Actie voor 'Bekijk'
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Vraagblok
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
                    style: TextStyle(
                      color: Color(0xFF1D53BF),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.questionExpand,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDE8FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('...'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Doorgaan met volgende
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D53BF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size.fromHeight(56),
                      ),
                      child: Text(
                        l10n.next,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
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

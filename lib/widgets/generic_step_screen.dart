import 'package:flutter/material.dart';
import 'package:measureapp/widgets/bottom_navigation_bar.dart';
import 'package:measureapp/widgets/top_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenericStepScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final String stepTitle;
  final String description;
  final int stepIndex;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  const GenericStepScreen({
    required this.title,
    required this.imagePath,
    required this.stepTitle,
    required this.description,
    required this.stepIndex,
    required this.totalSteps,
    required this.onNext,
    this.onSkip,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FB),
      appBar: TopBar(title: title),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 0,
        isChildModeEnabled: true,
        isOnHomeScreen: false,
      ),

      /// Scrollbare boveninhoud
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stepTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24),
              child: Center(child: Image.asset(imagePath)),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),

      /// Onderaan vast geplakt
      bottomSheet: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 240,
        ), // ← hier is het verschil
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 235,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${l10n.step} ${stepIndex + 1}\n',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D53BF),
                                  fontSize: 20,
                                ),
                              ),
                              TextSpan(
                                text: description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (onSkip != null)
                        ElevatedButton(
                          onPressed: onSkip,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D53BF),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            minimumSize: const Size(150, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            l10n.skip,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(totalSteps, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  index == stepIndex
                                      ? const Color(0xFF1D53BF)
                                      : Colors.grey[300],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D53BF),
                            minimumSize: const Size.fromHeight(68),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            l10n.next,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
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
        ),
      ),
    );
  }
}

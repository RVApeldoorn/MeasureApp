import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/measurement_bloc.dart';
import 'package:measureapp/bloc/measurement_event.dart';
import 'package:measureapp/screens/growth_curve_screen.dart';
import 'package:measureapp/screens/home_screen.dart';
import 'package:measureapp/screens/relaxing_exercise/exercise_one.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isChildModeEnabled;
  final bool isOnHomeScreen;

  const BottomNavBar({
    this.currentIndex = 1,
    this.isChildModeEnabled = false,
    this.isOnHomeScreen = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: isOnHomeScreen
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.black),
              unselectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.black),
              onTap: (index) {
                if (index == 1) {
                    // Reset measurement state before navigating to HomeScreen
                    context.read<MeasurementBloc>().add(
                      const CancelMeasurement(),
                    );
                  Navigator.pushReplacement(
                    context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                  );
                } else if (isChildModeEnabled && index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExerciseOne()),
                  );
                } else if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GrowthCurveScreen(),
                      ),
                    );
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/ruler.png',
                    width: 32,
                    height: 32,
                  ),
                  label: l10n.growth,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/home.png',
                    width: 32,
                    height: 32,
                  ),
                  label: l10n.home,
                ),
                if (isChildModeEnabled)
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/yoga.png',
                      width: 32,
                      height: 32,
                    ),
                    label: l10n.exercises,
                  ),
              ],
            )
          : Center(
              child: GestureDetector(
                onTap: () {
                    Navigator.pushAndRemoveUntil(
                    context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/home.png',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.home,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
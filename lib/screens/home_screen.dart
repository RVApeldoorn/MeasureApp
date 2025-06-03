import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/relaxing_exercise/exercise_one.dart';
import 'package:measureapp/services/api_service.dart';
import 'package:measureapp/utils/date_utils.dart';
import 'package:measureapp/widgets/big_button.dart';
import 'package:measureapp/widgets/bottom_navigation_bar.dart';
import 'package:measureapp/widgets/no_sessions_block.dart';
import 'package:measureapp/widgets/session_block.dart';
import 'package:measureapp/widgets/top_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:measureapp/screens/growth_curve_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  String _patientName = '';
  List<dynamic> _sessions = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _noSessionsFound = false;
  bool _isChildModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchSessionsData();
    _loadChildModeSetting();
  }

  Future<void> _fetchSessionsData() async {
    try {
      final data = await _apiService.fetchSessions();
      setState(() {
        _patientName = data['patientName'] ?? '';
        _sessions = data['sessions'] ?? [];
        _isLoading = false;
        _noSessionsFound = _sessions.isEmpty;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _noSessionsFound = false;
      });
    }
  }

  Future<void> _loadChildModeSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isChildModeEnabled = prefs.getBool('childMode') ?? false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar(title: t.app_title),
      bottomNavigationBar: BottomNavBar(
        isChildModeEnabled: _isChildModeEnabled,
        isOnHomeScreen: true,
        currentIndex: 1,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchSessionsData,
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [Center(child: Text('error: $_errorMessage'))],
                )
                : ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.0),
                  children: [
                    Text(
                      getGreeting(context),
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF1D53BF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _patientName,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_noSessionsFound) NoSessionsBlock(),
                    ..._sessions.asMap().entries.map((entry) {
                      var session = entry.value;
                      return Column(
                        children: [
                          SessionBlock(session: session),
                          SizedBox(height: 4),
                        ],
                      );
                    }),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        if (_isChildModeEnabled)
                          Expanded(
                            child: BigButton(
                              title: t.exercises,
                              subtitle: t.exercise,
                              iconWidget: Image.asset(
                                'assets/icons/yoga.png',
                                width: 55,
                                height: 55,
                                fit: BoxFit.contain,
                              ),

                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ExerciseOne(
                                          sessionId: 0,
                                          requestId: 0,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        if (_isChildModeEnabled) SizedBox(width: 8),
                        Expanded(
                          child: BigButton(
                            title: t.insight,
                            subtitle: t.growth_curve,
                            iconWidget: Image.asset(
                              'assets/icons/ruler.png',
                              width: 55,
                              height: 55,
                              fit: BoxFit.contain,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GrowthCurveScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
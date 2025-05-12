import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/services/api_service.dart';
import 'package:measureapp/utils/date_utils.dart';
import 'package:measureapp/widgets/big_button.dart';
import 'package:measureapp/widgets/bottom_navigation_bar.dart';
import 'package:measureapp/widgets/no_sessions_block.dart';
import 'package:measureapp/widgets/session_block.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:measureapp/widgets/top_bar.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchSessionsData();
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: TopBar(title: t.app_title),
      bottomNavigationBar: const BottomNavBar(),
      body: RefreshIndicator(
        onRefresh: _fetchSessionsData,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [Center(child: Text('error: $_errorMessage'))],
                  )
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Text(
                        getGreeting(context),
                        style: TextStyle(
                        fontSize: 35,
                        color: Color(0xFF1D53BF),
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      Text(
                        _patientName,
                        style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      SizedBox(height: 10),
                      if (_noSessionsFound)
                        NoSessionsBlock()
                      else
                        ..._sessions.asMap().entries.map((entry) {
                          var session = entry.value;
                          return Column(
                            children: [
                              SessionBlock(session: session),
                              SizedBox(height: 4),
                            ],
                          );
                      }),
                      Row(
                        children: [
                          Expanded(
                            child: BigButton(
                              title: t.growth_safari,
                              iconWidget: SvgPicture.asset(
                                'assets/icons/lion.svg',
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: BigButton(
                              title: t.growth_curve,
                              iconWidget: SvgPicture.asset(
                                'assets/icons/loop.svg',
                              ),
                              onPressed: () {},
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
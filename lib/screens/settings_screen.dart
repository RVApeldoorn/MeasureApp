import 'package:flutter/material.dart';
import 'package:measureapp/widgets/bottom_navigation_bar.dart';
import 'package:measureapp/widgets/top_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isChildModeEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChildModeSetting();
  }

  Future<void> _loadChildModeSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isChildModeEnabled = prefs.getBool('childMode') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _saveChildModeSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('childMode', value);
    setState(() {
      _isChildModeEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: TopBar(title: l10n.settings),
      bottomNavigationBar: BottomNavBar(
        isChildModeEnabled: _isChildModeEnabled,
        currentIndex: _isChildModeEnabled ? 2 : 1,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text(
                  l10n.preferences,
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF1D53BF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                SwitchListTile(
                  title: Text(
                    l10n.child_mode,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(l10n.child_mode_helpertext),
                  value: _isChildModeEnabled,
                  activeColor: Color(0xFF1D53BF),
                  onChanged: (bool value) {
                    _saveChildModeSetting(value);
                  },
                ),
              ],
            ),
    );
  }
}
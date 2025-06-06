import 'package:flutter/material.dart';
import 'package:measureapp/widgets/bottom_navigation_bar.dart';
import 'package:measureapp/widgets/top_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:measureapp/state/locale_provider.dart';

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
    final localeProvider = Provider.of<LocaleProvider>(context);

    const EdgeInsets settingsPadding = EdgeInsets.only(left: 16.0); // Adjust this value to control indentation

    return Scaffold(
      appBar: TopBar(title: l10n.settings),
      bottomNavigationBar: BottomNavBar(
        isChildModeEnabled: _isChildModeEnabled,
        currentIndex: _isChildModeEnabled ? 2 : 1,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  l10n.preferences,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Color(0xFF1D53BF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                SwitchListTile(
                  contentPadding: settingsPadding,
                  title: Text(
                    l10n.child_mode,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(l10n.child_mode_helpertext),
                  value: _isChildModeEnabled,
                  activeColor: const Color(0xFF1D53BF),
                  onChanged: (bool value) {
                    _saveChildModeSetting(value);
                  },
                ),

                const SizedBox(height: 10),

                ListTile(
                  contentPadding: settingsPadding,
                  title: Text(
                    l10n.language,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: DropdownButton<Locale>(
                    value: localeProvider.locale,
                    onChanged: (Locale? newLocale) {
                      if (newLocale != null) {
                        localeProvider.setLocale(newLocale);
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: Locale('nl'),
                        child: Text('Nederlands'),
                      ),
                      DropdownMenuItem(
                        value: Locale('en'),
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: Locale('it'),
                        child: Text('Italiano'),
                      ),
                      DropdownMenuItem(
                        value: Locale('zh'),
                        child: Text('Chinese (zh)'),
                      ),
                      DropdownMenuItem(
                        value: Locale('ar'),
                        child: Text('Arabisch (ar-ma)'),
                      ),
                      DropdownMenuItem(
                        value: Locale('tr'),
                        child: Text('Türkçe (tr)'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
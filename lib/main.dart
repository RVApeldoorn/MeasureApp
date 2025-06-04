import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/setup_screen.dart';
import 'package:measureapp/screens/pin_screen.dart';
import 'package:measureapp/screens/pin_lock_screen.dart';
// import 'package:measureapp/screens/connect_screen.dart';
import 'package:measureapp/utils/secure_storage.dart';
import 'package:measureapp/state/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/ble_bloc.dart';
import 'package:measureapp/services/ble_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await SecureStorage.getToken();
  String? pin = await SecureStorage.getPin();

  runApp(HomeScreen(token: token, pin: pin));
}

class HomeScreen extends StatelessWidget {
  final String? token;
  final String? pin;

  const HomeScreen({super.key, this.token, this.pin});

  @override
  Widget build(BuildContext context) {
    Widget startScreen;

    if (token == null) {
      startScreen = const SetupScreen();
    } else if (pin == null) {
      startScreen = const PinScreen();
    } else {
      startScreen = PinLockScreen();
    }

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => BleBloc(BleService()))],
      child: ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: Consumer<LocaleProvider>(
          builder: (context, localeProvider, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Measure App',
              theme: ThemeData(primarySwatch: Colors.blue),
              home: startScreen,
              locale: localeProvider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('nl'),
                Locale('it'),
                Locale('zh'),
                Locale('ar'),
                Locale('tr'),
              ],
            );
          },
        ),
      ),
    );
  }
}

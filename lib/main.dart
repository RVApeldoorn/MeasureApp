import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:measureapp/screens/setup_screen.dart';
import 'package:measureapp/screens/pin_screen.dart';
import 'package:measureapp/screens/pin_lock_screen.dart';
import 'package:measureapp/utils/secure_storage.dart';
import 'package:measureapp/state/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measureapp/bloc/measurement_bloc.dart';
import 'package:measureapp/services/measurement_service.dart';
import 'package:measureapp/services/ble/ble_service.dart';
import 'package:measureapp/services/mock/mock_service.dart';
import 'package:measureapp/services/serial/serial_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await SecureStorage.getToken();
  String? pin = await SecureStorage.getPin();

  const String serviceType = String.fromEnvironment(
    'MEASUREMENT_SERVICE',
    defaultValue: 'mock',
  );
  MeasurementService measurementService;
  switch (serviceType) {
    case 'ble':
      measurementService = BleMeasurementService();
      break;
    case 'serial':
      measurementService = SerialMeasurementService();
      break;
    case 'mock':
    default:
      measurementService = MockMeasurementService();
      break;
  }

  runApp(
    HomeScreen(token: token, pin: pin, measurementService: measurementService),
  );
}

class HomeScreen extends StatelessWidget {
  final String? token;
  final String? pin;
  final MeasurementService measurementService;

  const HomeScreen({
    super.key,
    this.token,
    this.pin,
    required this.measurementService,
  });

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
      providers: [
        BlocProvider(create: (_) => MeasurementBloc(measurementService)),
      ],
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

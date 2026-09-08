import 'package:flutter/material.dart';
import 'features/home_screen/presentation/screens/home_view.dart';
import 'features/onboarding/presentation/pages/onboarding_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movies_app/features/onboarding/presentation/pages/onboarding_view.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      home: const MainNavigationScreen(),
    );
  }
}

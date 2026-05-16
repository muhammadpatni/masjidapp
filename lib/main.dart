import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masjidapp/firebase_options.dart';
import 'package:masjidapp/splash_screen.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/donation_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/project_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        // Global state
        ChangeNotifierProvider(create: (_) => AppProvider()),

        // Data providers — each starts its Firestore stream on creation
        ChangeNotifierProvider(create: (_) => DonationProvider()..init()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()..init()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()..init()),
      ],
      child: const MasjidApp(),
    ),
  );
}

class MasjidApp extends StatelessWidget {
  const MasjidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masjid Management',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),

      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: mq.textScaler.clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.2,
            ),
          ),
          child: child!,
        );
      },

      home: const SplashScreen(),
    );
  }
}

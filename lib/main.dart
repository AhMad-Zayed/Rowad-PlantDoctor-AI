import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'presentation/providers/app_state.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const SmartPlantDoctorApp(),
    ),
  );
}

class SmartPlantDoctorApp extends StatelessWidget {
  const SmartPlantDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Plant Doctor AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // Enforce Arabic RTL localization
      locale: const Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
      ],
      
      home: const SplashScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_page.dart';
import 'localization/app_localizations.dart';
import 'config.dart';

void main() {
  runApp(const ArkadasApp());
}

class ArkadasApp extends StatelessWidget {
  const ArkadasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ArkadaşAI',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5A65EA), // blue-purple seed color
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5A65EA),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
        Locale('ar'),
      ],
      home: const SplashPage(),
    );
  }
}

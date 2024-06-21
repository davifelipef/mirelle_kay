import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirelle_kay/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirelle_kay/screens/splash_screen.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/google_fonts/LICENSE.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Brazilian Portuguese
      ],
      debugShowCheckedModeBanner:
          false, //if set to false, disables the debug banner
      home: const SplashScreen(),
      routes: {
        HomePage.routeName: (context) =>
            const HomePage(), // Set up the route for the home page
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mirelle_kay/screens/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Brazilian Portuguese
      ],
      debugShowCheckedModeBanner:
          false, //if set to false, disables the debug banner
      home: const HomePage(),
      routes: {
        HomePage.routeName: (context) =>
            const HomePage(), // Set up the route for the home page
      },
    );
  }
}

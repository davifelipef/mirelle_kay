import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mirelle_kay/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirelle_kay/screens/inventory_screen.dart';
import 'package:mirelle_kay/screens/sales_screen.dart';
import 'package:mirelle_kay/screens/clients_screen.dart';
import 'package:mirelle_kay/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Open Hive boxes
  await Hive.openBox<Map<dynamic, dynamic>>("events_box");
  await Hive.openBox("products_box");
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
      // Ensure the splash screen is visible for at least 2 seconds
      home: const SplashScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        SalesScreen.routeName: (context) => const SalesScreen(),
        InventoryScreen.routeName: (context) => const InventoryScreen(),
        ClientsScreen.routeName: (context) => const ClientsScreen(),
      },
    );
  }
}

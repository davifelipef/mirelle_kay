import 'package:mirelle_kay/widgets/app_bar.dart';
import 'package:mirelle_kay/widgets/balance_card.dart';
import 'package:mirelle_kay/widgets/date_selection.dart';
import 'package:mirelle_kay/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarDesign(),
      body: Column(
        children: [
          DateSelection(pageController: calcPageController()),
          const BalanceCard(),
          // TODO - Rest of the code
        ],
      ),
    );
  }
}

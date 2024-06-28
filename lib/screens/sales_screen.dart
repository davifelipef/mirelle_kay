import 'package:mirelle_kay/widgets/app_bar.dart';
import 'package:mirelle_kay/widgets/sales_card.dart';
import 'package:mirelle_kay/widgets/date_selection.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mirelle_kay/widgets/drawer.dart';

class SalesScreen extends StatefulWidget {
  static const String routeName = "/sales";
  const SalesScreen({super.key});
  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    super.initState();
    updatePageTitle("Vendas");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarDesign(),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 10.0),
            child: DateSelection(pageController: calcPageController()),
          ),
          const SalesCard(),
          const Divider(),
          // TODO - Rest of the code
        ],
      ),
    );
  }
}

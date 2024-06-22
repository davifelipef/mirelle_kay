import 'package:mirelle_kay/widgets/app_bar.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mirelle_kay/widgets/drawer.dart';

class InventoryScreen extends StatefulWidget {
  static const String routeName = "/inventory";
  const InventoryScreen({super.key});
  @override
  State<InventoryScreen> createState() => _InventoryScreen();
}

class _InventoryScreen extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    updatePageTitle("Estoque");
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarDesign(),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 10.0),
            child: Placeholder(),
          ),
          // TODO - Rest of the code
        ],
      ),
    );
  }
}

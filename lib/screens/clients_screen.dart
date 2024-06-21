import 'package:mirelle_kay/widgets/app_bar.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mirelle_kay/widgets/drawer.dart';

class ClientsScreen extends StatefulWidget {
  static const String routeName = "/clients";
  const ClientsScreen({super.key});
  @override
  State<ClientsScreen> createState() => _ClientsScreen();
}

class _ClientsScreen extends State<ClientsScreen> {
  @override
  void initState() {
    super.initState();
    updatePageTitle("Clientes");
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
            child: Placeholder(),
          ),
          // TODO - Rest of the code
        ],
      ),
    );
  }
}

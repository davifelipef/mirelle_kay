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
    return const Scaffold(
      appBar: AppBarDesign(),
      drawer: MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 10.0),
            child: Center(child: Text("Em construção.")),
          ),
          // TODO - Rest of the code
        ],
      ),
    );
  }
}

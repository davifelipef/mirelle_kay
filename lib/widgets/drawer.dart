import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/config.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      ListTile(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Mirelle Kay',
            style: TextStyle(
              fontSize: 20,
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        tileColor: mainColor, // Custom background color
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),*/
        onTap: () {
          // Handle user profile tap
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.person,
          color: whiteColor,
        ),
        title: const Text(
          'Nome do usuário',
          style: TextStyle(
            fontSize: 15,
            color: whiteColor,
          ),
        ),
        subtitle: const Text(
          'E-mail do usuário',
          style: TextStyle(
            fontSize: 15,
            color: whiteColor,
          ),
        ),
        tileColor: secondColor, // Custom background color
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),*/
        onTap: () {
          // Handle user profile tap
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.home,
          color: whiteColor,
        ),
        title: const Text(
          'Vendas',
          style: TextStyle(
            fontSize: 15,
            color: whiteColor,
          ),
        ),
        tileColor: mainColor,
        onTap: () {
          // Handle user profile tap
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.inventory_2,
          color: whiteColor,
        ),
        title: const Text(
          'Estoque',
          style: TextStyle(
            fontSize: 15,
            color: whiteColor,
          ),
        ),
        tileColor: mainColor,
        onTap: () {
          // Handle user profile tap
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.group,
          color: whiteColor,
        ),
        title: const Text(
          'Clientes',
          style: TextStyle(
            fontSize: 15,
            color: whiteColor,
          ),
        ),
        tileColor: mainColor,
        onTap: () {
          // Handle user profile tap
        },
      ),
    ]));
  }
}

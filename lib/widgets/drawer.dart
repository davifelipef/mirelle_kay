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
              color: Colors.black,
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
        leading: const Icon(Icons.person),
        title: const Text('User name'),
        subtitle: const Text('User e-mail'),
        tileColor: mainColor, // Custom background color
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),*/
        onTap: () {
          // Handle user profile tap
        },
      ),
    ]));
  }
}

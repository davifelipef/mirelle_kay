import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/config.dart';

class AppBarDesign extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDesign({super.key});

  final defaultIconTheme =
      const IconThemeData(color: Color.fromARGB(235, 255, 255, 255));
  final appBarBackground = const Color.fromRGBO(202, 154, 254, 1);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Vendas",
        style: TextStyle(
          fontSize: 20,
          color: whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      iconTheme: defaultIconTheme,
      backgroundColor: appBarBackground,
    );
  }
}

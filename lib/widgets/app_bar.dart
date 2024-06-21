import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/config.dart';

class AppBarDesign extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDesign({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        pageTitle,
        style: const TextStyle(
          fontSize: 20,
          color: whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      iconTheme: defaultIconTheme,
      backgroundColor: mainColor,
    );
  }
}

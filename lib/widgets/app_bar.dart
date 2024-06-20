import 'package:flutter/material.dart';

class AppBarDesign extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDesign({super.key});

  final defaultIconTheme = const IconThemeData(color: Colors.white10);
  final appBarBackground = const Color.fromRGBO(202, 154, 254, 1);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Mirelle Kay",
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      iconTheme: defaultIconTheme,
      backgroundColor: appBarBackground,
    );
  }
}

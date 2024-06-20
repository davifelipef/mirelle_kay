import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/helper_functions.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: sumOfEvents() >= 0
          ? positiveBalanceBackground
          : negativeBalanceBackground,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
        title: Text(
          "Balanço: R\$ ${sumOfEvents().toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

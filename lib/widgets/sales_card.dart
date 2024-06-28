import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:mirelle_kay/providers/filtered_sales.dart';

class SalesCard extends StatelessWidget {
  const SalesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Provider.of<FilteredSalesProvider>(context).currentBalance >= 0
          ? positiveBalanceBackground
          : negativeBalanceBackground,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
        title: Consumer<FilteredSalesProvider>(
          builder: (_, provider, __) => Text(
            "Balanço: R\$ ${provider.currentBalance.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

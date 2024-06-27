import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:mirelle_kay/providers/filtered_events.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Provider.of<FilteredEventsProvider>(context).currentBalance >= 0
          ? positiveBalanceBackground
          : negativeBalanceBackground,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
        title: Consumer<FilteredEventsProvider>(
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

import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:mirelle_kay/utils/config.dart';

class EventsList extends StatelessWidget {
  final List<dynamic> events;

  const EventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (_, index) {
          final event = events[index];
          String valueString = event["value"] ?? "0.0";
          Color cardColor = valueString.contains('-') ? cardRed : cardGreen;
          return Card(
            color: cardColor,
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text(
                event["name"] ?? "Erro ao retornar o nome",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Data: ${event["date"].toString()}"),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Tipo de evento: ${event["type"].toString()}"),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Valor: R\$ ${event["value"].toString()}"),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => showForm(
                      context,
                      null,
                      event["key"],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteItem(
                      event["key"],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

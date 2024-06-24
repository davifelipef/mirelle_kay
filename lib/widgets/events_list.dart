import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:mirelle_kay/utils/config.dart';

class EventsList extends StatelessWidget {
  const EventsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (_, index) {
          final currentItem = events[index];
          String valueString = currentItem["value"] ?? "0.0";
          Color cardColor = valueString.contains('-') ? cardRed : cardGreen;
          return Card(
            color: cardColor,
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text(
                currentItem["name"] ?? "Erro ao retornar o nome",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Data: ${currentItem["date"].toString()}"),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        "Tipo de evento: ${currentItem["type"].toString()}"),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child:
                        Text("Valor: R\$ ${currentItem["value"].toString()}"),
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
                      currentItem["key"],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteItem(
                      currentItem["key"],
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

import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:mirelle_kay/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:mirelle_kay/providers/filtered_events.dart';

class EventsList extends StatelessWidget {
  final List<dynamic> events;

  const EventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final filteredEventsProvider =
        Provider.of<FilteredEventsProvider>(context, listen: false);
    print("Events list received: ${events.length} items");
    return ListView.builder(
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (_, index) {
        final event = events[index];
        String valueString = event["value"] ?? "0.0";
        Color cardColor = valueString.contains('-') ? cardRed : cardGreen;
        // Add a print statement here to see the received event data
        print("Event at index $index: $event");
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Data: ${event["date"].toString()}"),
                Text("Tipo de evento: ${event["type"].toString()}"),
                Text("Valor: R\$ ${event["value"].toString()}"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Edit button setup
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    print("Edit button clicked, showForm called");
                    showForm(context, formattedDate, event["key"],
                        filteredEventsProvider);
                  },
                ),
                // Delete button setup
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    print("Delete button clicked");
                    deleteItem(event["key"], filteredEventsProvider);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

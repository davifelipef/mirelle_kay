import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:mirelle_kay/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:mirelle_kay/providers/filtered_events.dart';

class AddEventButton extends StatelessWidget {
  const AddEventButton({super.key, required this.filteredEventsProvider});

  final FilteredEventsProvider filteredEventsProvider;

  @override
  Widget build(BuildContext context) {
    formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
    return FloatingActionButton(
      onPressed: () {
        print(
            'Add new event button clicked, showForm called'); // Debugging statement
        showForm(context, formattedDate, null, filteredEventsProvider);
      },
      backgroundColor: primaryButton,
      foregroundColor: primaryBackground,
      child: const Icon(Icons.add),
    );
  }
}

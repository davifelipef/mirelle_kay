import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:mirelle_kay/utils/config.dart';
import 'package:intl/intl.dart';

class AddEventButton extends StatelessWidget {
  const AddEventButton({super.key});

  @override
  Widget build(BuildContext context) {
    formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
    return FloatingActionButton(
      onPressed: () {
        print('FloatingActionButton pressed'); // Debugging statement
        showForm(context, formattedDate, null);
      },
      backgroundColor: primaryButton,
      foregroundColor: primaryBackground,
      child: const Icon(Icons.add),
    );
  }
}

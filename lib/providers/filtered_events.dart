import 'package:flutter/material.dart';

class FilteredEventsProvider extends ChangeNotifier {
  List<dynamic> _filteredData = [];

  List<dynamic> get filteredData => _filteredData;

  // Calculate current balance
  double get currentBalance {
    double total = 0.0;
    for (final event in _filteredData) {
      final valueString = event["value"] ?? "0.0";
      final eventValue =
          double.tryParse(valueString.replaceAll(',', '.')) ?? 0.0;
      total += eventValue;
    }
    return total;
  }

  void updateFilteredData(List<dynamic> newData) {
    _filteredData = newData;
    notifyListeners(); // Notify listeners about the change
  }
}

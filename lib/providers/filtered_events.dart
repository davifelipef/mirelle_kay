import 'package:flutter/material.dart';

class FilteredEventsProvider extends ChangeNotifier {
  List<dynamic> _filteredData = [];

  List<dynamic> get filteredData => _filteredData;

  void updateFilteredData(List<dynamic> newData) {
    _filteredData = newData;
    notifyListeners(); // Notify listeners about the change
  }
}

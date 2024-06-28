import 'package:flutter/material.dart';

class FilteredSalesProvider extends ChangeNotifier {
  List<dynamic> _filteredSales = [];

  List<dynamic> get filteredSales => _filteredSales;

  // Calculate current balance
  double get currentBalance {
    double total = 0.0;
    for (final sale in _filteredSales) {
      final saleString = sale["value"] ?? "0.0";
      final saleValue = double.tryParse(saleString.replaceAll(',', '.')) ?? 0.0;
      total += saleValue;
    }
    return total;
  }

  void updateFilteredSales(List<dynamic> newSale) {
    _filteredSales = newSale;
    notifyListeners(); // Notify listeners about the change
  }
}

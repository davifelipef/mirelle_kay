import 'package:mirelle_kay/utils/config.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

void updatePageTitle(String title) {
  pageTitle = title;
}

// Helper function that updates the current date by calculating the new date based on the index
void updateCurrentDate(int index) {
  currentDate = calculateDate(index);
  refreshItems();
}

// Calculates the target date based on the given index
DateTime calculateDate(int index) {
  DateTime currentDate =
      DateTime.now(); // Gets the current date to use in the calculations
  int targetMonth = currentDate.month +
      (index - initialPage); // Calculates the target month and year
  int targetYear = currentDate.year;
  while (targetMonth <= 0) {
    // Adjusts the target month and year if it's less than 0 (January)
    targetYear--; // Subtracts a year
    targetMonth +=
        12; // Adds 12 months (Making it December from the previous year)
  }
  while (targetMonth > 12) {
    // Adjusts the target month and year if it's greater than 12 (December)
    targetYear++; // Adds a year
    targetMonth -=
        12; // Subtracts 12 months (Making it Jannuary of the next year)
  }
  return DateTime(targetYear, targetMonth,
      1); // Creates and returns the newly DateTime object
}

// Function that sums the events
double sumOfEvents() {
  double total = 0.0;
  for (final item in events) {
    // Retrieve the event value
    final eventValue = item["value"] ?? "0,00";
    // Convert the value to a double, replacing commas with dots if necessary
    final eventsSum = double.tryParse(eventValue.replaceAll(',', '.')) ?? 0.00;
    // Add the value to the total sum
    total += eventsSum;
  }
  return total;
}

// Updates the screen when a new event is added
Future<List> refreshItems() async {
  final data = eventsBox.keys.map((key) {
    final item = eventsBox.get(key);
    return {
      "key": key, // unique key of the event
      "name": item["name"], // name of the event
      "type": item["type"], // type of the event: money entry or exit
      "value": item["value"], // value moved
      "date": item["date"], // date the event was registered
      "dateTime": DateFormat('dd/MM/yyyy').parse(item["date"]), // parsed date
    };
  }).toList();

  // Sort the list based on the "dateTime" field in descending order - from b to a
  data.sort((a, b) =>
      (b["dateTime"] as DateTime).compareTo(a["dateTime"] as DateTime));

  // Filters the list based on the selected month
  final filteredData = data.where((item) {
    final itemDate = item["dateTime"] as DateTime;
    return itemDate.year == currentDate.year &&
        itemDate.month == currentDate.month;
  }).toList();

  return filteredData;
}

// Updates the page controller
PageController calcPageController() {
  pageController = PageController(initialPage: initialPage);
  refreshItems();
  return pageController;
}

Future<void> loadJsonToHive() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(path.join(directory.path, 'products.json'));

  if (await file.exists()) {
    final jsonString = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(jsonString);

    for (var i = 0; i < jsonData.length; i++) {
      final product = jsonData[i];
      productsBox.put(i, product);
    }

    print('Data loaded from JSON to Hive');
  } else {
    print('JSON file not found');
  }
}

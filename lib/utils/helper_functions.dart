import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

// Text fields setup variables
final TextEditingController _nameController = TextEditingController();
final TextEditingController _typeController = TextEditingController();
final TextEditingController _dateController = TextEditingController();
String? selectedType;
final List<String> typeOptions = ['Entrada', 'Saída'];
final TextEditingController _valueController = TextEditingController();
final _formKey = GlobalKey<FormState>();

// Hive related setup
Map<int, String> eventsMap = {};
List<Map<String, dynamic>> _events = [];
var eventsList = [];
final _eventsBox = Hive.box("events_box");

// Date setup variables
late DateTime currentDate;
late DateTime initialDate;
late String formattedDate;

// Page navigation variables
late PageController pageController; // Declares the page controller variable
const initialPage = 1200; // Sets initial page as 1200

// Layout related variables
late PageController _pageController; // Declares the page controller variable
final defaultIconTheme = const IconThemeData(color: Colors.white);
final positiveBalanceBackground = Colors.blue.shade100;
final negativeBalanceBackground = Colors.red.shade100;
final primaryButton = Colors.black;
final primaryBackground = Colors.white;
final cardGreen = Colors.green.shade100;
final cardRed = Colors.yellow.shade100;
int _deletedItemCount = 0; // Starts the count of deleted messages at zero
Timer? _messageTimer;

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
  for (final item in _events) {
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
  final data = _eventsBox.keys.map((key) {
    final item = _eventsBox.get(key);
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

import 'package:mirelle_kay/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:hive_flutter/hive_flutter.dart';

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
Future<List<dynamic>> refreshItems() async {
  final data = eventsBox.keys.map((key) {
    final item = eventsBox.get(key);
    return {
      "key": key, // unique key of the event
      "name": item!["name"], // name of the event
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

Future<void> loadEventsFromHive() async {
  try {
    final box = Hive.box<Map<dynamic, dynamic>>('events_box');
    events = box.values.map((item) {
      return item.cast<String, dynamic>();
    }).toList();
    print("Loaded events from Hive: $events");
  } catch (e) {
    print("Error loading events from Hive: $e");
  }
}

// Creates a new item
Future<void> createItem(Map<String, dynamic> newEvent) async {
  try {
    print("Creating item: $newEvent");
    await eventsBox.add(newEvent);
    print("Item created successfully.");
    loadEventsFromHive();
    refreshItems(); // Updates the UI
  } catch (e) {
    print("Error creating item: $e");
  }
}

// Update an existing item
Future<void> updateItem(int itemKey, Map<String, dynamic> item) async {
  await eventsBox.put(itemKey, item);
  await loadEventsFromHive();
  await refreshItems(); // Updates the UI
}

// Delete an existing item
Future<void> deleteItem(int itemKey) async {
  eventsMap.remove(itemKey);
  print("$itemKey removed from the eventsMap");
  print("Current eventsMap: $eventsList");

  // Get the name associated with the itemKey being deleted
  final item = events.firstWhere((element) => element["key"] == itemKey);
  final nameToDelete = item["name"];

  await eventsBox.delete(itemKey);
  print("$itemKey removed from the nameBox");
  print("Current nameBox: $eventsList");

  // Remove the name from eventsList
  eventsList.remove(nameToDelete);
  print("$itemKey removed from the eventsList");
  print("Current eventsList: $eventsList");

  deletedItemCount++;

  // Reset the timer if it's already running
  /*messageTimer?.cancel();
    messageTimer = Timer(const Duration(seconds: 1), deletedItemMessage);*/

  await loadEventsFromHive();
  await refreshItems(); // Updates the UI
}

// Message to inform an item was deleted
/*Future<void> deletedItemMessage() async {
    if (deletedItemCount > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$deletedItemCount itens deletados."),
        ),
      );
      // Reset the deleted item count
      deletedItemCount = 0;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item deletado."),
        ),
      );
      // Reset the count
      deletedItemCount = 0;
    }
  }*/

// Creates the dialog to add new names to the name list
void showForm(BuildContext ctx, String? formattedDate, int? itemKey) async {
  print("Show form function called");
  if (itemKey != null) {
    final existingItem =
        events.firstWhere((element) => element["key"] == itemKey);
    nameController.text = existingItem["name"];
    dateController.text = existingItem["date"];
    selectedType = existingItem["type"];
    valueController.text = existingItem["value"];
    formattedDate = existingItem["date"];
  } else {
    // Clear the text fields
    nameController.text = "";
    dateController.text = formattedDate.toString();
    selectedType = null;
    valueController.text = "0.00";
  }

  showModalBottomSheet(
    context: ctx,
    builder: (_) => Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
        top: 15,
        left: 15,
        right: 15,
      ),
      child: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            DateTime? tempPickedDate = currentDate;
            return Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  // Name of the event text field
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Nome do registro",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite um nome para o registro.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Date edit field
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      hintText: "Data do registro",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe uma data para o registro.';
                      }
                      return null;
                    },
                    readOnly:
                        true, // Makes the field read-only so that the keyboard won't appear
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: tempPickedDate ??
                            currentDate, // Use the current date as the initial date
                        firstDate: DateTime(
                            2000), // Set the earliest date that can be picked
                        lastDate: DateTime(
                            2101), // Set the latest date that can be picked
                      );

                      if (pickedDate != tempPickedDate) {
                        setState(() {
                          tempPickedDate = pickedDate;
                          dateController.text =
                              DateFormat('dd/MM/yyyy').format(tempPickedDate!);
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Type of event dropdown menu
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      hintText: "Escolha um tipo de registro",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedType,
                    items: typeOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedType = newValue;
                        if (valueController.text.isNotEmpty) {
                          double currentValue =
                              double.tryParse(valueController.text) ?? 0.0;
                          if (selectedType == 'Entrada' && currentValue < 0) {
                            valueController.text = (-currentValue).toString();
                          } else if (selectedType == 'Saída' &&
                              currentValue > 0) {
                            valueController.text = (-currentValue).toString();
                          }
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, escolha um tipo de registro.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Value of the event number field
                  TextFormField(
                    controller: valueController,
                    decoration: const InputDecoration(
                      hintText: "Valor",
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits
                    ],
                    onChanged: (text) {
                      if (text.isEmpty) {
                        // Set default value '0.00' if text is empty
                        valueController.text = '0.00';
                        return;
                      }

                      // Parse the input text as a decimal number
                      double currentValue = double.tryParse(text) ?? 0.0;

                      // Shift the decimal point for each digit entered
                      currentValue = currentValue / 100.0;

                      // Handle the logic for 'Entrada' and 'Saída'
                      if (selectedType == 'Entrada' && currentValue < 0) {
                        currentValue = -currentValue;
                      } else if (selectedType == 'Saída' && currentValue > 0) {
                        currentValue = -currentValue;
                      }

                      // Format the value to 2 decimal places
                      String formattedText = currentValue.toStringAsFixed(2);

                      // Update the text field with the formatted value
                      valueController.text = formattedText;

                      // Move cursor to end of text after modifying the value
                      valueController.selection = TextSelection.fromPosition(
                        TextPosition(offset: valueController.text.length),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '0.00') {
                        return 'Por favor, informe um valor.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryButton,
                      foregroundColor: primaryBackground,
                    ),
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        final newEvent = {
                          "name": nameController.text,
                          "type": selectedType,
                          "value": valueController.text,
                          "date": formattedDate,
                        };
                        if (itemKey == null) {
                          await createItem(newEvent);
                        } else {
                          await updateItem(itemKey, newEvent);
                        }
                        // Clear the text fields
                        nameController.clear();
                        dateController.text = formattedDate.toString();
                        selectedType = null;
                        valueController.clear();
                        Navigator.of(context).pop(); // Closes the modal window
                      }
                    },
                    child: const Text("Salvar"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

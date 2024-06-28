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
import 'package:mirelle_kay/providers/filtered_events.dart';

void updatePageTitle(String title) {
  pageTitle = title;
}

// Helper function that updates the current date by calculating the new date based on the index
void updateCurrentDate(int index) {
  currentDate = calculateDate(index);
  refreshItems;
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

// Updates the page controller
PageController calcPageController() {
  pageController = PageController(initialPage: initialPage);
  refreshItems;
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
  } else {
    // Do nothing
  }
}

// Events creation related code
// Updates the screen when a new event is added
Future<List<dynamic>> refreshItems(FilteredEventsProvider provider) async {
  final data = eventsBox.keys
      .map((key) {
        final item = eventsBox.get(key);
        // Ensure item is not null and of the correct type
        if (item != null) {
          final eventItem = item.cast<String, dynamic>();
          events.add(eventItem);
          return {
            "key": key,
            "name": eventItem["name"],
            "type": eventItem["type"],
            "value": eventItem["value"],
            "date": eventItem["date"],
            "dateTime": DateFormat('dd/MM/yyyy').parse(eventItem["date"]),
          };
        } else {
          return null;
        }
      })
      .where((item) => item != null)
      .toList();

  data.sort((a, b) =>
      (b?["dateTime"] as DateTime).compareTo(a?["dateTime"] as DateTime));

  final filteredData = data.where((item) {
    final itemDate = item?["dateTime"] as DateTime;
    return itemDate.year == currentDate.year &&
        itemDate.month == currentDate.month;
  }).toList();

  provider.updateFilteredData(filteredData);

  return filteredData;
}

// Load the events from the Hive
Future<void> loadEventsFromHive(FilteredEventsProvider provider) async {
  try {
    final box = Hive.box<Map<dynamic, dynamic>>('events_box'); // Adjusted type
    events = box.values.map((item) {
      return item.cast<String, dynamic>();
    }).toList();

    await refreshItems(provider);
  } catch (e) {
    print("Error loading events from Hive: $e");
  }
}

// Creates a new item
Future<void> createItem(Map<String, dynamic> newEvent, VoidCallback onComplete,
    FilteredEventsProvider provider) async {
  try {
    await eventsBox.add(newEvent);

    onComplete(); // Notify UI
  } catch (e) {
    print("Error creating item: $e");
  }
}

// Update an existing item
Future<void> updateItem(int itemKey, Map<String, dynamic> item,
    FilteredEventsProvider provider) async {
  await eventsBox.put(itemKey, item);
  await refreshItems(provider); // Updates the UI and notifies listeners
}

// Delete an existing item
Future<void> deleteItem(int itemKey, FilteredEventsProvider provider) async {
  await eventsBox.delete(itemKey);
  await refreshItems(provider); // Updates the UI and notifies listeners
}

void showForm(BuildContext ctx, String? formattedDate, int? itemKey,
    FilteredEventsProvider provider) async {
  // Check if itemKey is provided and not null
  if (itemKey != null) {
    // Find the item with the specified itemKey directly in the Hive box
    final existingItem = eventsBox.get(itemKey)?.cast<String, dynamic>() ?? {};

    // Load existing item data into form fields
    if (existingItem.isNotEmpty) {
      nameController.text = existingItem["name"];
      dateController.text = existingItem["date"];
      selectedType = existingItem["type"];
      valueController.text = existingItem["value"];
      formattedDate = existingItem["date"];
    } else {
      // Handle case where itemKey is not found in events list (debug or error handling)
      // Reset form fields or show appropriate message
      nameController.text = "";
      dateController.text = formattedDate.toString();
      selectedType = null;
      valueController.text = "0.00";
    }
  } else {
    // Handle case when adding a new item (itemKey is null)
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
                  const SizedBox(height: 20),
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
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: tempPickedDate ?? currentDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: valueController,
                    decoration: const InputDecoration(
                      hintText: "Valor",
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (text) {
                      if (text.isEmpty) {
                        valueController.text = '0.00';
                        return;
                      }

                      double currentValue = double.tryParse(text) ?? 0.0;
                      currentValue = currentValue / 100.0;

                      if (selectedType == 'Entrada' && currentValue < 0) {
                        currentValue = -currentValue;
                      } else if (selectedType == 'Saída' && currentValue > 0) {
                        currentValue = -currentValue;
                      }

                      String formattedText = currentValue.toStringAsFixed(2);
                      valueController.text = formattedText;

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
                  const SizedBox(height: 20),
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
                          "date": dateController.text,
                        };
                        if (itemKey == null) {
                          await createItem(newEvent, () async {
                            await refreshItems(provider);
                          }, provider);
                        } else {
                          final updatedEvent = {
                            "key": itemKey,
                            "name": nameController.text,
                            "type": selectedType,
                            "value": valueController.text,
                            "date": dateController.text,
                          };
                          await updateItem(itemKey, updatedEvent, provider);
                        }
                        if (context.mounted) {
                          // Using context.mounted check
                          nameController.clear();
                          dateController.text = formattedDate.toString();
                          selectedType = null;
                          valueController.clear();
                          Navigator.of(context).pop();
                        }
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

// Function that sums the events
double sumOfEvents(List<dynamic> events) {
  double total = 0.0;
  for (final item in events) {
    // Retrieve the event value
    final eventValue = item["value"] ?? "0.00";
    // Convert the value to a double, replacing commas with dots if necessary
    final eventsSum = double.tryParse(eventValue.replaceAll(',', '.')) ?? 0.00;
    // Add the value to the total sum
    total += eventsSum;
  }
  return total;
}

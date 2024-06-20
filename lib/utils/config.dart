import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
List<Map<String, dynamic>> events = [];
var eventsList = [];
final eventsBox = Hive.box("events_box");

// Date setup variables
late DateTime currentDate;
late DateTime initialDate;
late String formattedDate;

// Page navigation variables
String appBarTitle = "Vendas";
late PageController pageController; // Declares the page controller variable
const initialPage = 1200; // Sets initial page as 1200

// Layout related variables
const defaultIconTheme = IconThemeData(color: Colors.white);
const mainColor = Color.fromRGBO(202, 154, 254, 1);
final positiveBalanceBackground = Colors.blue.shade100;
final negativeBalanceBackground = Colors.red.shade100;
const primaryButton = Colors.black;
const primaryBackground = Colors.white;
final cardGreen = Colors.green.shade100;
final cardRed = Colors.yellow.shade100;
int _deletedItemCount = 0; // Starts the count of deleted messages at zero
Timer? _messageTimer;

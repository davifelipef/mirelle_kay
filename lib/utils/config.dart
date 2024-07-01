import 'package:flutter/material.dart';
import 'dart:async';

// Text fields setup variables
final TextEditingController nameController = TextEditingController();
final TextEditingController typeController = TextEditingController();
final TextEditingController dateController = TextEditingController();
String? selectedType;
final List<String> typeOptions = ['Entrada', 'Saída'];
final TextEditingController valueController = TextEditingController();
final formKey = GlobalKey<FormState>();

// Date setup variables
var currentDate = DateTime.now();
late DateTime initialDate;
late String formattedDate;

// Page navigation variables
String pageTitle = "";
late PageController pageController; // Declares the page controller variable
const initialPage = 1200; // Sets initial page as 1200

// Layout related variables
const defaultIconTheme = IconThemeData(color: Colors.white);
const mainColor = Color.fromRGBO(202, 154, 254, 1);
const secondColor = Color.fromRGBO(164, 125, 206, 1);
const whiteColor = Color.fromRGBO(255, 255, 255, 1);
final positiveBalanceBackground = Colors.blue.shade100;
final negativeBalanceBackground = Colors.red.shade100;
const primaryButton = Colors.black;
const primaryBackground = Colors.white;
final cardGreen = Colors.green.shade100;
final cardRed = Colors.yellow.shade100;
int deletedItemCount = 0; // Starts the count of deleted messages at zero
Timer? messageTimer;

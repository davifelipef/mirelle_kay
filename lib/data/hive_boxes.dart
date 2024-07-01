import 'package:hive/hive.dart';
import 'package:dio/dio.dart';

// Hive related setup - Events
Map<int, String> eventsMap = {};
List<Map<String, dynamic>> events = [];
var eventsList = [];
final eventsBox = Hive.box<Map<dynamic, dynamic>>("events_box");

// Hive related setup - Products
final dio = Dio();
Set<int> fetchedProductKeys = {};
Map<int, String> productsMap = {};
List<Map<String, dynamic>> products = [];
var productsList = [];
final productsBox = Hive.box("products_box");

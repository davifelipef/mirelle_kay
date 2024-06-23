import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:flutter/services.dart' show rootBundle; // Import rootBundle
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mirelle_kay/widgets/app_bar.dart';
import 'package:mirelle_kay/widgets/drawer.dart';

class InventoryScreen extends StatefulWidget {
  static const String routeName = "/inventory";

  const InventoryScreen({super.key});

  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    updatePageTitle("Estoque");
    checkAndLoadProducts();
  }

  Future<void> checkAndLoadProducts() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/products.json');
      await loadJsonToHive(jsonString);
      loadProductsFromHive();
    } catch (e) {
      print('Error loading JSON: $e');
      // Handle error appropriately (e.g., show error message)
    }
  }

  Future<void> loadJsonToHive(String jsonString) async {
    final List<dynamic> jsonData = jsonDecode(jsonString);

    for (var i = 0; i < jsonData.length; i++) {
      final product = jsonData[i];
      Hive.box('products_box').put(i, product);
    }

    print('Data loaded from JSON to Hive');
  }

  void loadProductsFromHive() {
    final box = Hive.box('products_box');
    setState(() {
      products = box.values.toList().cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarDesign(),
      drawer: const MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (products.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var product = products[index];
                    return Card(
                      child: ListTile(
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: Center(
                            child: Image.network(
                              product['imageUrl'],
                            ),
                          ),
                        ),
                        title: Text(product['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Preço: R\$ ${product['price']}'),
                            Text(
                                'Número de referência: ${product['referenceNumber']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

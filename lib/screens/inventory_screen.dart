import 'package:flutter/material.dart';
import 'package:mirelle_kay/utils/helpers.dart';
import 'package:mirelle_kay/services/products_service.dart'; // Import your updated fetch function
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
    fetchProductDetails(); // Call to fetch and store products in Hive
    loadProductsFromHive(); // Load products from Hive after fetching
  }

  void loadProductsFromHive() {
    // Load products from Hive
    products = List<Map<String, dynamic>>.from(productsBox.values);
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
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return ListTile(
                    leading: Image.network(product['image']),
                    title: Text(product['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Preço: ${product['price']}'),
                        Text(
                            'Número de referência: ${product['referenceNumber']}'),
                        Text('Disponibilidade: ${product['availability']}'),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

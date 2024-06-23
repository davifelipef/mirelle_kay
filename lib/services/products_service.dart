import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

List<Map<String, String>> productsList = [];

Future<void> fetchProductDetails() async {
  const sitemapUrl = 'https://loja.marykay.com.br/sitemap/product-0.xml';

  final sitemapResponse = await http.get(Uri.parse(sitemapUrl));

  int productKey = 0;
  Set<int> fetchedProductKeys = {};

  if (sitemapResponse.statusCode == 200) {
    print("Response OK");

    var document = parse(sitemapResponse.body);
    var urls = document.getElementsByTagName('loc');

    for (var urlElement in urls) {
      var productUrl = urlElement.text;
      final response = await http.get(Uri.parse(productUrl));

      if (response.statusCode == 200) {
        var productDocument = parse(response.body);

        // Extract product name
        var titleElement =
            productDocument.querySelector('title[data-react-helmet="true"]');
        var productName = titleElement?.text ?? '';

        // Filter out "- Mary Kay" from product name
        productName = productName.replaceAll('- Mary Kay', '').trim();

        // Extract product image URL
        var imageElement =
            productDocument.querySelector('meta[property="og:image"]');
        var imageUrl = imageElement?.attributes['content'] ?? '';

        // Extract product price
        var priceElement = productDocument
            .querySelector('meta[property="product:price:amount"]');
        var price = priceElement?.attributes['content'] ?? '';

        // Extract product reference number
        var skuElement =
            productDocument.querySelector('meta[property="product:sku"]');
        var referenceNumber = skuElement?.attributes['content'] ?? '';

        // Extract product availability
        var availabilityElement = productDocument
            .querySelector('meta[property="product:availability"]');
        var availability = availabilityElement?.attributes['content'] ?? '';

        if (availability != 'oos') {
          productKey++;
          fetchedProductKeys.add(productKey);

          //print('Produtos armazenados: ${fetchedProductKeys.length}');

          // Add product details to productsList
          productsList.add({
            'key': productKey.toString(),
            'name': productName,
            'imageUrl': imageUrl,
            'price': price,
            'referenceNumber': referenceNumber,
            'availability': availability,
          });

          await printProducts(productKey, productName, imageUrl, price,
              referenceNumber, availability);
        } else {
          print('$productName está fora de estoque.');
          print('---');
        }
      } else {
        print('Failed to load product details');
      }
    }

    // After processing all products, save to JSON
    //await saveProducts();
  } else {
    print('Failed to load sitemap');
  }
}

Future<void> printProducts(productKey, productName, imageUrl, price,
    referenceNumber, availability) async {
  var productJson = {
    'key': productKey.toString(),
    'name': productName,
    'imageUrl': imageUrl,
    'price': price,
    'referenceNumber': referenceNumber,
    'availability': availability,
  };

  // Print product in JSON format
  print(jsonEncode(productJson));
}

Future<void> saveProducts() async {
  // Get the directory for the app's documents directory
  final directory = await getApplicationDocumentsDirectory();

  // Ensure that the assets/data directory exists
  final productsDirectory =
      Directory(path.join(directory.path, 'assets', 'data'));
  if (!await productsDirectory.exists()) {
    await productsDirectory.create(recursive: true);
  }

  // Create or overwrite products.json file with updated productsList
  final file = File(path.join(productsDirectory.path, 'products.json'));
  await file.writeAsString(jsonEncode(productsList));

  print('Data saved to lib/assets/data/products.json');
}
